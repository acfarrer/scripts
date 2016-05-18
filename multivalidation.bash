#! /bin/bash
### Submit SAS code to test SAS services
CWD=$PWD
cd ~/sascode
~/scripts/sas94batch.ksh libname_spds_localhost_5404.sas
~/scripts/sas94batch.ksh proc_metaoperate_status.sas
~/scripts/sas94batch.ksh proc_stp_run_sample.sas
~/scripts/sas94batch.ksh proc_iomoperate.sas
# ~/scripts/sas94batch.ksh 2GB_memory_test.sas # Need to run on compute node
# LSF specific 
busers -all
bjobs -d  # Recent jobs for $USER
bparams -a -l
bhist -t -T .-1,  # All jobs in last 24 hours
lsload
lsinfo

cd $CWD
