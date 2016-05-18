#! /bin/bash
### bash version of submitsasjob.sh on CLUWE web server
programName=dummy.sas
gridContext=SASApp94L

sasgsubCommand="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub"
submitOptions="-GRIDSUBMITPGM \"$programName\" -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"(-initstmt 'ods path (prepend) work.template (update)')\" "
#submitOptions="-GRIDSUBMITPGM \"$programName\" -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS '{-initstmt "ods path{prepend} work.template {update}"}' "

$sasgsubCommand $submitOptions
