#! /bin/sh
### List all the members' details in the SAS library at current location.
# Try -nonotes sometime.
# Note \ used to escape special meaning of $ in format
SASEXE=/sasfs/prod/sas/94/controlserver/sashome/SASFoundation/9.4/sas

$SASEXE -work ~/saswork -ps 1000 -ls 132 -nodate -nonumber -nonotes -nonews -nocenter -nocpuid -noautoexec -nodms -initstmt "libname here '.' ; proc sql ; title 'Datasets in this library' ; select memname format=\$25. , nobs format=comma13. , nvar , datepart(modate) format = date9. as mod_date, memlabel format=\$55. from
 dictionary.tables where libname = 'HERE' and memtype = 'DATA' ; quit ; endsas ; "
