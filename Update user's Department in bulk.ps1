#Sign in with your O365 Admin credential
Connect-MsolService

#Select your domain here
#Select number that you want to display
$Domain = "adventureworksthai.onmicrosoft.com"
$result = 50

#see your current department on all users
#result based on $result value

Write-Host `n "Current state of" $Domain -ForegroundColor Yellow
Get-MsolUser -DomainName $Domain -MaxResults $result | Select DisplayName, UserPrincipalName, `
Department


#Export all user
Get-MsolUser -DomainName $Domain -All |? {$_.UserType -eq "Member" -and $_.IsLicensed -eq "True"} `
| Select UserPrincipalName, DepartmentUpdate | Export-CSV C:\Departmentusers.csv

### Then fill user's department in DepartmentUpdate Column in .csv file

# Import csv and Update Department of user arrcoding to .csv 
Import-CSV C:\Departmentusers.csv  | % { Set-MsolUser -UserPrincipalName $_.UserPrincipalName `
-Department $_.DepartmentUpdate }


#see updated result
#result based on $result value

Write-Host `n "Updated state of" $Domain -ForegroundColor Green
Get-MsolUser -DomainName $Domain -MaxResults $result | Select DisplayName, UserPrincipalName, `
Department