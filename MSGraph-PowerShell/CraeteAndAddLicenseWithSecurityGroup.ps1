# Input your csv file path here
$csvPath = "C:\Import-User-Password.csv"
# Name your group here
$SGGroupName = "M365-A3-PowerBI"
# specify license
$License = "M365EDU_A3_FACULTY","POWER_BI_PRO_FACULTY"


Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All, Group.ReadWrite.All
Import-Module Microsoft.Graph.Groups

# Create Security Group

$SGGroupId = New-MgGroup -DisplayName $SGGroupName `
-MailEnabled:$False `
-MailNickName $SGGroupName -SecurityEnabled

# Add member from csv to Group

Import-Csv -Path $csvPath | foreach {
$DirectoryObjId = Get-MgUser -UserId $_.UserPrincipalName
New-MgGroupMember -GroupId $SGGroupId.Id -DirectoryObjectId $DirectoryObjId.Id
}

# Assign licenses to Group (in array)

$Sku = @($License)

foreach ($item in $Sku) {


$item =  Get-MgSubscribedSku -All | `
Where SkuPartNumber -eq $item 


$params = @{
    AddLicenses = @(
        @{
            # Remove the DisabledPlans key as we don't need to disable any service plans
            # Specify the SkuId of the license you want to assign
            SkuId = $item.SkuId
        }
    )
    # Keep the RemoveLicenses key empty as we don't need to remove any licenses
    RemoveLicenses = @(
    )
}

Set-MgGroupLicense -GroupId $SGGroupId.Id -BodyParameter $params

}
