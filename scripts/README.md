# Scripts de diagnóstico

[Inicio](../README.md) · [Manual](../docs/02-manual-fase1.md)

| Carpeta | Archivo | Dónde ejecutarlo | Qué consulta |
|---|---|---|---|
| windows | [Diagnostico-Fase1.ps1](windows/Diagnostico-Fase1.ps1) | PowerShell como administrador **dentro de SRV-PRINCIPAL** | Red, servicios, AD, DNS, DHCP, recursos, IIS y listeners |
| ubuntu | [diagnostico.sh](ubuntu/diagnostico.sh) | Terminal del **Ubuntu físico de Luis** | Sistema, Tailscale, ruta .20, DNS sin EDNS, HTTP y realmd |

Los scripts consultan información; no instalan paquetes, no unen equipos al dominio ni modifican la red. Requieren las herramientas correspondientes ya instaladas. La comprobación de sintaxis del script Bash se realizó; no se ejecutaron contra los equipos reales desde este repositorio. El script PowerShell debe verificarse en SRV-PRINCIPAL.

## Ejecución

En SRV-PRINCIPAL, desde una carpeta que contenga el archivo:

```powershell
.\Diagnostico-Fase1.ps1
```

En Ubuntu, desde la raíz de una copia del repositorio:

```bash
bash scripts/ubuntu/diagnostico.sh
```

Si Windows impide ejecutar scripts, revisar la política vigente antes de cambiarla; también se pueden ejecutar manualmente las consultas del manual.

## Al compartir resultados

Revisar que no incluyan contraseñas, tokens, enlaces de invitación o información personal innecesaria. Conservar el error completo y especificar en qué equipo se ejecutó.
