# Arquitectura y direccionamiento

[Volver al inicio](../README.md)

## Equipos

| Equipo | Función | Configuración conocida |
|---|---|---|
| Intel de Mark | HOST Windows 11, VirtualBox y router de subred Tailscale | Intel i5-1135G7, 8 GB RAM |
| SRV-PRINCIPAL | Servidor principal Windows Server 2012 R2, AD DS/DNS/DHCP/SMB/IIS/FTP/correo | 2 GB RAM, 2 CPU, disco virtual dinámico 50 GB |
| CLI-WINDOWS01 | Cliente Windows 10 Pro unido al dominio | 2 GB RAM, 2 CPU, disco virtual 40 GB |
| HP de Luis | Ubuntu 26.04.1 físico, cliente Linux y HOST VirtualBox | Versión y hostname confirmados por terminal; hardware por documentar |
| SRV-SECUNDARIO | Windows Server 2012 R2 instalado en VirtualBox de Luis | NAT, IP reportada 10.0.2.15; funciones de fase 2 pendientes |

El otro equipo Ryzen de Mark no forma parte del despliegue actual documentado.

## Direcciones actuales

| Interfaz/equipo | Dirección | Observación |
|---|---|---|
| SRV-PRINCIPAL | 192.168.0.20/24 | Fija; sin puerta de enlace en NIC de laboratorio |
| Cliente Windows | DHCP, se observó 192.168.0.26 | Puede variar al renovar concesión |
| HOST Intel, adaptador host-only | 192.168.0.200/32 | Alias Windows `Ethernet`; distinto del Wi-Fi |
| HOST Intel, Wi-Fi | Se observó 192.168.0.59/24 | Red doméstica; puede cambiar |
| HOST Intel, Tailscale | 100.75.119.44 | Dirección vigente al realizar pruebas |
| Ubuntu Luis, Tailscale | 100.73.221.73 | Perfil conectado a la misma tailnet |
| SRV-SECUNDARIO, NAT | 10.0.2.15 | Dirección interna del NAT de VirtualBox de Luis |

La antigua IP Tailscale 100.67.93.51 pertenecía al perfil personal de Luis y no se utiliza en esta integración.

## Evolución de la red

Las primeras capturas corresponden a una red interna VirtualBox llamada RED-PRACTICAS. Para permitir acceso desde el HOST y desde Luis se migró el laboratorio de Mark a host-only. No deben confundirse las capturas antiguas con una prueba del estado posterior a esa migración.

El adaptador host-only es `VirtualBox Host-Only Ethernet Adapter`. Su dirección original era 192.168.56.1/24. Se configuró 192.168.0.200/32 y una ruta de host hacia 192.168.0.20/32. Se indicó cambiar Adapter 1 de ambas VMs al adaptador host-only, con cable conectado. El acceso HTTP desde el HOST al servidor quedó confirmado; falta repetir todas las pruebas del cliente Windows después del cambio.

## Solapamiento de subredes

Ambas casas utilizaban 192.168.0.0/24. Por eso se anuncia por Tailscale solamente `192.168.0.20/32`, no toda la /24. Así, el acceso al servidor utiliza la ruta más específica y no exige sustituir la red doméstica del compañero.

En el HOST Intel se habilitó forwarding IPv4 en Ethernet y Tailscale, se anunció la ruta y se aprobó en el panel. Luis aceptó rutas con `--accept-routes=true`, manteniendo `--accept-dns=false`. No se configuró un exit node ni se publicaron puertos en el router doméstico.

El acceso web remoto está confirmado. Ese resultado no prueba automáticamente la disponibilidad de LDAP, Kerberos, SMB o FTP. Tailscale tampoco transporta las difusiones DHCP del laboratorio a la red doméstica de Luis: DHCP se prueba con el cliente virtual conectado a host-only.

## Diferencia pendiente respecto al enunciado

El punto 1 solicita dos HOST, cada uno con un servidor y un cliente virtual. Actualmente Luis utiliza Ubuntu físico. Debe instalarse el cliente virtual correspondiente o confirmarse con el auxiliar que acepta ese diseño. El segundo servidor se conserva para el dominio independiente servidor2.com y Exchange en la fase 2; no se ha acreditado una promoción ni instalación de Exchange.

## Encendido y apagado

1. Encender Intel y conectar Tailscale.
2. Iniciar SRV-PRINCIPAL y esperar AD DS, DNS y DHCP.
3. Iniciar el cliente Windows. Luis conecta su Ubuntu a la misma tailnet.
4. Al terminar, apagar primero los clientes y luego Windows Server desde el menú de apagado del sistema invitado.
5. Cerrar VirtualBox cuando las VMs aparezcan apagadas. Los cambios realizados en disco quedan guardados; el servidor debe estar encendido para las pruebas remotas.
