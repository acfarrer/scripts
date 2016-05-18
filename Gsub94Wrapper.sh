#!/bin/bash
### Submit SAS program from JReview interface
# =====================================================================
#         File Name: GsubWrapper.sh
#           Purpose: Scripts to Submit a SAS job to a grid using sasgsub, waits 
#                    for the job to finish and returns the RC of the job.
#           Programs Called: 
#           Files Included : 
# ------------------------------------------------------------------------------
#  Change Log:
#  Name         Date          CR#         Description
#  ------------ ------------  ----------  --------------------------------------
#  C178225      20-Nov-2014   CR06708181   Created
#  Rajat Jain (ITSME)
#  Andrew Farrer 21Apr2016                 Tweaking
# ==============================================================================
# END OF COMMENT HEADER

#set -x
#****************************************************************************
#* Submits a SAS job to a grid using sasgsub, waits for the job to
#* finish and returns the RC of the job.
#*
#* For SAS versions 9.2m2 through 9.3m1
#*
#* Version 20140109
#****************************************************************************

#**************************************************************************
# You may/must edit the values in this section
#**************************************************************************

# Set 'debug' to 1 to get debug output
debug=0

# Edit the following variable to point to your SAS configuration directory
# if you do not set the SASCONFIGDIR environment variable
#
# It should look something like
#    sasconfigdir="/opt/SAS/config/Lev1"
SASCONFIGDIR="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1"
#SASCONFIGDIR="/sasfs/prod/sas/94/sasgsubclient/sasconfig/Lev1"
export SASCONFIGDIR
sasconfigdir=$SASCONFIGDIR
if [ -z "$sasconfigdir" ]
then
    sasconfigdir="/config_dir/LevX"
fi

# The number of seconds to wait between status checks. It should be at
# least 5 seconds.
# This is done for two reasons:
#   1) The polling of the status should not be done too often or the grid
#      performance may suffer
#   2) There may be a delay between when a job is done and when the file
#      system has updated its information
waittime=15


#**************************************************************************
#  !!! Do not edit below this line !!!
#**************************************************************************



#**************************************************************************
#   Functions
#**************************************************************************
usage()
{
    echo ""
    echo "gsubrc93: Submits a SAS program to the grid using SASGSUB v9.2m2 through 9.3M1"
    echo "          and waits for a return code"
    echo ""
    echo "USAGE: gsubrc93 *.sas [SASGSUB options]"
    echo "   *.sas           - Required: a sas job file for sasgsub to submit to a grid."
    echo "   sasgsub options - Optional: Any additional sasgsub options."
    echo ""
    echo "gsubrc93 will print the return code and set the return value of the script"
    echo "to that return code."
    echo ""
}


checkStatus()
{
    #------------------------------------------------------
    # Initialize return value
    rc=-1

    #------------------------------------------------------
    # Try to grab the results
    # $sasgsubdir/sasgsub -metapass $metapass -gridgetresults $jnum >$tmpfile
    $sasgsubdir/sasgsub -gridgetresults $jnum >$tmpfile

    #------------------------------------------------------
    # Dump the output if debugging
    if [ "$debug" -eq "1" ]
    then
        cat $tmpfile
    fi

    #------------------------------------------------------
    # Did it start running?
    resultstr=`cat $tmpfile | grep -i "is Running"`
#echo "tmpfile variable: " $tmpfile >> jreviewsas_output.out
    if [ -n "$resultstr" ]
    then
        if [ $runmsg -eq 0 ]
        then
            echo "GSUBRC [`date \"+%T\"`]: Job $jnum is running."
            runmsg=1
            export runmsg
        fi
    fi

    #------------------------------------------------------
    # Did it finish?
    resultstr=`cat $tmpfile | grep -i "Finished"`
    if [ -n "$resultstr" ]
    then
        rc=`echo "$resultstr" | grep -o -P '(?<=:)[0-9]+$'`
        if [ -z "$rc" ]
        then
            echo "GSUBRC [`date \"+%T\"`]: JOB FINISHED. Assuming RC=0"
            rc=0
        else
            echo "GSUBRC [`date \"+%T\"`]: JOB FINISHED. RC=$rc"
        fi
    fi

    #------------------------------------------------------
    # Did it fail?
    resultstr=`cat $tmpfile | grep -i "Failed"`
    if [ -n "$resultstr" ]
    then
        rc=`echo "$resultstr" | grep -o -P '(?<=:)[0-9]+$'`
        if [ -z "$rc" ]
        then
            echo "GSUBRC [`date \"+%T\"`]: JOB FAILED. Assuming RC=999"
            rc=999
        else
            echo "GSUBRC [`date \"+%T\"`]: JOB FAILED. RC=$rc"
        fi
    fi

    #------------------------------------------------------
    # Did it fail some other way?
    resultstr=`cat $tmpfile | grep -i "directory"`
    if [ -n "$resultstr" ]
    then
        echo "GSUBRC [`date \"+%T\"`]: Cannot find job information to determine RC"
        rc=998
    fi

    export rc
}

#**************************************************************************
#   Parse the parameters
#**************************************************************************

#----------------------------------------------------------
# Initialize variables
help=0
rc=1
parms=$*
metapass=""
#added on 6 nov
echo "gsubwrapper file: " $1 >> jreviewsas_output.out
#----------------------------------------------------------
# Setup the debug file name
if [ "${USER}" = "" ]
then
  USER=`id | sed -e 's/.*(\(.*\)) gid=.*/\1/'`
  export USER
fi

tmpfile=/tmp/gsubrc.${USER}.$$.`date +%Y%m%d%H%M%S`.txt
#echo "tmpfile variable2: " $tmpfile >> jreviewsas_output.out

