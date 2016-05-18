#! /bin/bash
### Print first 5 observations of filename passed as parm in the SAS library at current location. Not working

#if [ ! -e $1 ]
#then
#  echo "GSUBRC [`date \"+%T\"`]: ERROR: The SAS program file \"$1\" was not found."
#  exit 999
#fi

SASEXE=/sasfs/prod/sas/94/controlserver/sashome/SASFoundation/9.4/sas

$SASEXE -work ~/saswork -obs 5 -ps 1000 -ls 124 -nodate -nonumber -nonotes -nonews -nocenter -nocpuid -noautoexec -nodms -initstmt "proc sql ; title 'First 5 observations' ; select * from \"$1\" ; quit ; endsas ; "
