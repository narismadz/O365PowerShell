# This command useful if tenant is cloud-only



# Install Azure AD PowerShell Module 
# Skip these if you've already installed
Uninstall-Module AzureAD -AllVersions
Uninstall-Module AzureADPreview -AllVersions
Install-Module AzureADPreview

# need to sign in first
Connect-AzureAD 



<# Choose export users options
    1. Export all users
    2. Export by Departments (recommended)

#> 

# 1. Export all users to .csv

Get-AzureADUser | Select ManagerId-FillHere,ObjectId,UserPrincipalName,DisplayName,`
Department,MailNickName,JobTitle | Export-CSV C:\UsersObjectID.csv 

# 2. Export all users in departments to .csv (recommended)

$department = "IT" #input your department here

Get-AzureADUser  |? {$_.Department -eq $department} `
| Select ManagerId-FillHere,ObjectId,UserPrincipalName,DisplayName,`
Department,MailNickName,JobTitle | Export-CSV C:\UsersObjectID.csv 


# Import csv and add manger to all users specified in column
    
Import-CSV C:\UsersObjectID.csv | % { Set-AzureADUserManager `
-ObjectId $_.ObjectId -RefObjectId $_."ManagerId-FillHere"  } 
Write-Host `n "successful" $Domain -ForegroundColor Green

# run this to see result

Write-Host `n "User" $Domain -ForegroundColor Yellow 
Import-CSV C:\UsersObjectID.csv | select DisplayName, UserPrincipalName | FT

Write-Host `n "Manager" $Domain -ForegroundColor Green
Import-CSV C:\UsersObjectID.csv | % { Get-AzureADUserManager  `
-ObjectId $_.ObjectId } | select `
@{N=’DisplayName’; E={$_.DisplayName}},
@{N=’Manager-mail’; E={$_.UserPrincipalName}} | FT 









