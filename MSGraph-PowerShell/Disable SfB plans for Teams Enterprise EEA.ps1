# Input your csv file path here
$csvPath = "C:\Import-User-Password.csv"



Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

Import-Csv -Path $csvPath | foreach {

## Get the services that have already been disabled for the user.
$userLicense = Get-MgUserLicenseDetail -UserId $_.UserPrincipalName
$userDisabledPlans = $userLicense.ServicePlans | `
    Where ProvisioningStatus -eq "Disabled" | `
    Select -ExpandProperty ServicePlanId


## Get the SfB plans that are going to be disabled marked as new disable plan

$eSku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq $_.AccountSkuId
$newDisabledPlans = $eSku.ServicePlans | Where ServicePlanName -in `
    ("MCOSTANDARD_MIDMARKET", 
    "MCOSTANDARD", 
    "MCOIMP", 
    "MCOLITE",
    "MCOPSTN1",
    "MCOPSTN2",
    "MCOPSTN5",
    "MCOPSTNPP"
    ) | Select -ExpandProperty ServicePlanId


## Merge the new plans that are to be disabled with the user's 
## current state of disabled plans
$disabledPlans = ($userDisabledPlans + $newDisabledPlans) | Select -Unique

$addLicenses = @(
    @{
        SkuId = $eSku.SkuId
        DisabledPlans = $disabledPlans
    }
)
## Update user's license
Set-MgUserLicense -UserId $_.UserPrincipalName `
-AddLicenses $addLicenses -RemoveLicenses @()

}
