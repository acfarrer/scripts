#! /bin/sh
### Start SAS/Share server as background process. Add nohup sometime 
if [ $# -eq 0 ]
then
PORT=5002
fi
PORT=$1
OWD=$CWD
cd ~/sascode
SAS94=/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas 
$SAS94 -work ~/saswork/ -sysin ~/sascode/share_server_start_$PORT.sas -unbuflog &
echo $! > $(basename $0 .sh)_$(hostname)_$PORT.pid
sleep 2
netstat -an | grep $PORT
nmap localhost -p $PORT
echo PID is $(cat $(basename $0 .sh)_$(hostname)_$PORT.pid)
cd $OWD
