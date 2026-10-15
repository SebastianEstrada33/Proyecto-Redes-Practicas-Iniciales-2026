# Tailscale y cliente Ubuntu

[Inicio](../README.md) · [Arquitectura](01-arquitectura.md)

## Conexión verificada

Tailscale está instalado en el **Windows HOST de Mark**, no en el Server 2012 R2, y en el **Ubuntu físico de Luis**. Ambos dispositivos deben pertenecer a la misma tailnet. Estar invitado como usuario no basta si Ubuntu sigue conectado al perfil personal.

Desde Ubuntu se obtuvo un pong de 100.75.119.44. La IP de Luis en la tailnet compartida es 100.73.221.73. También se obtuvo:

```text
HTTP/1.1 302 Redirect
Location: http://192.168.0.20/webmail
Server: Microsoft-IIS/8.5
```

Se transcribe el resultado comunicado en terminal; no se presenta como captura original. El mensaje enviado desde Ubuntu fue recibido, confirmado por Mark. Falta confirmar la recepción de la respuesta en Ubuntu.

## Ajustes ya aplicados

En Ubuntu:

```bash
sudo tailscale set --accept-routes=true --accept-dns=false
```

En el HOST Windows se anunció solo 192.168.0.20/32 y se aprobó en el panel de administración; se habilitó forwarding IPv4 en Ethernet y Tailscale. No repetir los cambios de dirección del adaptador si ya están aplicados.

## DNS dividido temporal

Ubuntu utiliza systemd-resolved. Se aplicó DNS del laboratorio solamente al dominio servidor1.com:

```bash
sudo resolvectl dns tailscale0 192.168.0.20
sudo resolvectl domain tailscale0 '~servidor1.com'
sudo resolvectl default-route tailscale0 no
sudo resolvectl flush-caches
```

La tilde marca un dominio de enrutamiento DNS. El DNS habitual sigue atendiendo los demás dominios. Estos ajustes son de ejecución y pueden perderse al recrear la interfaz o reiniciar; su persistencia está pendiente de implementar y comprobar. Para revertir los ajustes de esa interfaz: `sudo resolvectl revert tailscale0`.

## Preparación del dominio

Paquetes indicados para el cliente SSSD:

```bash
sudo apt update
sudo apt install -y realmd sssd-ad sssd-tools adcli libnss-sss libpam-sss samba-common-bin smbclient dnsutils
```

Luis confirmó que `realm discover servidor1.com` detecta Active Directory y SSSD, el registro A resuelve y el SRV de Kerberos devuelve puerto 88. Inicialmente dos consultas SRV LDAP devolvían FORMERR, incluso con TCP. En SRV-PRINCIPAL ambos registros existen y responden localmente.

**Siguiente comprobación en Ubuntu:**

```bash
dig @192.168.0.20 _ldap._tcp.servidor1.com SRV +noedns +time=3 +tries=1
dig @192.168.0.20 _ldap._tcp.dc._msdcs.servidor1.com SRV +noedns +time=3 +tries=1
dig @192.168.0.20 _ldap._tcp.dc._msdcs.servidor1.com SRV +tcp +noedns +time=3 +tries=1
```

Luis ejecutó las dos consultas UDP con +noedns y ambas devolvieron NOERROR, destino srv-principal.servidor1.com, puerto 389 e IP .20. No se recibió la tercera prueba TCP sin EDNS. FORMERR no demostraba ausencia de registros. No crear zonas duplicadas ni desactivar globalmente el firewall por ese resultado.

## Unión al dominio: procedimiento pendiente

El primer intento ya llegó al controlador y falló con `KDC has no support for encryption type`. Mark habilitó AES128/AES256 para Administrador (atributo final 24), sin cambiar su contraseña. No se ha recibido el resultado del reintento. Verificar hora y conectividad; el siguiente bloque describe el procedimiento, todavía sin unión exitosa acreditada:

```bash
timedatectl
realm discover servidor1.com
sudo realm join --verbose --user=Administrador --computer-name=CLI-LINUX01 servidor1.com
realm list
id usuario1@servidor1.com
sudo pam-auth-update --enable mkhomedir
```

La contraseña del administrador se introduce de forma interactiva y no se comparte en capturas ni Git. Revisar la política de acceso generada por realmd antes de probar inicio de sesión. Si falla, conservar el error y consultar logs; no reemplazar sssd.conf a ciegas. El nombre actual del equipo es largo: si la unión solicita un nombre de equipo AD compatible, acordar uno corto y único antes de reintentar.

El inicio de sesión gráfico con una cuenta AD debe planificarse manteniendo disponible la cuenta local de Luis. Si se presentan errores de GPO o cifrado con Server 2012 R2, diagnosticar la causa antes de debilitar políticas globales.

## Funciones desde Linux

- Web pública: `http://192.168.0.20/publicweb/`.
- Web privada: `http://192.168.0.20:1080/privadaweb/`, usuario privado.
- SMB: gestor de archivos → Otra ubicación → `smb://192.168.0.20/CarpetaPública` y `smb://192.168.0.20/CarpetaPrivada`; usar dominio SERVIDOR1 y la cuenta adecuada.
- FTP: cliente compatible con FTP pasivo, IP .20, puerto 21, usuario de dominio; comprobar escritura y eliminación con ambos usuarios.
- Thunderbird: configurar ambas cuentas con POP3 110 y SMTP 25. Webmail IMAP no sustituye esta prueba POP3.

No se requiere habilitar SRV-SECUNDARIO para probar los servicios existentes del principal. Su NAT actual no implica conexión automática al laboratorio por tener Tailscale en el HOST.

## Resultado del diagnóstico y ajuste AES

La prueba remota sin EDNS, del 14/10 a las 23:55 de Guatemala, devolvió para ambas consultas `status: NOERROR` y una respuesta SRV `0 100 389 srv-principal.servidor1.com.`.

La unión posterior autenticó contra el DC seleccionado pero falló al negociar cifrado con Administrador. En SRV-PRINCIPAL se aplicó:

```powershell
Set-ADUser -Identity Administrador -KerberosEncryptionType AES128,AES256
```

El atributo final msDS-SupportedEncryptionTypes es 24. No se ha cambiado la contraseña ni se ha comprobado aún que ese ajuste baste. Algunas cuentas pueden necesitar regeneración de claves AES; no habilitar cifrados antiguos globalmente para ocultar el fallo.

[Evidencia del cambio AES](../evidencias/22-kerberos-aes-administrador.png).
