<# Default booking option settings for this scripts 

- Maximum booking lead time 180 days
- Maximum duration 24 hr.
- Allow repeating meetings : TRUE
- Allow scheduling only during working hours : FALSE 
- Always decline if the end date is beyond this limit : TRUE

Working hour: Mon-Fri 8:00AM-5:00PM (Default) Weekstart: Sunday

#>

### Add your settings here ####

$bookLeadTime = 180 #day
$MaxDuration = 1440 #24 hrs (INT32)

# 1 is True, 0 is false
$AllowRepeat = 1
$WorkingHr = 0 
$DeclineBeyound = 1

$WeekStartDay = "Sunday"
$Workdays = "Monday,Tuesday,Wednesday,Thursday, Friday" #Weekday
$StartTime = "08:00:00"
$EndTime = "17:00:00"

################################

# This script uses Exchange Online PS version 2
Install-Module -Name ExchangeOnlineManagement
Update-Module -Name ExchangeOnlineManagement

# sign in
Connect-ExchangeOnline


# Export Excel templates
Set-Content "c:\EquipmentMailBox.csv" -Value "Name,UserPrincipalName"

<#

input your equipment name at Name column
input your equipment mail address at UserPrincipalName column

You can use Excel formula to help insert domain to all
rows in UserPrincipalName column 

=SUBSTITUTE(A2," ","")&"@yourdomain.com"

Then save/replace this file (don't change it's file name)

#>


# convert equipment lists in .csv file to equipment mailbox
   
Import-CSV C:\EquipmentMailBox.csv | % { New-Mailbox -Name $_.Name `
-PrimarySmtpAddress $_.UserPrincipalName -Equipment } 

Import-CSV C:\EquipmentMailBox.csv | % { Set-CalendarProcessing `
-Identity $_.Name -BookingWindowInDays $bookLeadTime `
-MaximumDurationInMinutes $MaxDuration `
-AllowRecurringMeetings $AllowRepeat `
-ScheduleOnlyDuringWorkHours $WorkingHr `
-EnforceSchedulingHorizon $DeclineBeyound }

Import-CSV C:\EquipmentMailBox.csv | % { `
Set-MailboxCalendarConfiguration -Identity $_.Name `
-WorkingHoursStartTime $StartTime -WorkingHoursEndTime $EndTime `
-Workdays $Workdays -WeekStartDay $WeekStartDay }


# See the result
 
Write-Host "Equipment mailboxes list" -ForegroundColor Green
Get-EXOMailbox -Filter '(RecipientTypeDetails -eq "EquipmentMailBox")' `
| Select Name,Alias,PrimarySmtpAddress

