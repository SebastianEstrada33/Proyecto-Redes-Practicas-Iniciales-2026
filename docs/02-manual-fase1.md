# Manual técnico · Fase 1

[Inicio](../README.md) · [Galería](../evidencias/README.md) · [Pruebas](03-pruebas-y-pendientes.md)

Este manual describe la configuración realizada y cómo verificarla. No es un instalador automático ni sustituye la revisión de una instalación existente. Las contraseñas de práctica se entregan al equipo por un canal privado.

## 1. Virtualización

En el HOST Intel se instaló VirtualBox y se creó SRV-PRINCIPAL con 2048 MB, dos procesadores virtuales, disco dinámico de 50 GB y EFI desactivado. Se instaló Windows Server 2012 R2 con interfaz gráfica. El cliente CLI-WINDOWS01 utiliza Windows 10 Pro, 2048 MB y disco de 40 GB. Las ISOs son medios de instalación: no se versionan en Git.

El servidor tiene IP 192.168.0.20/24. Para la topología actual, usar el adaptador host-only indicado en [arquitectura](01-arquitectura.md), con el DHCP de VirtualBox deshabilitado para que no compita con Windows DHCP. No conectar el DHCP del laboratorio por puente a la red doméstica.

**Validación:** encender servidor antes que cliente; comprobar adaptadores e IP del cliente y ejecutar `Test-NetConnection 192.168.0.20 -Port 80` desde el HOST. El resultado confirmado utilizó origen 192.168.0.200 e interfaz Ethernet.

**Evidencia:** [creación de VM](../evidencias/01-virtualizacion/01-virtualizacion.png).

## 2. Active Directory y DNS

1. Asignar el nombre SRV-PRINCIPAL y la IP fija antes de promover el servidor.
2. Agregar los roles AD DS y DNS desde Administrador del servidor.
3. Promover a un bosque nuevo `servidor1.com`, nombre NetBIOS `SERVIDOR1`, y reiniciar.
4. Abrir Usuarios y equipos de Active Directory, crear OU `UsuariosPracticas` y ubicar allí `usuario1` y `usuario2`.
5. Crear las cuentas `correo1` y `correo2` en AD para su integración con los buzones; disponer del usuario `privado` para el recurso restringido.
6. En el cliente Windows, utilizar el DNS 192.168.0.20 y unir CLI-WINDOWS01 a servidor1.com. Reiniciar e iniciar sesión con las cuentas del dominio.

Comprobar en PowerShell del servidor:

```powershell
Get-ADDomain | Select-Object DNSRoot,NetBIOSName,DomainMode
Get-ADUser usuario1
Get-ADUser usuario2
Resolve-DnsName srv-principal.servidor1.com -Server 127.0.0.1
Resolve-DnsName _ldap._tcp.servidor1.com -Type SRV -Server 127.0.0.1
Resolve-DnsName _ldap._tcp.dc._msdcs.servidor1.com -Type SRV -Server 127.0.0.1
```

Las zonas `servidor1.com` y `_msdcs.servidor1.com` están integradas en AD. Los registros LDAP locales responden con destino srv-principal.servidor1.com, puerto 389 e IP 192.168.0.20. Las dos consultas LDAP desde Ubuntu respondieron NOERROR al usar +noedns; falta confirmar el comportamiento normal del resolver.

**Evidencias:** [dominio](../evidencias/02-usuarios-dns-dhcp-gpo/02-dominio-dns.png), [usuarios](../evidencias/02-usuarios-dns-dhcp-gpo/04-usuarios-ad.png), [LDAP](../evidencias/02-usuarios-dns-dhcp-gpo/21-ldap-resolucion-local.png).

## 3. Políticas de grupo

Se creó `GPO-Usuarios-Practicas`, vinculada a la OU UsuariosPracticas.

- Fondo de escritorio institucional: imagen `\\SRV-PRINCIPAL\NETLOGON\usac.jpg` accesible al usuario, dentro de Configuración de usuario → Plantillas administrativas → Escritorio → Escritorio.
- Política alternativa de beneficio organizacional: impedir acceso al Panel de control y Configuración. Se utilizó `NoControlPanel=1` en `HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer`.

La restricción sustituye el cambio de título de Internet Explorer, que el enunciado reconoce como depreciado. El alcance efectivo actual son los usuarios de la OU; si se agregan usuarios fuera de ella debe revisarse la vinculación para cumplir el alcance solicitado.

En el cliente, con usuario del dominio:

```powershell
whoami
hostname
gpupdate /force
gpresult /r
```

Cerrar sesión y entrar de nuevo para observar el fondo. Intentar abrir Panel de control: debe mostrarse la restricción. No basta con que la GPO exista en el servidor.

**Evidencias:** [gpresult](../evidencias/02-usuarios-dns-dhcp-gpo/05-gpo-aplicada.png), [fondo](../evidencias/02-usuarios-dns-dhcp-gpo/06-fondo-institucional.png), [restricción](../evidencias/02-usuarios-dns-dhcp-gpo/07-gpo-restriccion.png).

