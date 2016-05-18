#! /bin/ksh
### Encode a Unix password to pass into a hardcoded SAS9 metadata connection
/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -nodate -nonumber -nonotes -nonews -nocenter -nocpuid -noautoexec -nodms -sysparm "$1" -initstmt 'proc pwencode in = "&sysparm" ; run ; endsas ;'

