# Informe de implementación · Fase 1

**Universidad de San Carlos de Guatemala**  
**Facultad de Ingeniería · Escuela de Práctica Supervisada**  
**Prácticas Iniciales · Sección F · 2026**

**Integrantes documentados:** Marco David Mérida Velásquez, carné 202500065, y Luis Saloj.

[Índice de entrega](README.md)

## 1. Objetivo

Implementar y documentar una infraestructura de laboratorio que centralice usuarios, resolución de nombres, direccionamiento, recursos compartidos, correo, publicación web y transferencia de archivos. Integrar clientes Windows y Linux y demostrar el control de acceso de cada servicio.

## 2. Alcance de la fase

Los puntos de la primera entrega son virtualización (1), usuarios y red (2), recursos compartidos (3), correo (4), web (6) y FTP (8). Exchange, Telnet, RDP, proxy y la prueba de impresora corresponden a la segunda entrega.

## 3. Infraestructura implementada

El servidor SRV-PRINCIPAL utiliza Windows Server 2012 R2 en VirtualBox y concentra los roles de la fase. El cliente CLI-WINDOWS01 utiliza Windows 10 Pro y pertenece al dominio servidor1.com. Luis dispone de Ubuntu físico y una VM SRV-SECUNDARIO destinada a los siguientes servicios.

La dirección principal es 192.168.0.20/24. El laboratorio de Mark utiliza conectividad host-only. El HOST anuncia la ruta específica 192.168.0.20/32 mediante Tailscale para permitir pruebas remotas sin anunciar toda la subred doméstica solapada. DHCP se comprueba dentro de la red virtual; no se propaga a través de la VPN.

[Detalle de arquitectura y equipos](../docs/01-arquitectura.md).

## 4. Servicios configurados

| Punto | Solución implementada | Evidencia o resultado registrado |
|---|---|---|
| 1 | VirtualBox, servidor principal y cliente Windows; servidor secundario instalado en equipo de Luis | Captura de VM principal; distribución del cliente virtual de segundo HOST por validar |
| 2 | AD DS y DNS servidor1.com; usuario1 y usuario2; GPO institucional y restricción de Panel de control; DHCP | Dominio y GPO comprobados en Windows; rango DHCP y exclusiones documentados |
| 3 | Carpetas pública y privada; permisos SMB y NTFS | Operaciones y denegación confirmadas desde Windows; captura de permisos privados |
| 4 | hMailServer, buzones y servicios SMTP/POP3/IMAP; Roundcube sobre IIS/PHP | Correo web de ida y respuesta en Windows; mensaje desde Ubuntu recibido; integración AD capturada para correo1 |
| 6 | IIS público, privado en 1080 y redirección /correo | Páginas comprobadas; HTTP 302 confirmado desde Ubuntu |
| 8 | FTP nativo de IIS con permisos para dos usuarios | Descarga, carga y eliminación comprobadas en Windows |

## 5. Decisiones de implementación

- hMailServer cubre POP3, ausente como servicio nativo en Server 2012, y ofrece integración con cuentas AD.
- Roundcube actúa como cliente web; Thunderbird debe demostrar por separado POP3/SMTP desde Linux.
- La política NoControlPanel sustituye el cambio de título de Internet Explorer que el enunciado reconoce como depreciado.
- La web privada y el recurso privado comparten carpeta física; autorización web, SMB y NTFS se revisan por separado.
- La ruta /correo realiza un reenvío configurado en IIS y no requiere carpeta física propia.
- Las capturas conservan sus archivos originales y se clasifican por punto del proyecto.

## 6. Verificación funcional

Se documentan la pertenencia al dominio y aplicación de GPO del cliente Windows, la configuración de DHCP, páginas pública y privada, permisos de recursos, FTP y correo web. Desde Ubuntu se confirmó el acceso por Tailscale, resolución de nombres, consultas LDAP sin EDNS, redirección HTTP y envío de correo recibido por Mark.

Cada resultado tiene un alcance concreto: la consulta LDAP sin EDNS no acredita la unión al dominio, y el correo web no acredita POP3 en Thunderbird. La [matriz de pruebas](../docs/03-pruebas-y-pendientes.md) conserva la distinción.

## 7. Validaciones de cierre

A la última actualización siguen por confirmar: unión y autenticación AD de Ubuntu, al menos dos funcionalidades Linux, Thunderbird para ambas cuentas, vinculación AD de correo2, prueba posterior a cambios de red y persistencia tras reinicio. La distribución de un servidor y un cliente virtual en cada HOST requiere resolver el uso de Ubuntu físico o confirmar su aceptación.

El error de unión actual es `KDC has no support for encryption type`. Habilitar AES128/AES256 para Administrador produjo el valor 24, pero el reintento falló igualmente; el siguiente diagnóstico indicado es kinit con traza.

## 8. Conclusiones del trabajo documentado

La centralización de servicios en el servidor principal permitió comprobar desde Windows el dominio, las políticas, los recursos y los servicios de aplicación. La conexión mediante una ruta específica por Tailscale permitió realizar pruebas desde una segunda ubicación con una subred doméstica solapada. El cierre de integración Linux requiere completar la autenticación Kerberos y sus pruebas funcionales antes de acreditar el cumplimiento completo de la fase.

## 9. Anexos

- [Manual técnico](../docs/02-manual-fase1.md).
- [Galería de evidencias](../evidencias/README.md).
- [Incidencias](../docs/05-incidencias.md).
- [Referencias](../docs/06-referencias.md).
- [Guion de demostración](demostracion.md).
