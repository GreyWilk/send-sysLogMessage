# send-sysLogMessage

Send a syslog message to syslog server.

Required input params: 
- $logServerIP 
- $severity 
- $facility 
- $message 
- $messageFormat [Simple / PRTG] 

Can specify severity and facility: 

--> Severity\
0 = EMERG\
1 = Alert\
2 = CRIT\
3 = ERR\
4 = WARNING\
5 = NOTICE\
6 = INFO\
7 = DEBUG\
\
--> Facility\
0 = kern (kernel messages)\
1 = user (user-level messages)\
2 = mail (mail system)\
3 = daemon (system daemons)\
4 = auth (security/authorization messages)\
5 = syslog (messages generated internally by syslogd)\
6 = lpr (line printer subsystem)\
7 = news (network news subsystem)\
8 = uucp (UUCP subsystem)\
9 = clock daemon\
10 = authpriv (security/authorization messages)\
11 = ftp (FTP daemon)\
12 = - (NTP subsystem)\
13 = - (log audit)\
14 = - (log alert) 
15 = cron (clock daemon)\
16 = local0 (local use 0 (local0))\
17 = local1 (local use 1 (local1))\
18 = local2 (local use 2 (local2))\
19 = local3 (local use 3 (local3))\
20 = local4 (local use 4 (local4))\
21 = local5 (local use 5 (local5))\
22 = local6 (local use 6 (local6))\
23 = local7 (local use 7 (local7))\