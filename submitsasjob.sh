#!/bin/sh
### Submit SAS program to Grid from CLUWE web interface.
#****************************************************************************************
# This file:  submitsasjob.sh
#
# This script sets up the environment needed to execute the sasgsub command line too
# used to submit sas jobs then submits the job to the grid.  It also ensures that the user
# submitting the job is a member of the one of the SAS Grid ldap groups.
#
# This script is run by the user cluwe-webui, cluwe-webui-q or cluwe-webui-d based on 
# the environment.
# Note: Parameters
# $1 = Full path of the program to submit
# $2 = An identifier used to correlate log entries with the web site's logs
# $3 = Grid context
# $4 = Y/N value indicating whether sas should send an email to the user once the job is complete

# 
# INPUT:
#	None
# OUTPUT:
#	None
# ASSOCIATED:
#	SAS GRID file system mounted at /sasfs. 
#
#****************************************************************************************
# REVISION HISTORY:
# Change Date           Name             Changes Made
#
#****************************************************************************************
#  9/10/2015		     David Fleig (tc88497)        Initial creation.
#  10/19/2015		     David Fleig (tc88497)        Updated to include -GRIDAPPSERVER param and remove commented statements.
#  2/11/2016             Nikhil Das Nomula (v6x5932)  Added an additional param gridContext

# Check for the correct number of parameters

#
######## DO NOT USE in PROD.  This file was updated for M3 testing only.
#

if [ $# -ne 4 ]
  then
    echo "Incorrect number of arguments supplied."
    echo "Usage: $0 <program> <transactionId> <context> <email?>"
    exit 1
fi

echo "******** Starting $0 script ************"
echo "** start time: `date`"
echo "** start directory: `pwd`"
echo "** running as: `whoami`"

currentUser=`whoami`
programPathAndName="$1"
transactionId="$2"
gridContext="$3"
emailFlag="$4"


programPath=`dirname "$programPathAndName"`
programName=`basename "$programPathAndName"`

echo "** program: $programName"
echo "** path: $programPath"
echo "** transactionId: $transactionId"
echo "** Send email when complete?: $emailFlag"
echo "** Grid context: $gridContext"

# Set the email flag if passed in
if [ "$emailFlag" == "Y" ] || [ "$emailFlag" == "y" ]; then 
    echo "** An email will be sent by sasgsub on completion."
    LSB_JOB_REPORT_MAIL=Y
    export LSB_JOB_REPORT_MAIL
else
    echo "** An email will NOT be sent by sasgsub on completion."
    LSB_JOB_REPORT_MAIL=N
    export LSB_JOB_REPORT_MAIL
fi

sasgsubCommand="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub"
submitOptions="-GRIDSUBMITPGM \"$programName\" -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS "(-initstmt 'ods path (prepend) work.template (update)')" "

# Set the SAS environment variables
export ORACLE_HOME=/sasfs/data/jreview/DEV/stats/irserver/oic_11_2_Linux_x86_64
export LSF_FULL_VERSION=8.01
export LSF_BINDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/bin
export LSF_SERVERDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/etc
export LSF_LIBDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/lib
export LD_LIBRARY_PATH=${ORACLE_HOME}:/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/lib
export LSF_ENVDIR=/sasfs/test/platformcomputing/lsf/conf
export MANPATH=/sasfs/test/platformcomputing/lsf/8.0/man:
export EGO_TOP=/sasfs/test/platformcomputing/lsf
export EGO_BINDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/bin
export EGO_SERVERDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/etc
export EGO_LIBDIR=/sasfs/test/platformcomputing/lsf/8.0/linux2.6-glibc2.3-x86_64/lib
export EGO_CONFDIR=/sasfs/test/platformcomputing/lsf/conf/ego/SASGrid_ProdCluster1/kernel
export EGO_LOCAL_CONFDIR=/sasfs/test/platformcomputing/lsf/conf/ego/SASGrid_ProdCluster1/kernel
export EGO_ESRVDIR=/sasfs/test/platformcomputing/lsf/conf/ego/SASGrid_ProdCluster1/eservice

echo "** Using the following environment variables"
env

echo "** Changing to program path $programPath"
cd "$programPath"

echo "** Executing command: $sasgsubCommand $submitOptions "
$sasgsubCommand $submitOptions
exitStatus=$?

echo "** end time: `date`"
echo "******** Script execution complete. Returning sasgub exit code: $exitStatus  ********"
exit $exitStatus

