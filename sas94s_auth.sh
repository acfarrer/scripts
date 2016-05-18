#! /bin/sh
### Start sas94 with auth modules added as per http://support.sas.com/kb/39/891.html

FNDTN94=/sasfs/sandbox/sas/94/controlserver/sashome/SASFoundation/9.4
$FNDTN94/sas -path $FNDTN94/utilities/src/auth -work /tmp/ -sasuser /tmp -nodms -initstmt = 'proc permtest ; run ;'
