#### AD HARD MATCH #### ## use when Soft match is not work ##

## or see error like AttributeValueMustBeUnique

# Install module required
Install-Module -Name AzureADPreview
Install-Module MSOnline

# Connect to Office 365 and Azure AD
Connect-AzureAD
Connect-MsolService

#####################################################################################

####### Hard match 1 user #######

## Get-ADUser -Filter 'Name -like "*nestor*"' 

$upn = "admin@mwlab.xyz" ## userUserPrincipalName Input parameter here

# run these to perform Hard match

$GUID = (Get-ADUser -Filter {UserPrincipalName -eq $upn}).ObjectGUID
$ImmutableID = [System.Convert]::ToBase64String($GUID.tobytearray())
Set-MSOLuser -UserPrincipalName $upn -ImmutableID $immutableID

# Start sync and see the result
Start-ADSyncSyncCycle -PolicyType Delta 
 
# See the result sync status (it will show result if completed)
Get-MsolUser -SearchString $upn -Synchronized


#####################################################################################


####### Hard match in bulk #######


# Get alias all user UPN and save as .csv (Ex. dcm365.local -> DC=dcm365,DC=local)
Get-ADUser -SearchBase “DC=mwlab,DC=xyz” -Filter * -Properties * `
| Select-Object -Property Name,SamAccountName,EmailAddress | Sort-Object -Property Name `
| Export-Csv -path C:\ADUsers.csv


# run these to perform Hard match

$csv = Import-Csv "C:\ADUsers.csv"
foreach($item in $csv)
    {
     $upn = $($item.EmailAddress)
     $GUID = (Get-ADUser -Filter {UserPrincipalName -eq $upn}).ObjectGUID
     $ImmutableID = [System.Convert]::ToBase64String($GUID.tobytearray())
     Set-MSOLuser -UserPrincipalName $upn -ImmutableID $immutableID  
    }



# Start sync and see the result
Start-ADSyncSyncCycle -PolicyType Delta 

 
# See the result sync status (it will show result if completed)

foreach($item in $csv)
    {
     $upn = $($item.EmailAddress)
     Get-MsolUser -SearchString $upn -Synchronized  
    }