# Ejecutar dentro de SRV-PRINCIPAL en PowerShell como administrador.
# Solo consulta información. No cambia roles, permisos, rutas ni servicios.
$ErrorActionPreference = 'Continue'
Write-Host "`n=== EQUIPO Y RED ==="
hostname
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias,IPAddress,PrefixLength
Get-NetConnectionProfile
Write-Host "`n=== SERVICIOS ==="
Get-Service DNS,Netlogon,DHCPServer,W3SVC,FTPSVC,hMailServer -ErrorAction Continue |
    Select-Object Name,Status,StartType
Write-Host "`n=== DOMINIO ==="
if (Get-Command Get-ADDomain -ErrorAction SilentlyContinue) {
    Get-ADDomain | Select-Object DNSRoot,NetBIOSName,DomainMode
    Get-ADUser -Filter 'SamAccountName -eq "usuario1" -or SamAccountName -eq "usuario2" -or SamAccountName -eq "correo1" -or SamAccountName -eq "correo2"' |
        Select-Object SamAccountName,Enabled,DistinguishedName
}
Write-Host "`n=== DNS ==="
if (Get-Command Get-DnsServerZone -ErrorAction SilentlyContinue) {
    Get-DnsServerZone | Select-Object ZoneName,IsDsIntegrated
}
foreach ($nombre in @('_ldap._tcp.servidor1.com','_ldap._tcp.dc._msdcs.servidor1.com','_kerberos._tcp.servidor1.com')) {
    Resolve-DnsName -Name $nombre -Type SRV -Server 127.0.0.1 -DnsOnly
}
Write-Host "`n=== DHCP ==="
if (Get-Command Get-DhcpServerv4Scope -ErrorAction SilentlyContinue) {
    Get-DhcpServerv4Scope
    Get-DhcpServerv4ExclusionRange -ScopeId 192.168.0.0
    Get-DhcpServerv4OptionValue -ScopeId 192.168.0.0
    Get-DhcpServerv4Lease -ScopeId 192.168.0.0
}
Write-Host "`n=== RECURSOS ==="
Get-SmbShare | Where-Object {$_.Path -like '*wwwroot*'} | Select-Object Name,Path
Write-Host "`n=== IIS ==="
if (Get-Module -ListAvailable WebAdministration) {
    Import-Module WebAdministration
    Get-Website | Select-Object Name,State,PhysicalPath,Bindings
    Get-WebApplication | Select-Object Path,ApplicationPool,PhysicalPath
}
Write-Host "`n=== PUERTOS TCP EN ESCUCHA ==="
Get-NetTCPConnection -State Listen |
    Where-Object {$_.LocalPort -in @(21,25,53,80,88,110,135,139,143,389,445,1080,3268)} |
    Select-Object LocalAddress,LocalPort,OwningProcess | Sort-Object LocalPort
