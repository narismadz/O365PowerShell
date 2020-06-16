Import-Module -ExchangeOnlineManagement

# Sign in
Connect-ExchangeOnline

# Ex Dynamic group name "test dynamic"
$FTE = Get-DynamicDistributionGroup "test dynamic"


# See it's member
Get-Recipient -RecipientPreviewFilter $FTE.RecipientFilter -OrganizationalUnit $FTE.RecipientContainer

# see group properties
$FTE | Format-List
