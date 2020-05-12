#create user1.csv

$cred = Get-Credential
Connect-MsolService -Credential $cred

#https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference
# Ex. E1 name as <companyname>:STANDARDPACK 18181a46-0d4e-45cd-891e-60aabd171b4e

Get-MsolAccountSku |ft AccountSkuId

#see all properties Get-MsolUser -UserPrincipalName "bma00001@bangkok365.onmicrosoft.com" | Format-List -Property *

Get-MsolUser -MaxResults 20 |ft UserPrincipalName, UsageLocation

# Add license

$AccountSkuId = "bangkok365:STANDARDPACK"
$UsageLocation = "TH"
$Users = Import-Csv c:\user1.csv
$users |% {Set-MsolUser -UserPrincipalName $_.UserPrincipalName -UsageLocation $UsageLocation}
$users |% {Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses $AccountSkuId}
