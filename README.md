# Proyecto Final - Prácticas Iniciales

### Escuela de Práctica Supervisada, Facultad de Ingeniería
### Universidad de San Carlos de Guatemala

Este repositorio contiene la documentación y las especificaciones de diseño e implementación del Proyecto Final de Prácticas Iniciales (Sección F). El objetivo del proyecto consistió en diseñar, configurar e integrar una infraestructura de red y servicios empresariales distribuidos utilizando un esquema de virtualización robusto sobre dos servidores físicos de prueba.

---

## Arquitectura y Esquema Físico

La topología del proyecto se implementó utilizando dos computadoras físicas (**HOST**) interconectadas por medio de un Router/Switch. Cada HOST actúa como un servidor de virtualización, alojando en total el ecosistema completo repartido en solo 2 Servidores Virtuales y sus respectivos clientes corporativos (incluyendo un entorno Linux obligatorio).

### Direccionamiento IP Base:
* **Host 1 (Físico):** `192.168.0.2`  
  * *IPs Virtuales asociadas:* `192.168.0.10` / `192.168.0.5`
* **Host 2 (Físico):** `192.168.0.4`  
  * *IPs Virtuales asociadas:* `192.168.0.15` / `192.168.0.20`

---

## Servicios Configurados

### 1. Gestión de Identidades y Red (Active Directory & DHCP)
* **Dominio Principal:** Configuración del servicio de Active Directory (AD) y DNS bajo el dominio local `servidor1.com`.
* **Usuarios del Dominio:** Creación y provisión de cuentas base (`usuario1` y `usuario2`) integradas globalmente.
* **Políticas de Grupo (GPO):**
  * Despliegue automatizado del fondo de pantalla institucional (Logo de la universidad) al iniciar sesión en el dominio.
  * Implementación de políticas aplicables avanzadas en beneficio de la organización en sustitución de la directiva heredada de Internet Explorer (depreciada en Windows Server 2012).
* **Servidor de IPs Dinámicas (DHCP):** Configurado sobre el segmento `192.168.0.1` al `192.168.0.100`.
  * *Rango Reservado (Estáticas):* `192.168.0.1` a `192.168.0.25`.
  * *Rango Dinámico (Pool):* `192.168.0.26` a `192.168.0.100`.

### 2. Recursos Compartidos y Almacenamiento (File System Server)
* **CarpetaPrivada:** Espacio restringido exclusivo para usuarios con credenciales administrativas (`usuario=privado` y `contrasena=privado`) con permisos de lectura, modificación y eliminación.
* **CarpetaPublica:** Directorio de acceso libre y colaborativo para todos los usuarios del dominio para copiar, eliminar y modificar archivos.
* **Impresora Compartida:** Recurso compartido instalado físicamente en la computadora donde se encuentra virtualizado el servidor web, habilitado para la cola de impresión corporativa.

### 3. Infraestructura de Correo Electrónico (Doble Entorno)
* **Servicios Nativos (POP3/SMTP):** Plataforma de mensajería liviana integrada directamente con el Primary Domain Controller (PDC) de `servidor1.com`. Se implementó una solución alternativa de terceros para suplir el rol POP3 ausente de forma nativa en Windows Server 2012. Pruebas de buzón validadas mediante clientes multiplataforma como Thunderbird.
* **Microsoft Exchange Server:** Entorno robusto de mensajería aislado operando en un nuevo dominio (`servidor2.com`) y asignando el dominio de correos `correo2.com`. Dispone de acceso Webmail protegido; ante credenciales erróneas, el portal deniega el acceso con la cadena exacta: `"DATOS INCORRECTOS DE AUTENTICACION"`.

### 4. Servidor Web (IIS) y Transferencia de Archivos
Alojado bajo Internet Information Services (IIS) en la dirección virtual de servicios (`192.168.0.20`):
* **Sitio Público (publicweb):** Mapeado en `C:\Inetpub\wwwroot\publicweb`, desplegando el mensaje *"Carpeta Pública"*.
* **Sitio Privado (privadaweb):** Publicado restrictivamente en el puerto `1080` bajo la ruta `C:\Inetpub\wwwroot\privadaweb` con acceso para el usuario `privado`.
* **Redireccionamiento de Correo (correo):** Configuración de redirección avanzada de HTTP (forward) a nivel de IIS hacia el portal de Webmail corporativo.
* **FTP & Telnet Nativos:** Servicios de administración remota por consola y transferencia segura de archivos indexados directamente hacia la carpeta pública con privilegios para `usuario1` y `usuario2`.

### 5. Acceso Remoto y Seguridad (Proxy & RDP)
* **Control Remoto:** Activación de Escritorio Remoto (RDP) en el servidor Exchange para el usuario administrador y aprovisionamiento obligatorio de la característica de RDP vía Web.
* **Servidor Proxy Perimetral:** Implementado a través del rol de Web Application Proxy (WAP) en Windows Server 2012 ante la remoción de las herramientas tradicionales.
  * Escucha en el puerto `8080`.
  * Exige autenticación obligatoria delegada contra el Active Directory.
  * Manejo de excepciones de inicio de sesión con el mensaje: `"DATOS INCORRECTOS DE AUTENTICACION"`.

---

## Guía de Despliegue y Verificación

Para simular o auditar el entorno montado en producción:

1. **Fase de Virtualización:** Inicializar los entornos virtuales en los dos HOST físicos asegurando que las interfaces de red interna apunten al switch lógico común en el segmento `192.168.0.0/24`.
2. **Validación de Identidad:** Iniciar el cliente Linux obligatorio unido al dominio y verificar la resolución de nombres DNS. Comprobar la asignación dinámica de direccionamiento IP mediante DHCP dentro del rango `.26` a `.100`.
3. **Comprobación de Sitios Web:**
   * Navegar a `192.168.0.20` para observar el index público.
   * Navegar a `192.168.0.20` e ingresar credenciales válidas para el entorno restringido.
4. **Prueba de Mensajería:** Realizar un envío de correo de prueba entre las cuentas configuradas utilizando el cliente de correo en el entorno Linux corporativo.
