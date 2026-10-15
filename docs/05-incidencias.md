# Incidencias y decisiones

[Inicio](../README.md)

| Incidencia | Diagnóstico y resolución | Estado |
|---|---|---|
| Memoria limitada | HOST Intel de 8 GB; VMs con 2 GB cada una; evitar tareas innecesarias durante pruebas | Operativo; margen limitado |
| Acceso privado fallaba | Revisados autenticación IIS, permisos NTFS y firewall/perfil | Funcionó desde Windows antes de migración |
| Red del servidor aparece Public al iniciar | Se observaron fallos de detección del dominio; al redetectar el DC y reiniciar adaptador volvió la comunicación | Pendiente solución persistente y prueba tras reinicio |
| Cliente con APIPA y dominio no disponible | Reinicio del servicio DHCP y renovación/restablecimiento del adaptador recuperaron concesión | Causa raíz no acreditada |
| Error al pegar comandos de PowerShell | Se habían copiado los textos PS C:\... y los indicadores >> | Copiar únicamente el contenido del bloque |
| Selección de adaptador por GUID no encontraba interfaz | Se identificó adaptador host-only a partir de su IP original 192.168.56.1 | Cambio posterior correcto; HTTP desde HOST confirmado |
| Redes domésticas solapadas | Ruta específica 192.168.0.20/32 por Tailscale | HTTP remoto confirmado |
| Tailscale no matching peer | Ubuntu seguía en tailnet personal; iniciar sesión en perfil compartido | Ambos dispositivos visibles y pong |
| PHP no iniciaba | Dependencia de runtime Visual C++ | Runtime compatible instalado; PHP funciona |
| Roundcube HTTP 500.19 | Sección handlers bloqueada en IIS; revisada delegación de configuración | Corregido |
| temp/logs no escribibles | webmail existía como carpeta pero no como aplicación PoolCorreo | Creada aplicación y permisos de pool corregidos |
| SQLite usaba ruta incorrecta | DSN absoluto Windows sqlite:///C:/RoundcubeData/roundcube.db | Pruebas de esquema/escritura OK |
| Instalador Roundcube accesible | Deshabilitado en configuración y bloqueado en requestFiltering | Equipo confirmó 404 al finalizar |
| LDAP SRV remoto FORMERR | Ambas consultas funcionan con +noedns | Consulta sin EDNS confirmada; causa precisa pendiente |
| Unión AD falla por cifrado Kerberos | Administrador tenía el atributo de tipos vacío; se configuró AES128 y AES256 (valor 24), sin cambiar contraseña | El reintento falló igual; pendiente traza kinit |

## Diagnóstico del perfil de red

Primero consultar en el servidor:

```powershell
Get-NetConnectionProfile
nltest /dsgetdc:servidor1.com /force
Get-Service DNS,Netlogon,DHCPServer
```

No cerrar el diagnóstico asignando manualmente un perfil de dominio ni desactivando todos los perfiles de firewall. Las reglas del laboratorio dependen del perfil correcto. Reiniciar el adaptador interrumpe conexiones; hacerlo solo desde la consola local si se decide necesario.

## Qué no acreditan las capturas

- Una página web abierta no prueba permisos SMB.
- Un envío webmail no prueba POP3 ni la integración AD de cada buzón.
- Una consulta DNS local correcta no prueba una consulta remota correcta.
- Una VM instalada no prueba sus roles futuros de Exchange, proxy o RDP.
- Las capturas de la red interna inicial no acreditan automáticamente el estado host-only posterior.
