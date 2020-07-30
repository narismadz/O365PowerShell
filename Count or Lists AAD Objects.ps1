#Install NuGet offline (if you cann't install AzureAD module due to NuGet)
# Open PS as Admin

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet


# Install Azure AD PowerShell Module 
# Skip these if you've already installed
Uninstall-Module AzureAD -AllVersions
Uninstall-Module AzureADPreview -AllVersions
Install-Module AzureADPreview


# Connect Azure AD
Connect-AzureAD


# count of Azure AD Users
(Get-AzureADUser -all $true | Where {$_.DirSyncEnabled -eq $true}).Count


# List all Azure users
Get-AzureADUser -all $true | Where {$_.DirSyncEnabled -eq $true}


#count of cloud only AAD users
(Get-AzureADUser -all $true | Where {$_.DirSyncEnabled -eq $null}).Count


# List of cloud only AAD users
Get-AzureADUser -all $true | Where {$_.DirSyncEnabled -eq $null}

# Count license and quotas
Get-AzureADSubscribedSku | select SkuPartNumber,ConsumedUnits -ExpandProperty PrepaidUnits

# To see quotas used in AAD tenant use graph api, go https://aka.ms/ge to and sign in 
# GET method, version Beta
# https://graph.microsoft.com/v1.0/organization/
# list under
<# 

"directorySizeQuota": {
"used": xxxx,
"total": 300000
},


#>

