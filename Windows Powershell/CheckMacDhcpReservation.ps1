# Replace with the IP address of the DHCP server
$DhcpServerIp = ""

# Replace with the specific MAC address you're looking for
$TargetMacAddress = "00-00-00-00-00-00"

# Get DHCP reservations and filter by the MAC address
$Reservation = Get-DhcpServerv4Reservation -ComputerName $DhcpServerIp |
               Where-Object ClientId -eq $TargetMacAddress

# Display reservation information if found
if ($Reservation) {
    $Reservation
} else {
    Write-Host "No reservation found for MAC address $TargetMacAddress."
}
