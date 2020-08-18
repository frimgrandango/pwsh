#Hyper-V providers leveraged in containers
$providers = "Microsoft-Windows-Hyper-V-VmSwitch","Microsoft-Windows-Hyper-V-Compute"

#time of your event
$start_time = "8/17/2020 3:30:37 AM"
$end_time = "8/17/2020 3:50:37 AM"

foreach ($provider in $providers) {
  get-winevent -FilterHashtable @{ProviderName=$provider;StartTime=$start_time;EndTime=$end_time} -ErrorAction SilentlyContinue
  } 
