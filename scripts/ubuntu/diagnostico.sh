#!/usr/bin/env bash
# Solo lectura. Ejecutar en Ubuntu de Luis: bash scripts/ubuntu/diagnostico.sh
set -u
printf '\n=== SISTEMA ===\n'
cat /etc/os-release
hostname
timedatectl
printf '\n=== TAILSCALE ===\n'
if command -v tailscale >/dev/null 2>&1; then tailscale status; else printf 'Tailscale no disponible\n'; fi
printf '\n=== RUTA ===\n'
ip route get 192.168.0.20
printf '\n=== DNS ===\n'
resolvectl status tailscale0
resolvectl query srv-principal.servidor1.com
if command -v dig >/dev/null 2>&1; then
    for name in _kerberos._tcp.servidor1.com _ldap._tcp.servidor1.com _ldap._tcp.dc._msdcs.servidor1.com; do
        dig @192.168.0.20 "$name" SRV +noedns +time=3 +tries=1
    done
else
    printf 'dig no disponible; instalar dnsutils para esta comprobacion.\n'
fi
printf '\n=== HTTP CORREO ===\n'
curl -I --connect-timeout 10 --max-time 15 http://192.168.0.20/correo
printf '\n=== DOMINIO ===\n'
if command -v realm >/dev/null 2>&1; then
    realm list
    timeout 30s realm discover servidor1.com
else
    printf 'realmd no disponible.\n'
fi
