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

Get-ChildItem C:\GuestUsers.csv |Select-Object Length

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


