# Input your csv file path here
$csvPath = "C:\Import-User-Password.csv"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install-Module -Name Microsoft.Graph #hide this if already installed


Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All


<# csv fields includes
- UserPrincipalName
- FirstName
- LastName
- DisplayName
- AccountSKUId *** no need to put domain
- UsageLocation
- Password
#>


Import-Csv -Path $csvPath | foreach {

# Get SKU ID
$Sku = Get-MgSubscribedSku -All | `
Where SkuPartNumber -eq $_.AccountSkuId
$addLicenses = @(
  @{SkuId = $Sku.SkuId}
  )
# Get user based on UserPrincipalName in csv 
$user = Get-MgUser -UserId $_.UserPrincipalName 

# Assign license
Set-MgUserLicense -UserId $user.Id  `
-AddLicenses $addLicenses `
-RemoveLicenses @()

}





