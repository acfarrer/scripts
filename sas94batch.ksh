#! /bin/ksh
### Execute SAS progs in standard manner with optional sysparm.
## Take progname as argument and generate log file based as progname.ddmmmccyy.log
 
if [ $# -eq 0 ]
then
 print "$0: Usage is sasbatch.ksh pathname/progname.sas sysparm " 1>&2
  exit 255
fi
if [ ! -f "$1" ]
then
  print "Error: $1 does not exist"
  exit 15
fi
timer=`date '+%Y%m%d' `
proghome=`dirname $1 `

if [ ! -d "$proghome/../saslogs" ] ; then
  mkdir $proghome/../saslogs
  if [ $? -eq 0 ] ; then
    print "Note: $proghome/../saslogs has been created"
    else exit 14
  fi
fi

sas_prog=`basename $1 `
#progname=`basename $1 | awk -F. '{print $1}' `
progname=$(basename $1 .sas)
sas_dir=/sasfs/prod/sas/94/controlserver/sashome/SASFoundation/9.4
sas_config=/sasfs/prod/sas/94/controlserver/sasconfig
if [ $# -eq 2 ]
then
lastparm="-sysparm $2"
logname=$progname.$timer.$2.pid$$.log
else
lastparm=''
logname=$progname.log.$timer
fi
print "Note: Log will be $proghome/../saslogs/$logname"
 
# From /opt/sas/ServerConfig/Lev1/DIApp/BatchServer/sasbatch.sh
# Set config file path
SASCFGPATH="$sas_dir/sasv9.cfg, $sas_config/Lev1/SAS94App/sasv9.cfg, $sas_config/Lev1/SAS94App/sasv9_usermods.cfg, $sas_config/Lev1/SAS94App/BatchServer/sasv9.cfg, $sas_config/Lev1/SAS94App/BatchServer/sasv9_usermods.cfg"
export SASCFGPATH

#cd $proghome

# -config $sas_dir\sasv9.cfg  Now defined by $SASCFGPATH 

$sas_dir/sas -sysin $1 \
-log $proghome/../saslogs/$logname \
-altlog $proghome/../saslogs/$progname.log \
-metaprofile ~/metaprofiles.xml \
-memsize 2G \
-cpucount 4 \
-work /tmp \
-nonews \
-noautoexec \
$lastparm
rc=$?
if [ $rc -eq 0 ] ; then
  stat=OK
elif [ $rc -eq 1 ] ; then
  stat=Warnings
elif [ $rc -ge 2 ] ; then
  stat=Errors
fi

#$HOME/scripts/SASlogemail.ksh $proghome/../SASlogs/$progname.log andrew.farrer@bmo.com
#mailx -s "$1 $2 done - $stat" -a $proghome/../SASlogs/$progname.log andrew.farrer@bmo.com
echo "$1 $2 done - $stat"
exit $rc    # For LSF
