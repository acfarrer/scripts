#! /bin/ksh
### Print first 5 observations of filename passed as parm in the SAS library at current location.
if [ $# -eq 0 ]
then
  print "$0: Usage is sasprint5.ksh SAS filename - with or without .sas7bdat" 1>&2
  exit 255
fi
SASEXE=/sasfs/prod/sas/94/controlserver/sashome/SASFoundation/9.4/sas

$SASEXE -work ~/saswork -obs 5 -ps 1000 -ls 124 -sysparm ${1%.sas7bdat} -nodate -nonumber -nonotes -nonews -nocenter -nocpuid -noautoexec -nodms -initstmt "libname here '.' ; proc sql ; title 'First 5 observations' ; select * from here.&sysparm ; quit ; endsas ; "
