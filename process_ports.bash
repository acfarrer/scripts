#! /bin/bash
### TCP ports used by a PID
## From http://stackoverflow.com/questions/3306138/how-i-can-get-ports-associated-to-the-application-that-opened-them/3308198#3308198
# Needs some work to parse multiple sockets
PID=$1
socket=$(ls -l /proc/$PID/fd  | grep socket | sed 's/.*socket:\[//' | sed 's/\]//')
grep $socket /proc/net/tcp
