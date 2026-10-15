# Guion para la demostración de fase 1

[Índice de entrega](README.md) · [Resultados registrados](../docs/03-pruebas-y-pendientes.md)

Este guion indica qué demostrar y qué se espera observar; no registra como aprobadas pruebas que aún no se ejecutaron.

| Orden | Equipo y responsable | Acción | Resultado esperado |
|---|---|---|---|
| 1 | HOST Intel / Mark | Mostrar VirtualBox y sus VMs | Servidor y cliente identificados; explicar memoria y red |
| 2 | HOST de Luis / Luis | Mostrar servidor y cliente exigidos | Distribución aceptada según requisito académico |
| 3 | SRV-PRINCIPAL / Mark | Mostrar dominio, usuarios y DNS | servidor1.com, usuario1/2 y SRV LDAP |
| 4 | Cliente Windows / Mark | Mostrar IP automática y concesión | .26–.100, DNS .20 y concesión en DHCP |
| 5 | Cliente Windows / Mark | Iniciar sesión de dominio, gpresult y Panel de control | Fondo institucional, GPO y bloqueo |
| 6 | Cliente Windows / Mark | Crear/editar/borrar en público; probar privado | Operaciones permitidas y denegación a no autorizado |
| 7 | Cliente / ambos | Abrir páginas pública y privada | Mensajes exigidos; privado autenticado por 1080 |
| 8 | Cliente / ambos | Abrir /correo y enviar/responder | Redirección IIS y mensaje recibido |
| 9 | Cliente / ambos | FTP con usuario1 y usuario2 | Listado, descarga, carga y eliminación |
| 10 | Ubuntu / Luis | realm list, id y autenticación AD | Pertenencia y autenticación reales; pendiente |
| 11 | Ubuntu / Luis | Mostrar al menos dos funciones | Funcionamiento Linux acreditado; completar |
| 12 | Ubuntu / Luis | Thunderbird ambas cuentas | POP3, SMTP y respuesta; pendiente |

## Antes de iniciar

- Mantener encendidos HOST, servidor y clientes necesarios.
- Comprobar Tailscale y la ruta si se usa acceso remoto.
- Preparar cuentas de laboratorio sin publicar contraseñas.
- Usar archivos de prueba propios para las operaciones de eliminación.
- Identificar claramente qué prueba está en vivo y cuál corresponde a una captura anterior.

## Preguntas para estudiar

1. ¿Por qué los clientes del dominio utilizan el DNS del servidor?
2. ¿Qué diferencia hay entre exclusión DHCP y reserva por dirección MAC?
3. ¿Cómo se combinan permisos SMB y NTFS?
4. ¿Por qué una GPO creada puede no aplicarse a un usuario?
5. ¿Qué hacen SMTP, POP3 e IMAP? ¿Qué usa Roundcube?
6. ¿Dónde se configura /correo y por qué no necesita una carpeta física?
7. ¿Para qué sirve el rango pasivo de FTP?
8. ¿Por qué se anuncia una ruta /32 en lugar de toda la /24?
9. ¿Qué prueba que Linux está unido al dominio y qué prueba solo conectividad?
10. ¿Qué cambia entre servidor1.com y el dominio independiente de fase 2?
