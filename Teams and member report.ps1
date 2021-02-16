## parameters - select top N for Owners, Members, Guests ## 

# to prevent big column results
$OwnerTopN = '15'
$MemberTopN = '15'
$GuestTopN = '15'


### Microsoft Teams PowerShell Module Installed? ###
$MSTeamsModule = Get-Module -ListAvailable MicrosoftTeams
if (!$MSTeamsModule) {
    Write-Host "MicrosoftTeams PowerShell Module not installed." -ForegroundColor Yellow
    Write-Host "Install with 'Install-Module -Name MicrosoftTeams'" -ForegroundColor Yellow
    Write-Host
}
$Style = "
<style>
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#778899;vertical-align: top;text-align: left;}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;vertical-align: top;text-align: left;}
</style>
"
Connect-MicrosoftTeams
$MSTeams = Get-Team
$counter = 0
$object = @(foreach ($MSTeam in $MSTeams) {
    Write-Progress -Activity 'Processing Teams..' -CurrentOperation $MSTeam.DisplayName -PercentComplete (($counter / $MSTeams.Count) * 100)
    $TUser = Get-TeamUser -GroupId $MSTeam.GroupId 
    $owners = (($TUser | ?{$_.Role -eq 'Owner'}).User | Select-Object -First $OwnerTopN) -join ', '
    $members = (($TUser | ?{$_.Role -eq 'Member'}).User | Select-Object -First $MemberTopN) -join ', '
    $guests = (($TUser | ?{$_.Role -eq 'Guest'}).User | Select-Object -First $GuestTopN) -join ', '
    $ownersCount = (($TUser | ?{$_.Role -eq 'Owner'}).User).Count
    $guestCount = (($TUser | ?{$_.Role -eq 'Guest'}).User).Count
    $memberCount = (($TUser).User).Count - ($ownersCount + $guestCount)
    
    ## Create Custom Object
    [PSCustomObject]@{
        'DisplayName' = $MSTeam.DisplayName
        'Description' = $MSTeam.Description
        'Visibility' = $MSTeam.Visibility
        'Archived' = $MSTeam.Archived
        'UserCount' = ($TUser.UserID).Count
        'OwnersCount' = $ownersCount
        'MembersCount' = $memberCount
        'GuestCount' = $guestCount
        'Owners' = $owners
        'Members' = $members
        'Guests' = $guests
                 
    }
    $counter ++
})
$object | ConvertTo-Html -Property DisplayName,Description,Visibility, `
Archived ,UserCount,OwnersCount,MembersCount, GuestCount, Owners, Members,` 
Guests -Head $Style | Out-File -FilePath C:\TeamsReports.html

Write-Host "Saved C:\TeamsReports.html" -ForegroundColor Green


 