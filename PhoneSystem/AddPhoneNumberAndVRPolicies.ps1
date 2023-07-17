# Input your csv file path here
$csvPath = "C:\phone-users.csv"


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 

# import module and sign in
Import-Module MicrosoftTeams
Connect-MicrosoftTeams


Import-Csv -Path $csvPath | foreach {

Write-Host "Add number:" $_.PhoneNumber + " User:" + $_.Email `
-ForegroundColor Green


<# Check extension value for the current csv row
 and add to the PhoneNumber property #>
$Extension = [int]$_.Extension
if ($Extension -eq "") { $Extension = $_.PhoneNumber } 
else {$Extension = $_.PhoneNumber + ";ext=" + $_.Extension }


# Add phone number to the user
Set-CsPhoneNumberAssignment -Identity $_.Email `
<# choose between DirectRouting, CallingPlan or OperatorConnect #> `
-PhoneNumber $Extension -PhoneNumberType $_.PhoneNumberType 
 
# Add voice routing policies
Grant-CsOnlineVoiceRoutingPolicy -Identity $_.Email `
-PolicyName $_.VRPolicyName


}