## 4. DHCP

Se instaló y autorizó el servicio DHCP en Active Directory. Ámbito `RED-PRACTICAS`, red 192.168.0.0/24, rango inicial .1–.100 y exclusión .1–.25. El rango efectivo para concesiones es .26–.100. Opciones: DNS .20, sufijo servidor1.com. No se configuró puerta de enlace para la NIC aislada.

```powershell
Get-DhcpServerv4Scope
Get-DhcpServerv4ExclusionRange -ScopeId 192.168.0.0
Get-DhcpServerv4OptionValue -ScopeId 192.168.0.0
Get-DhcpServerv4Lease -ScopeId 192.168.0.0
```

En cliente Windows, usar dirección automática y comprobar `ipconfig /all`. Se observó .26. Repetir después de la migración a host-only y comprobar concesión en el servidor. Una IP fija correcta no demuestra DHCP.

**Evidencia:** [ámbito y exclusión](../evidencias/02-usuarios-dns-dhcp-gpo/03-dhcp.png).

## 5. Recursos SMB y permisos NTFS

| Recurso | Carpeta física | Acceso funcional previsto |
|---|---|---|
| CarpetaPública | C:\Inetpub\wwwroot\publicweb | Usuarios del dominio: crear, leer, modificar y eliminar |
| CarpetaPrivada | C:\Inetpub\wwwroot\privadaweb | Usuario privado: crear, leer, modificar y eliminar; otros usuarios de práctica sin acceso |

La carpeta privada compartida es la misma que utiliza la web privada. En SMB se configuró Change y en NTFS Modify para los usuarios autorizados. Se conservan los permisos administrativos y SYSTEM para administración del sistema. La identidad de PoolPrivado tiene lectura para servir el sitio.

En Explorador del cliente abrir `\\192.168.0.20\CarpetaPública`. Crear un archivo, editarlo, descargar/copiar y eliminarlo. Repetir con usuario1 y usuario2. Para el privado, comprobar primero la denegación con un usuario común y luego acceder como `SERVIDOR1\privado`. Si Windows conserva una conexión anterior al mismo servidor, cerrar esa conexión antes de cambiar credenciales; no eliminar indiscriminadamente conexiones ajenas.

```powershell
Get-SmbShare -Name 'CarpetaPública','CarpetaPrivada'
Get-SmbShareAccess -Name 'CarpetaPública'
Get-SmbShareAccess -Name 'CarpetaPrivada'
icacls C:\Inetpub\wwwroot\publicweb
icacls C:\Inetpub\wwwroot\privadaweb
```

Las pruebas de modificación y denegación desde Windows fueron confirmadas por el equipo. Falta capturarlas de forma completa desde Linux. [Permisos privados](../evidencias/03-recursos-compartidos/08-carpeta-privada-permisos.png).

## 6. IIS público, privado y redirección

Agregar IIS, documentos predeterminados y autenticación básica; para correo agregar CGI/FastCGI y HTTP Redirection.

- **Público:** `Default Web Site`, puerto 80; carpeta publicweb con index.html que muestra “Carpeta Pública”.
- **Privado:** sitio `WebPrivada`, pool `PoolPrivado`, puerto 1080 y ruta `/privadaweb/`; autenticación anónima deshabilitada, básica habilitada y autorización para `SERVIDOR1\privado`. El documento muestra “Carpeta Privada”.
- **Correo:** redirección HTTP de IIS en la ubicación `Default Web Site/correo`, destino `/webmail/`, respuesta 302 Found, sin crear carpeta física correo y sin código de redirección en HTML/PHP.

El siguiente comando refleja la configuración aplicada de la redirección; ejecutarlo solo al configurar esa función:

```powershell
& "$env:windir\System32\inetsrv\appcmd.exe" set config "Default Web Site/correo" /section:system.webServer/httpRedirect /enabled:true /destination:"/webmail/" /exactDestination:true /httpResponseStatus:Found /commit:apphost
```

Pruebas: acceso público sin credenciales; privado con usuario autorizado y con credenciales incorrectas; `/correo` debe responder 302 y abrir Roundcube. Luis obtuvo `Location: http://192.168.0.20/webmail` desde Ubuntu.

**Evidencias:** [público](../evidencias/06-web-iis/09-web-publica.png), [privado](../evidencias/06-web-iis/10-web-privada.png), [webmail cliente](../evidencias/04-correo/18-webmail-cliente.png).

## 7. FTP nativo de IIS

Agregar FTP Server y herramientas de administración. Crear sitio `FTP-Publico`, raíz `C:\Inetpub\wwwroot\publicweb`, IP .20 y puerto 21. Autenticación básica; anónima deshabilitada; reglas Read/Write para usuario1 y usuario2. Se eligió Sin SSL para la práctica aislada. FTP sin TLS no cifra sus credenciales por sí mismo.

