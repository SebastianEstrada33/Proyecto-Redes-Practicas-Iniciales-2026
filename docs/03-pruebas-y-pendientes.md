# Matriz de pruebas y pendientes

[Inicio](../README.md)

**Corte:** 15/10/2026, hora de Guatemala. “Confirmado por el equipo” identifica un resultado comunicado durante la práctica; no equivale necesariamente a una captura completa de todas sus operaciones.

| Prueba | Resultado actual | Responsable siguiente |
|---|---|---|
| VM principal y cliente Windows instalados | Confirmado y documentado | Mark: repetir tras cambios de red |
| Un servidor y un cliente virtual por cada HOST | Diferencia pendiente: Ubuntu es físico | Ambos: resolver o confirmar con auxiliar |
| AD, DNS y usuarios1/2 | Confirmado en servidor y cliente Windows | Mark: revisión final |
| Fondo institucional y restricción Panel de control | Capturas disponibles | Mark: conservar para defensa |
| DHCP .26–.100 | Configuración acreditada; concesión .26 observada | Mark: recapturar concesión tras migración |
| SMB público crear/editar/eliminar | Confirmado por equipo desde Windows | Luis: repetir en Ubuntu |
| SMB privado denegación y acceso autorizado | Confirmado por equipo desde Windows | Luis: repetir en Ubuntu |
| Web pública y privada Windows | Confirmado | Luis: probar ambas en Ubuntu |
| FTP con dos usuarios | Operaciones locales y Windows confirmadas | Luis: prueba pasiva desde Ubuntu |
| hMailServer correo1 integrado con AD | Captura disponible | Mark: revisar también correo2 |
| POP3 local y SMTP | Confirmado por equipo | Luis: comprobar desde Thunderbird |
| Roundcube Windows, envío y respuesta | Capturas disponibles | Completar evidencia Linux |
| Ubuntu → HOST mediante Tailscale | Pong recibido | Confirmado |
| Ubuntu → /correo en IIS | HTTP 302 hacia /webmail | Confirmado por salida de terminal |
| Mensaje enviado desde Ubuntu recibido | Confirmado por Mark | Confirmar también respuesta recibida en Ubuntu |
| DNS A y Kerberos SRV desde Ubuntu | Confirmado por Luis | Conservar salida/captura |
| LDAP SRV desde Ubuntu | Ambas consultas responden NOERROR con +noedns | Revisar EDNS si vuelve el error |
| LDAP SRV local en servidor | Correcto en ambas consultas | No recrear registros sin diagnóstico |
| Unión Ubuntu al dominio | Falló por KDC has no support for encryption type | Reintento falló igualmente; falta prueba kinit con traza |
| Autenticación Linux y ≥2 funcionalidades | Pendiente | Luis |
| Thunderbird ambas cuentas POP3/SMTP | Pendiente | Luis |
| Reinicio y persistencia de rutas/DNS | Sin prueba completa | Ambos |

## Orden de cierre de fase 1

1. Obtener prueba kinit con traza desde Ubuntu y resolver negociación Kerberos; AES=24 no bastó.
2. Unir Ubuntu al dominio, verificar usuario AD y al menos dos funciones del enunciado.
3. Probar Thunderbird con las dos cuentas, incluyendo POP3 y SMTP.
4. Probar SMB, webs y FTP desde Ubuntu y añadir capturas.
5. Revisar integración AD de correo2 y cliente Windows después del cambio a host-only.
6. Resolver la distribución de clientes virtuales del punto 1; documentar SRV-SECUNDARIO.
7. Comprobar reinicio, actualizar este estado y preparar explicación oral de cada servicio.

## Pruebas de aceptación

| Servicio | Prueba positiva | Prueba negativa o límite |
|---|---|---|
| AD | Usuario del dominio identificado en cliente | Contraseña incorrecta no autentica |
| DHCP | IP automática .26–.100 y concesión visible | Ninguna concesión dentro de .1–.25 |
| GPO | Fondo y bloqueo aplicados en usuario de OU | Revisar alcance al agregar usuarios nuevos |
| SMB | Crear, editar y borrar archivo propio de prueba | usuario1/2 sin acceso al privado |
| Web privada | privado entra por 1080 | Usuario no autorizado rechazado |
| Correo | Cuenta1 → cuenta2 y respuesta, webmail y POP3/SMTP | Credencial incorrecta rechazada |
| FTP | Dos usuarios descargan, cargan y borran su prueba | Anónimo sin acceso |
| Instalador | Webmail continúa funcionando | /webmail/installer/ devuelve 404 |

## Fase 2, todavía no implementada en este registro

- Punto 5: AD independiente servidor2.com, Exchange 2010/2013 y dominio de correo correo2.com; cuentas correo1ex y correo2ex; acceso web y mensaje de autenticación exigido.
- Punto 7: Telnet nativo y pruebas.
- Punto 9: RDP del servidor Exchange y RDP vía web obligatorio.
- Punto 10: proxy autenticado en puerto 8080 o alternativa WAP indicada en enunciado; no dar por equivalentes todas las funciones de proxy directo y proxy inverso sin revisar el diseño.
- Impresora física compartida con nombre impresora, desde equipo del servidor web, accesible al servidor Exchange.
- VoIP es opcional y corresponde a fase 2.

El enunciado exige ambas fases, al menos 80 % de incisos por fase, presencia del equipo y preguntas aleatorias. No se calcula un porcentaje de cumplimiento sin contrastar cada inciso y sus evidencias.
