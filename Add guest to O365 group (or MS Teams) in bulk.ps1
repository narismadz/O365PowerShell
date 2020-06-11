<#

This will create some sync time form Office 365 Group to Teams
 
If you want to see immediate result in MS Team you can
- create distribution group and bulk adding user in it (see my - Add bulk user to Distribution List.ps1)
- add that DL in your specified team in Teams client as member 

#>


## Input your Office 365 group or team name (MS Teams) here
$Identity = "Externals" 

#install Azure AD PowerShell Module 
# Skip these if you've already installed
Uninstall-Module AzureAD -AllVersions
Uninstall-Module AzureADPreview -AllVersions
Install-Module AzureADPreview

#install Exchange Online V2 Module 
# Skip these if you've already installed
Install-Module -Name ExchangeOnlineManagement


<# export user to .csv ---> you may need to edit the user in .csv 
to exclude some users as you like #>

Connect-AzureAD #need to sign in first
Get-AzureADUser |where {$_.UserType -eq 'Guest'} `
|Select-Object DisplayName, @{l="MailNickname";e={ $_.MailNickname.replace("_","@").replace("#EXT#","")}}`
| Export-CSV C:\GuestUsers.csv

# Import csv and add the user as guest  
Connect-ExchangeOnline 
Import-CSV C:\GuestUsers.csv | % { Add-UnifiedGroupLinks -LinkType Members `
-identity $identity -Links $_.MailNickname} 


<# see results can adjust result size $size if too much 
members to be display as a result #>
$size = 150 

# show all Owners, Members and Guests

Write-Host $Identity"'s" "Owners" -ForegroundColor Green
Get-UnifiedGroupLinks -Identity $identity -LinkType Owners -ResultSize $size `
| Select-Object Identity, WindowsLiveID , PrimarySMTPAddress| FT 

Write-Host $Identity"'s"  "Members" -ForegroundColor Yellow
Get-UnifiedGroupLinks -Identity $identity -LinkType Members -ResultSize $size `
| Select-Object Identity, WindowsLiveID , RecipientType, Department | FT 


