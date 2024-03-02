# Import the DNSServer module
Import-Module DnsServer

# DNS server and zone information
$dnsServer = ""
$zoneName = ""
$subnet = ""  # Adjust this based on your subnet



# Get existing DNS records
$existingRecords = Get-DnsServerResourceRecord -ZoneName $zoneName -ComputerName $dnsServer

# Get used IPs
$usedIPs = $existingRecords | Where-Object { $_.RecordType -eq "A" } | ForEach-Object { $_.RecordData.IPV4Address.IPAddressToString }

# Generate a list of all possible IP addresses in the subnet
$allIPs = 0..254 | ForEach-Object { "$subnet$_" }

# Find available IPs
$availableIPs = $allIPs | Where-Object { $_ -notin $usedIPs }

# Filter out IP addresses where the last octet is greater than 255
$availableIPs = $availableIPs | Where-Object {
    $lastOctet = $_ -split '\.' | Select-Object -Last 1
    [int]$lastOctet -le 255
}

Write-Host "Available IP addresses:"
$availableIPs | ForEach-Object { Write-Host $_ }