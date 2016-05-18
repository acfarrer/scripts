#! /bin/sh
### Blend of Andrew and David Glemaker's standard diagnostic tests
##   /shared/sas/gsub/gsubmix.sh
GSUB='/sasfs/prod/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub'
PROG_FOLDER=$HOME/sascode

OPT="-GRIDJOBOPTS 'queue=normal'"

for i in `seq 13 17`;
do
   $GSUB -gridsubmitpgm  $PROG_FOLDER/sleep5.sas -GRIDJOBNAME EGnonactNorm_$i  $OPT
done

OPT="-GRIDJOBOPTS 'queue=normal'"

for i in `seq 1 5`;
do
   $GSUB -gridsubmitpgm  $PROG_FOLDER/2GB_memory_test.sas -GRIDJOBNAME NormIOMem_$i  $OPT -gridsasopts "'-memsize 8G -sortsize 2G'"
done


OPT="-GRIDJOBOPTS 'queue=priority'"

for i in `seq 6 10`;
do
   $GSUB -gridsubmitpgm  $PROG_FOLDER/cpuload.sas -GRIDJOBNAME EGactivePri_$i  $OPT
done

OPT="-GRIDJOBOPTS 'queue=normal'"

for i in `seq 11 12`;
do
   $GSUB -gridsubmitpgm  $PROG_FOLDER/sleep1.sas -GRIDJOBNAME Night_$i  $OPT
done

bjobs
bhosts
bqueues
bqueues normal priority 
echo ------------------------------------------------
echo We have submitted the sleep5 program 5 times to the normal queue.
echo Then, we submit it another 5 times to cpuload, but to the priority queue.
echo and 2 sleep1 jobs to the night queue.
echo run bqueues and bqueues normal priority night


