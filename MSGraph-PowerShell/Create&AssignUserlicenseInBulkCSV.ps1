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

# Create user password profile
$PasswordProfile = @{
  Password = $_.Password
  }

# Get SKU ID
$Sku = Get-MgSubscribedSku -All | `
Where SkuPartNumber -eq $_.AccountSkuId
$addLicenses = @(
  @{SkuId = $Sku.SkuId}
  )
# Create user 
$user = @(
New-MgUser -DisplayName $_.DisplayName `
-GivenName $_.FirstName `
-SurName $_.LastName `
-UserPrincipalName $_.UserPrincipalName `
-UsageLocation $_.UsageLocation `
-PasswordProfile $PasswordProfile `
-MailNickName $_.UserPrincipalName.Split("@")[0] `
-AccountEnabled
)
# Assign license
Set-MgUserLicense -UserId $user.Id  `
-AddLicenses $addLicenses `
-RemoveLicenses @()
}


