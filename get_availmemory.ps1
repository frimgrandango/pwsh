function get-freememory{
    #available memory perf counter
    $available_memory = (Get-Counter '\Memory\Available MBytes').counterSamples.CookedValue
    #store the total memory
    $total_memory = (Get-WmiObject -Class Win32_ComputerSystem | select TotalPhysicalMemory).TotalPhysicalMemory / 1MB
    #get the percentage free
    write-output "
    write-output " Memory used ($available_memory / $total_memory).tostring("P")  
}
