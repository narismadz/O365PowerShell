# Install Exo module ver 2
# Install-Module -Name ExchangeOnlineManagement


#Sign in with your O365 Admin credential
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
-ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#### Time Zone ####

#this should take sometimes depends on number of users 
#set timezone all users and room mailbox (optional) to SouthEast Asia
#not to run this if some user is in other countries 

Get-Mailbox -ResultSize Unlimited | Set-MailboxRegionalConfiguration -TimeZone "SE Asia Standard Time" 
# See the result
Get-Mailbox -ResultSize Unlimited | Get-MailboxRegionalConfiguration 


#### MAPI POP3 IMAP OWA ####

#disable mapi, pop3, imap and owa
Set-CASMailbox <Alias, Primary SMTP, or UPN> -PopEnabled $False
Set-CASMailbox <Alias, Primary SMTP, or UPN> -ImapEnabled $False
Set-CASMailbox <Alias, Primary SMTP, or UPN> -MAPIEnabled $False
Set-CASMailbox <Alias, Primary SMTP, or UPN> -OWAEnabled $False


#### Mail Forwarding ####

Set-Mailbox -Identity "admin" -ForwardingSMTPAddress "user@m365.com"

#check result
Get-Mailbox -Identity "admin" | format-list ForwardingSmtpAddress

##############################################################################################################
 

####################### InBulk senearios ###########################


#InBulk for user under domain below (exclude guest and unlicensed)

$Domain = "M365x171520.onmicrosoft.com" 



Connect-MsolService
Get-MsolUser -DomainName $Domain -All |? {$_.UserType -eq "Member" -and $_.IsLicensed -eq "True"} `
    | | Export-CSV C:\UsersLicensed.csv 



#### MAPI POP3 IMAP OWA ####

#For bulk disable mapi, pop3, imap and owa
Import-CSV C:\UsersLicensed.csv |%{Set-CASMailbox $_.UserPrincipalName `
  -PopEnabled $False -ImapEnabled $False -MAPIEnabled $False -OWAEnabled $False }
# See the result
 Import-CSV C:\UsersLicensed.csv |%{Get-CASMailbox $_.UserPrincipalName }`
    | Select Identity, PopEnabled, ImapEnabled, MAPIEnabled, OWAEnabled, ActiveSyncEnabled| FT 



#### Mail Forwarding ####

#For bulk mail forwarding
# at smtptargetcolumn use excel formula =LEFT(A3,FIND("@",A3)-1) && "@mecth3.com"
   
Import-CSV C:\UsersLicensed.csv | % { Set-Mailbox $_.UserPrincipalName -ForwardingSmtpAddress `
$_.smtptarget  }

# See the result
Import-CSV C:\UsersLicensed.csv |%{Get-Mailbox $_.UserPrincipalName }`
| Select UserPrincipalName, ForwardingSmtpAddress | FT 
 



#################################################################################################################
#Get-Mailbox -Identity "nestorw" | format-list DeliverToMailboxAndForward, ForwardingSmtpAddress
#Get-MsolUser -userprincipalName "crystal@mecth.com" | Select-Object -Property *
#Get-MsolUser |? {$_.UserType -eq "Member" -and $_.IsLicensed -eq "True"} 

