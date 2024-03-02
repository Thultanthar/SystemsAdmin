# Import the Active Directory module
Import-Module ActiveDirectory

# Get all user objects with a non-empty uidNumber attribute
$users = Get-ADUser -Filter { uidNumber -like '*' } -Properties uidNumber, sAMAccountName

# Sort the users based on their UNIX IDs
$sortedUsers = $users | Sort-Object uidNumber

# Display current users with their UNIX IDs in sorted order
if ($sortedUsers.Count -eq 0) {
    Write-Host "No users found with UNIX IDs in Active Directory."
} else {
    Write-Host "Current users with their UNIX IDs (sorted):"
    foreach ($user in $sortedUsers) {
        Write-Host "$($user.sAMAccountName): $($user.uidNumber)"
    }
}

# Define the range of UNIX IDs to check
$minUidNumber = 3110
$maxUidNumber = 3300  # Modify this value based on your requirement

# Get all user objects with a non-empty uidNumber attribute
$users = Get-ADUser -Filter { uidNumber -like '*' } -Properties uidNumber, sAMAccountName

# Sort the users based on their UNIX IDs
$sortedUsers = $users | Sort-Object uidNumber

# Create an array to hold used UNIX IDs
$usedUidNumbers = $sortedUsers.uidNumber

# Find available UNIX IDs by checking for gaps in the range
$availableUidNumbers = $minUidNumber..$maxUidNumber | Where-Object { $_ -notin $usedUidNumbers }

# Display current users with their UNIX IDs in sorted order
if ($sortedUsers.Count -eq 0) {
    Write-Host "No users found with UNIX IDs in Active Directory."
} else {
    Write-Host "Current users with their UNIX IDs (sorted):"
    foreach ($user in $sortedUsers) {
        Write-Host "$($user.sAMAccountName): $($user.uidNumber)"
    }
}

# Display available UNIX IDs
if ($availableUidNumbers.Count -eq 0) {
    Write-Host "No available UNIX IDs in the specified range."
} else {
    Write-Host "Available UNIX IDs to fill the gaps:"
    $availableUidNumbers
}
