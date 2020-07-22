## This script use AzureADPreview module
## But the command itself can do for current module

#install AAD Preview module
Uninstall-Module AzureAD -AllVersions
Uninstall-Module AzureADPreview -AllVersions
Install-Module AzureADPreview

Connect-AzureAD


#get all aad users and save to csv and save to C: drive
Get-AzureADUser -All 1 | export-csv "c:\users.csv" `
–NoTypeInformation -Encoding utf8


#get all aaduser and save to csv (filter some column out)

Get-AzureADUser -All 1 |Select-Object ObjectId, Country, `
Department, DirSyncEnabled, DisplayName, JobTitle, UserPrincipalName | 
export-csv "c:\users.csv" –NoTypeInformation -Encoding utf8

