#!/bin/sh -p
### Test passing shell script parameter to gsubP as &sysparm
# Originally copied from /usr/bin.sasgsub as ~/scripts/sas94gsub and modified for 94. Andrew Farrer 17Dec2015
# Have a look inside Lev1/SASApp94L/GridServer/sasgrid for reference
# Usage gsubP -gridsubmitpgm sasmac_catlg_usecase.sas
# Usage gsubP -GRIDRUNSASLM
# Usage gsubP -GRIDRUNSASDMS
# Usage gsubP -GRIDSASOPTS "sysparm $sysparm"

if [ $# -eq 0 ]
then
  echo "Usage is $0 sysparm " 1>&2
  exit 255
fi
SYSPARM=$1

# JAVA_HOME=/sasfs/prod/java/jre32/jre1.6.0_16
# export JAVA_HOME

# LD_LIBRARY_PATH=$JAVA_HOME/lib/i386/server:$JAVA_HOME/lib/i386:/sasfs/prod/sas/92/sasgsubclient/sashome/SASGridManagerClientUtility/9.2/bin:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH

gsubP=/sasfs/prod/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub 
# /sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub -GRIDSUBMITPGM ~/sascode/gsub_sysparm.sas -GRIDSASOPTS "(-sysparm= "sasgsub_sysparm")"

$gsubP -GRIDSUBMITPGM ~/sascode/spds_gsub_parm_loop.sas -GRIDSASOPTS "(-sysparm "$SYSPARM")" -GRIDAPPSERVER SASApp94L \
-GRIDWATCHOUTPUT -GRIDJOBNAME spds_loop_$SYSPARM

