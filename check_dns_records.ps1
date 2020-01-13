#func to check dns records and resolve time.
function get-srvrecord ($record_prefix, $dns_name, $dns_server)
{
 Resolve-DnsName -Type SRV -Name "$record_prefix.$dns_name" -Server $dns_server -DnsOnly
 $before=get-date ; Resolve-DnsName -Type SRV -Name "$record_prefix.$dns_name" -Server $dns_server -DnsOnly |out-null ;$after=get-date; new-timespan -Start $before -End $after  
}

#vars for check
$record_prefix = ('_ldap._tcp','_kerberos._tcp')
$dns_name = 'example.com'
$dns_servers = ('192.168.0.100', '192.168.0.101')

#ensure trailing . is included in dns name
if ($dns_name[-1] -ne '.' )
    {
     $dns_name = "$dns_name."
    }

#check each server for response / time
foreach ($dns_server in $dns_servers) {
    "Record response for {0} for Server {1}" -f $record_prefix[0], $dns_server
    get-srvrecord -record_prefix $record_prefix[0] -dns_name $dns_name -dns_server $dns_server
    "Record response for {0} for Server {1}" -f $record_prefix[1], $dns_server
    get-srvrecord -record_prefix $record_prefix[1] -dns_name $dns_name -dns_server $dns_server
    }
