#Short script to pull recent windows event entries from a machine

#time of your event
$start_time = "9/7/2019 12:34:37 AM"
$end_time = "9/7/2019 12:35:37 AM"

#get all event logs
$event_logs = Get-WinEvent -ListLog * -EA silentlycontinue | where-object { $_.recordcount -gt 0} 

#filter through list to find events
foreach ($event_log in $event_logs) {
    "Seraching {0}" -f $event_log.LogName
    try
    {
       get-winevent -FilterHashtable @{LogName=$event_log.LogName;StartTime=$start_time;EndTime=$end_time} -ErrorAction SilentlyContinue
    }
    catch
    {
     "An Error has occurred"
    }
 }
