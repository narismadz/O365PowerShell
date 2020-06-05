
# Install Azure AD PowerShell Module 
# Skip these if you've already installed
Uninstall-Module AzureAD -AllVersions
Uninstall-Module AzureADPreview -AllVersions
Install-Module AzureADPreview

# need to sign in first
Connect-AzureAD 


# Export all guest users
$GuestUserList = Get-AzureADUser | where {$_.UserType -eq 'Guest'} 



# Delete all guest user

Get-AzureADUser | where {$_.UserType -eq 'Guest'} | Remove-AzureADUser

# Check the results
$GuestUserList