#----------------------------------------------------------
# If no arguments were passed in
if [ $# -eq 0 ]
then
    usage
    exit 999
fi

#----------------------------------------------------------
# If user wanted help
if [ "$1" == "-?" ]
then
    usage
    exit 999
fi

#----------------------------------------------------------
# Check to see if LSF has been sourced
if [ -z "$LSF_ENVDIR" ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: The LSF profile has not been sourced."
    exit 999
fi

if [ ! -d $LSF_ENVDIR ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: The LSF profile has not been sourced."
    exit 999
fi

#----------------------------------------------------------
# If the configuration directory is not valid, exit
if [ ! -d $sasconfigdir ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: SAS Configuration directory \"$sasconfigdir\" is not valid."
    exit 999
fi

#----------------------------------------------------------
# If the SASGSUB directory is not valid, exit
sasgsubdir="$sasconfigdir/Applications/SASGridManagerClientUtility"
#sasgsubdir="$sasconfigdir/Applications/SASGridManagerClientUtility/9.2"

if [ ! -d $sasgsubdir ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: SASGSUB directory \"$sasgsubdir\" is not valid."
    exit 999
fi

#----------------------------------------------------------
# Find out the version of SASGSUB we should use.
currentdir=`pwd -P`
#added on nov 6
echo "Current dir variable: " $currentdir >> jreviewsas_output.out
sasgsubdir="$sasgsubdir/9.?"
cd $sasgsubdir
sasgsubdir=`pwd -P`
cd $currentdir

#----------------------------------------------------------
# If the SASGSUB directory is not valid, exit
if [ ! -d $sasgsubdir ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: SASGSUB directory \"$sasgsubdir\" is not valid."
    exit 999
fi

#----------------------------------------------------------
# If the SAS program file does not exists, exit
if [ ! -e $1 ]
then
    echo "GSUBRC [`date \"+%T\"`]: ERROR: The SAS program file \"$1\" was not found."
    exit 999
fi

#----------------------------------------------------------
# Determine sas file name without the .SAS
filename=$1
filename=`echo $filename | sed -e 's/.SAS$//'`
filename=`echo $filename | sed -e 's/.sas$//'`

#----------------------------------------------------------
# See if one of the options is metapass. If so, save
# the value
#while [ ! -z "$1" ]
#do
#    if [ "$1" = "-metapass" ]
#    then
#        metapass="-metapass $2"
#    fi
#    shift
#done

#if [ -z "$metapass" ]
#then
#    echo "GSUBRC [`date \"+%T\"`]: METAPASS parameter not found. Assuming it is in SASGSUB.CFG."
#    echo "GSUBRC [`date \"+%T\"`]: If METAPASS is not defined in SASGSUB.CFG, GSUBRC will fail."
#fi

#----------------------------------------------------------
# Let the user know the names of the temp files
if [ "$debug" -eq "1" ]
then
    echo "GSUBRC [`date \"+%T\"`]: Using tmpfile $tmpfile"
fi

#****************************************************************************
# Submit program
#****************************************************************************
echo "GSUBRC [`date \"+%T\"`]: Submitting job..."
$sasgsubdir/sasgsub -gridsubmitpgm $parms >$tmpfile -GRIDAPPSERVER SASApp94

if [ "$debug" -eq "1" ]
then
    cat $tmpfile
fi

#----------------------------------------------------------
# Determine job number from sasgsub output
jnum=`cat $tmpfile | grep -o -P "(?<=<)[0-9]+(?=>)"`
if [ -z "$jnum" ]
then
    echo ""
    echo "GSUBRC [`date \"+%T\"`]: ERROR: SASGSUB did not return a job number. SASGSUB output is"
    cat $tmpfile
    rm -f $tmpfile
    exit 1
fi

echo "GSUBRC [`date \"+%T\"`]: Job $jnum is submitted."

#****************************************************************************
# Loop waiting for the job to finish
#****************************************************************************

#----------------------------------------------------------
# Make sure the wait time is not less than 5 seconds
if [ $waittime -lt 5 ]
then
    echo "GSUBRC [`date \"+%T\"`]: The wait time cannot be less than 5 seconds. Setting it to 5 seconds."
    waittime=5
fi

continueLooping=1
runmsg=0
while [ $continueLooping -gt 0 ]
do
    #------------------------------------------------------
    # Grab the results
    checkStatus

    #------------------------------------------------------
    # If a status was found, stop the loop otherwise wait
    # a bit and try again
    if [ $rc -ge 0 ]
    then
        continueLooping=0
    else
        sleep $waittime
    fi
done

#****************************************************************************
# Copy result files from subdir to currentdir
#****************************************************************************

# This should be the most recently modified file
moddir=`ls -t | head -1`
#added on 6 Nov
echo "moddir variable : " $moddir >> jreviewsas_output.out
echo "filename variable: " $filename >> jreviewsas_output.out
if [ -d "$moddir" ]
then
    cd $moddir
#    if [ -e $filename.log ]
#    then
        cp -f *.log $filename.log
#    fi
#    if [ -e $filename.lst ]
#    then
        cp -f *.lst $filename.lst
#    fi
    cd ..
else
    echo "GSUBRC [`date \"+%T\"`]: Could not copy log files: Could not find SASGSUB output directory."
fi

#****************************************************************************
# Clean up
#****************************************************************************

if [ "$debug" -ne "1" ]
then
    if [ -e $tmpfile ]
    then
cp $tmpfile ./temp_file.txt
        newVar=`cat $tmpfile| awk -F "/" '{print $2}' | awk -F "\"" '{print $1}'`
	echo "new variable: " $newVar >>jreviewsas_output.out
        rm -f $tmpfile
    fi
fi

exit $rc

# ****************************************************************************
# End of script
# ****************************************************************************
