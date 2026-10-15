# Fase 2 · Planificación

[Inicio](../README.md) · [Estado de fase 1](../docs/03-pruebas-y-pendientes.md)

**Entrega: 29/10/2026. Estado: pendiente de implementación y verificación.**

| Punto | Servicio o requisito | Equipo previsto / decisión |
|---|---|---|
| 5 | AD independiente servidor2.com y Exchange 2010/2013; correo2.com, correo1ex y correo2ex | SRV-SECUNDARIO; revisar recursos y requisitos antes de instalar |
| 7 | Telnet nativo y prueba de acceso | Servidor web, según enunciado |
| 9 | RDP de Exchange y acceso RDP vía web | Servidor secundario; diseño por completar |
| 10 | Proxy autenticado en 8080 o alternativa WAP indicada | Diseño por completar; distinguir proxy directo y proxy inverso |
| Nota del punto 3 | Impresora física compartida como impresora y acceso desde Exchange | HOST donde se virtualiza el servidor web |
| Opcional | VoIP y dos softphones, Windows y Linux | Solo después de asegurar requisitos obligatorios |

El servidor secundario está instalado en VirtualBox de Luis y usa NAT. No se acredita todavía su dominio ni Exchange. No se debe promover como controlador adicional de servidor1.com: el enunciado pide un dominio independiente.

## Antes de implementar

1. Cerrar y documentar pendientes de fase 1.
2. Revisar memoria, espacio, conectividad y compatibilidad del software requerido.
3. Definir la comunicación del servidor secundario con los clientes y la impresora.
4. Documentar cada configuración y añadir pruebas reales.

Las funcionalidades de fase 2 deben quedar totalmente integradas con la fase 1. La lista no representa resultados ya obtenidos.