Se configuró intervalo pasivo 50000–50010. Las reglas de firewall del laboratorio permiten TCP 21 y ese intervalo, con alcance de red y perfil de dominio. Conservar firewall activo y comprobar el perfil de red antes de ampliar reglas.

Para cada usuario, conectar, listar, descargar un archivo existente, subir otro y eliminar únicamente el archivo de prueba. Se comprobaron las operaciones localmente y desde Windows; la prueba remota de Luis debe utilizar modo pasivo, ya que los flujos de FTP activo pueden necesitar conexiones entrantes al cliente.

**Evidencias:** [usuario1](../evidencias/08-ftp/11-ftp-usuario1.png), [usuario2](../evidencias/08-ftp/12-ftp-usuario2.png), [pasivo](../evidencias/08-ftp/13-ftp-pasivo.png), [cliente](../evidencias/08-ftp/14-ftp-cliente-windows.png).

## 8. hMailServer y cuentas AD

Se instaló hMailServer 5.7.1 B3116 en SRV-PRINCIPAL. Crear dominio de correo `servidor1.com`, buzones correo1 y correo2 y habilitar SMTP 25, POP3 110 e IMAP 143.

En cada cuenta, pestaña Active Directory: activar integración, dominio servidor1.com y usuario AD correspondiente. La captura acredita esta pestaña para correo1 y la existencia de ambas cuentas en AD; falta capturar/revisar la pestaña equivalente de correo2. El éxito de envío por sí solo no demuestra la vinculación AD de ambas cuentas.

Verificar servicio y listeners:

```powershell
Get-Service hMailServer
netstat -ano | Select-String ':25\s|:110\s|:143\s'
```

POP3 se implementó con hMailServer porque el enunciado permite investigar una alternativa al rol eliminado de Windows Server 2012. La prueba POP local devolvió mensajes en correo2. SMTP entregó correos de prueba; Roundcube comprobó recepción y respuesta.

**Evidencia:** [integración AD y listeners](../evidencias/04-correo/15-correo-integracion-ad.png).

## 9. PHP y Roundcube

Componentes utilizados: PHP 8.3.35 x64 NTS VS16 y Roundcube 1.6.19 Complete. Se instaló el runtime Visual C++ compatible para resolver la dependencia de PHP.

1. PHP en `C:\PHP`, ejecutable FastCGI `C:\PHP\php-cgi.exe` y configuración php.ini basada en production.
2. Extensiones requeridas por el montaje: OpenSSL, mbstring, intl, fileinfo, PDO SQLite, SQLite3, curl, zip, gd y sockets; sesiones en `C:\PHP\Sessions`.
3. Roundcube en `C:\Inetpub\wwwroot\webmail`, convertido en **aplicación IIS** con pool `PoolCorreo` sin código administrado.
4. Handler PHP mediante FastCgiModule. Si IIS bloquea system.webServer/handlers, revisar delegación; no confundir una carpeta existente con una aplicación IIS.
5. Conceder lectura a la identidad del pool; Modify únicamente en temp, logs, sesiones y carpeta SQLite que lo requieren.
6. SQLite fuera del árbol web, en `C:\RoundcubeData\roundcube.db`; DSN Windows `sqlite:///C:/RoundcubeData/roundcube.db`.
7. IMAP local 127.0.0.1:143 y SMTP local 127.0.0.1:25, autenticación con el usuario y contraseña de la sesión. No versionar des_key ni configuraciones reales con secretos.
8. Ejecutar instalador, verificar esquema, escritura y pruebas IMAP/SMTP. Al finalizar, `enable_installer=false`, bloquear installer y carpetas privadas mediante requestFiltering y desactivar display_errors.

Se dejó la detección MIME apuntando a `C:/RoundcubeData/mime.types`, generada a partir de los tipos de IIS. El acceso al instalador después del cierre devolvió 404, confirmado por el equipo. No se acreditó todavía prueba de adjuntos.

**Evidencias:** [validación SQLite y directorios](../evidencias/04-correo/16-roundcube-validacion.png), [respuesta recibida](../evidencias/04-correo/17-correo-respuesta.png).

## 10. Cliente de correo Linux pendiente

En Thunderbird configurar ambas cuentas con servidor `192.168.0.20` o su FQDN una vez resuelto el DNS. Recepción POP3 110; envío SMTP 25; usuario completo `correo1@servidor1.com` o `correo2@servidor1.com`. Usar las credenciales del laboratorio. El transporte actual de estos puertos no usa TLS; la prueba remota se realiza dentro de Tailscale.

Comprobar recepción por POP3, envío autenticado y respuesta entre ambas cuentas. Conservar mensajes en el servidor durante las pruebas para poder revisarlos también desde Roundcube. Esta configuración es una tarea pendiente; las capturas actuales no demuestran Thunderbird funcionando.
