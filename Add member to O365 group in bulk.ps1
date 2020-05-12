## Input your Office 365 group alias here
$Identity = "allin"
$Domain = "M365x171520.onmicrosoft.com"



#Sign in with your O365 Admin credential
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
-ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#For Admin that use MFA need to download EXO PS V2
<#
Install-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
Import-Module ExchangeOnlineManagement; Get-Module ExchangeOnlineManagement 

#>

 

#export user to .csv ---> you may need to edit the user in .csv to exclude some users as you like
#sign in again
Connect-MsolService
Get-MsolUser -DomainName $Domain -All |? {$_.UserType -eq "Member" -and $_.IsLicensed -eq "True"} `
| Select UserPrincipalName, smtptarget  | Export-CSV C:\Users.csv 

 

# Import csv and add the user as member   
Import-CSV C:\Users.csv | % { Add-UnifiedGroupLinks -LinkType Members `
-identity $identity -Links $_.UserPrincipalName  } 


#see result can adjust result size $size if too much member to be display as a result
$size = 150

Write-Host $Identity"'s" "Owners" -ForegroundColor Green
Get-UnifiedGroupLinks -Identity $identity -LinkType Owners -ResultSize $size `
| Select-Object Identity, WindowsLiveID , PrimarySMTPAddress| FT 

Write-Host $Identity"'s"  "Members" -ForegroundColor Yellow
Get-UnifiedGroupLinks -Identity $identity -LinkType Members -ResultSize $size `
| Select-Object Identity, WindowsLiveID , RecipientType, Department | FT 


