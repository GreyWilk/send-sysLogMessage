<#
.SYNOPSIS
    This script will send UDP message to SysLog server.

.EXAMPLE
    This sends a message to port 567 instead of default port (514).
    SendTo-SysLogServer.ps1 -logServerIP 192.168.1.100 -logServerPort 567 -message "This is my message to SysLog server!" -severity 3 -facility 1

    This sends a custom timestamp which is included in the message
    SendTo-SysLogServer.ps1 -logServerIP 192.168.1.100 -message "This is my message to SysLog server!" -severity 3 -facility 1 -setTimeStamp 'Jun 30 2022, 11:12:13'

--> Severity
0 = EMERG
1 = Alert
2 = CRIT
3 = ERR
4 = WARNING
5 = NOTICE
6 = INFO
7 = DEBUG

--> Facility
0 = kern (kernel messages)
1 = user (user-level messages)
2 = mail (mail system)
3 = daemon (system daemons)
4 = auth (security/authorization messages)
5 = syslog (messages generated internally by syslogd)
6 = lpr (line printer subsystem)
7 = news (network news subsystem)
8 = uucp (UUCP subsystem)
9 = clock daemon
10 = authpriv (security/authorization messages)
11 = ftp (FTP daemon)
12 = - (NTP subsystem)
13 = - (log audit)
14 = - (log alert)
15 = cron (clock daemon)
16 = local0 (local use 0 (local0))
17 = local1 (local use 1 (local1))
18 = local2 (local use 2 (local2))
19 = local3 (local use 3 (local3))
20 = local4 (local use 4 (local4))
21 = local5 (local use 5 (local5))
22 = local6 (local use 6 (local6))
23 = local7 (local use 7 (local7))
#>



[CmdletBinding(SupportsShouldProcess)]
param (
    [parameter(mandatory=$true,Position=0)][string]$logServerIP,
    [parameter(mandatory=$false,Position=1)][int]$logServerPort = 514,
    [parameter(mandatory=$false,Position=2)][string]$hostName = $env:COMPUTERNAME,
    [parameter(mandatory=$true,Position=3)][int]$severity,
    [parameter(mandatory=$true,Position=4)][int]$facility,
    [parameter(mandatory=$true,Position=5)][string]$message,
    [parameter(mandatory=$false,Position=7)]$customTimeStamp,
    [parameter(mandatory=$true,Position=8)][validateset("Simple","PRTG")]$messageFormat
)

# Create a UDP Client Object
$UDPCLient = New-Object System.Net.Sockets.UdpClient
$UDPCLient.Connect($logServerIP, $logServerPort)

# Calculate the priority
$priority = ([int]$Facility * 8) + [int]$Severity

#Time format the SW syslog understands
if( $customTimeStamp ){
    $outMessage = "$customTimeStamp | $message"
} else {
    $outMessage = $message
}

# Assemble the full syslog formatted message
switch($messageFormat){
    ## Visual Syslog Server
    'Simple'        { $fullSyslogMessage = "<{0}>{1} {2}" -f $priority, $hostname, $outMessage }
    ## PRTG Format
    'PRTG'          { $fullSyslogMessage = "<{0}>{1} {2} {3} {4} {5} {6} {7}" -f $priority, "1", $(Get-Date -f s), $hostname, " ", " ", " ", $outMessage }
}

# create an ASCII Encoding object and convert into byte array representation
$encoding = [System.Text.Encoding]::ASCII
$byteSyslogMessage = $encoding.GetBytes($fullSyslogMessage)

# Send the Message
$messageSent = $UDPCLient.Send($byteSyslogMessage, $byteSyslogMessage.Length)
$UDPCLient.Close()

return $fullSyslogMessage