# Configuración documentada

La configuración aplicada se describe en el [manual](../docs/02-manual-fase1.md). No se exportaron los archivos reales del servidor ni se generaron credenciales de ejemplo que puedan confundirse con las del despliegue.

| Componente | Ubicación en servidor | Parámetros documentados |
|---|---|---|
| PHP | C:\PHP\php.ini | Extensiones, sesiones y FastCGI |
| Roundcube | C:\Inetpub\wwwroot\webmail\config\config.inc.php | IMAP 127.0.0.1:143; SMTP 127.0.0.1:25; SQLite externo; instalador deshabilitado |
| SQLite | C:\RoundcubeData\roundcube.db | No se publica el contenido |
| IIS | applicationHost.config, administrado por IIS | Sitios, pools y redirección |
| hMailServer | Administrador de hMailServer | Dominio, buzones e integración AD |
| SSSD Ubuntu | /etc/sssd/sssd.conf | Se generará/revisará al unir al dominio; pendiente |

Los comandos de diagnóstico son de solo lectura. Antes de reconstruir o modificar el laboratorio, consultar su arquitectura actual y conservar una copia de seguridad propia de la configuración.
