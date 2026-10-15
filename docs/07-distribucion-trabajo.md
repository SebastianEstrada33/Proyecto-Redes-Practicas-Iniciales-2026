# Distribución del trabajo y equipos

[Inicio](../README.md) · [Índice de documentación](README.md) · [Estado detallado](03-pruebas-y-pendientes.md)

Esta distribución organiza el cierre de fase 1. Cada integrante debe poder explicar todos los servicios durante la evaluación.

| Persona | Equipo donde trabaja | Responsabilidad |
|---|---|---|
| Mark | Intel Windows, fuera de las VMs | VirtualBox, acceso host-only, Tailscale y ruta al servidor |
| Mark | VM SRV-PRINCIPAL | AD, DNS, DHCP, permisos, IIS, FTP, hMailServer y Roundcube |
| Mark | VM CLI-WINDOWS01 | Validación Windows de dominio, GPO, recursos y servicios |
| Luis Saloj | Ubuntu físico HP | Cliente Linux, DNS dividido, unión AD, SMB, webs, FTP y Thunderbird |
| Luis Saloj | VM SRV-SECUNDARIO | Conservar instalación y preparar servicios futuros de fase 2 |
| Ambos | Repositorio y defensa | Evidencias, estado real de pruebas, distribución exigida y explicación oral |

## Próximas tareas de Mark

- Mantener encendidos Intel, Tailscale y SRV-PRINCIPAL durante las pruebas remotas.
- Resolver con Luis el bloqueo Kerberos de la unión al dominio.
- Revisar la vinculación AD de correo2 en hMailServer.
- Repetir pruebas del cliente Windows después de cambiar a host-only.
- Comprobar DHCP, perfil de red y funcionamiento tras reinicio.

## Próximas tareas de Luis

- Instalar krb5-user y ejecutar la prueba kinit con traza indicada durante el diagnóstico.
- Completar la unión de Ubuntu y verificar las cuentas usuario1 y usuario2.
- Comprobar al menos dos funcionalidades desde Linux y conservar evidencia; completar también las demás pruebas planificadas.
- Configurar ambas cuentas en Thunderbird y demostrar POP3 y SMTP.
- Registrar la configuración de su servidor secundario.

## Tareas conjuntas

- Resolver el requisito de un servidor y un cliente virtual por HOST; Ubuntu físico aún no acredita ese inciso.
- Guardar resultados completos, incluidos rechazos de acceso esperados.
- Actualizar la matriz de pruebas solo después de ejecutar cada prueba.
- Preparar las preguntas de defensa y el diseño de fase 2.

## Estado del bloqueo de Ubuntu

DNS LDAP responde con +noedns. La unión AD sigue fallando por cifrado Kerberos. Administrador tiene AES128/AES256 habilitados (24), pero ese cambio no resolvió el reintento. No se encontraron restricciones explícitas en los valores de registro consultados. Falta la salida de kinit desde Ubuntu.
