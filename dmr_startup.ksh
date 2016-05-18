#! /bin/ksh
### Old SAS/Connect session startup
## This script is executed by sastcpd -sascmd once the userid.password from
## the remote SAS connection has been authenticated. 
## Set Oracle env vars just in case .profile not initiated by SAS/connect. 
#. /opt/sas9/home/sasadmin/defaults/SASConnectUsers.prof
/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -dmr -comamid tcp $*
