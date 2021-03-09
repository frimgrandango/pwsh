PwSh <-> linux
**syntax of this file**
- The format of this file shows commands as follows:
    <powershell-cmdlet> - <linux-command>
  Where possible (or useful), I have included additional context around the command that might be helpful.
- Not every Command is 1:1, when in doubt, check the Microsoft docs (search: <cmdlet> inurl:https://docs.microsoft.com/en-us/powershell/)

**Powershell Cmdlet**
- Commands in powershell are known as cmdlets. Cmdlets perform an action and typically return a Microsoft .NET object to the next command in the pipeline. You can create your own cmdlets from other cmdlets and use them in your shell - https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7

**tips**
- Powershell is case insensitive
- Tab completion is your friend
- Switches can also be tab completed, type '-' and tab away
- Everything is verb-noun and usually follows common sense eg to find an alias use Get-Alias, to change the alias use Set-Alias
- Use the help commands if in doubt or the online help pages
- Pipes work the same in linux except everything in Powershell is an Object not a string.

**Commands**
*getting help*
Update-Help
#As modules can be imported and changed, you may need to update the help files on a system prior to using them (microsoft has a full online version available as well) however this cmdlet will update the help file on the local machine
get-help <cmdlet> - man <command>
#the '-ShowWindow' and '-online' switches can be appended to the command to open a separate window with the help file on the local machine and open a browser to the MS page for the cmdlet respectively
get-command - compgen -c
#can be used to find a specific command with 'get-command <command-name>', can also be used with wild cards eg 'get-command get*'
Get-History - history
Get-Alias - returns all alias' set in the current PwSh session (many linux commands have alias' to the Powershell equiv)
Set-Alias -name cls -value clear | alias cls=clear
#used to create or set an alias for the current session - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_aliases?view=powershell-7
Get-Module
#Powershell uses modules which are collections of cmdlets (a powershell command), this cmdlet returns what modules have been imported.
Get-Module -ListAvailable
#shows which modules can be imported into the current session

Copy-Item -path <path> -destination <destination> - cp
Move-Item -path <path> -destination <destination> - mv
Get-Content - cat
Get-Content -Path <path-to-file> -first <int> | head -n <int> <file>
Get-Content -Path <path-to-file> -tail <int> | tail -n <int> <file>
#Get-Content does not follow the file as tail does, you can use the -wait switch to do this. While waiting, Get-Content checks the file once each second and outputs new lines if present
Get-Content -Path <path-to-file> -wait | tail
Get-Location - pwd
Set-Location - cd #note: CD Is also an alias for set-location
New-Item -ItemType Directory -Path <path> -Name <string> (alias 'mkdir') | mkdir
Get-Childitem (alias 'gci' or 'ls') - ls
Select-String / findstr - grep
#eg get-content example.txt | select-string ERROR
Compare-Object (alias 'diff') - diff
Write-Output - echo
#can be useful to write write Env variables to an ouput eg Write-Output $env:COMPUTERNAME
Expand-Archive - unzip
Compress-Archive - zip
#the archive cmdlets are only available in Powershell 5 and later

Invoke-WebRequest - curl
#eg to pull a file - Invoke-WebRequest -uri <uri> -outfile <path-to-save-file>
get-childitem env: - env
#Powershell uses Providers to access specific data stores on the system, you can see whats available in the session via 'get-psdrive'. Env is the name of the environment Provider which is where all our environment variables are written - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7
Get-Acl <object> - ls -la <object>
#Gets the security descriptor for a resource, such as a file or registry key - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-acl?view=powershell-7
Get-Acl -Path "File1" | Set-Acl -Path "File2"
#To copy a security descriptor from one file to another (useful on core OS instances) - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-acl?view=powershell-7
get-service - systemctl list-unit-files
start-service - systemctl start <svc>
stop-service - systemctl start <svc>
restart-service - systemctl start <svc>
get-process - ps
Stop-Process - kill
Get-Volume - df
Stop-Computer - shutdown
Test-NetConnection - ping
#ping also works but Test-NetConnection is more versatile eg we can do a tcp ping and specify ports Test-NetConnection 172.0.100.123 -port 3389 - https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps
Get-NetRoute - route -n
Get-NetTCPConnection - NetStat
# We can filter on a bunch of properties, eg to check all established connections - Get-NetTCPConnection -State Established - https://docs.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection?view=win10-ps
Get-NetIPConfiguration - ifconfig

*Events*
# Events in windows are either in a logfile from our applications (which will be in our public documentation) however we often put them in the following directory:
"C:\ProgramData\Amazon\<svc>\Logs"
# a Note on 'C:\ProgramData' - this directory is hidden by default so you will not see it in explorer or the output of ls, you can use the '-hidden'
# To review events on the machine that happened in the past day you can use the below PowerShell command [], inserting the desired EventID in for <Event_ID>:
$date = (get-date).AddDays(-1)
get-winevent -FilterHashtable @{LogName="System";Id="<Event_ID>";StartTime=$date}

# You can also filter for events in the event log with the below PowerShell command, replacing <EventID> with the event ID you are looking for:
get-winevent -FilterHashtable @{LogName="System"} | Where-Object {$_.ID -eq <EventID>} | Format-List
