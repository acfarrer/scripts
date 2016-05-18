#! /bin/sh
### Copied from submitsasjob.sh on CLUWE web server
programName=~/sascode/proc_template_ods_path_sgrender.sas
gridContext=SASApp94L

sasgsubCommand="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub"
#submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"\(-initstmt 'ods path \(prepend\) work.template \(update\)'\)\" "
submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"(-initstmt 'ods path (prepend) work.template (update)')\" "
#submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDCONFIG ~/sasv9.cfg"
#submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"(-autoexec ~/autoexec.sas)\" "

#echo $programName
echo $sasgsubCommand $submitOptions > sasgsub_$$.cmd

#$sasgsubCommand $submitOptions # Original syntax
/bin/sh sasgsub_$$.cmd

