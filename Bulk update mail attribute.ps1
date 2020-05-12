#check each user
Get-ADUser -Identity ChewDavid -Properties *

#check user in OU
Get-ADUser -Filter * -SearchBase "OU=BKK,DC=labptg1,DC=local"
 
# Update mail attribute (SMTP for soft match) - in case of same as SamAccount
Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase 'OU=BKK,DC=labptg1,DC=local' | `
ForEach-Object { Set-ADUser -EmailAddress ($_.samaccountname + '@labptg1.com') -Identity $_ }

# another example 
Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase 'OU=BKK,DC=labptg1,DC=local' | `
ForEach-Object { Set-ADUser -EmailAddress ($_.givenName + '.' + $_.surname + '@labptg1.com') -Identity $_ }


# Update UPN (from .local to .com)
Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase 'OU=BKK,DC=labptg1,DC=local' | `
ForEach-Object { Set-ADUser -UserPrincipalName ($_.samaccountname + '@labptg1.com') -Identity $_ }