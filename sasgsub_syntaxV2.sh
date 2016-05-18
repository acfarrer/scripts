#! /bin/sh
### Copied from submitsasjob.sh on CLUWE web server
programName=~/sascode/proc_template_ods_path_sgrender.sas
gridContext=SASApp94L

sasgsubCommand="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub"
#submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDCONFIG /home/c226507/sasgsub.cfg"
#submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"(-autoexec /home/c226507/sasgsub_autoexec.sas)\" "
submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" 

echo $sasgsubCommand $submitOptions -GRIDSASOPTS \"(-autoexec /home/c226507/sasgsub_autoexec.sas)\"
$sasgsubCommand $submitOptions -GRIDSASOPTS \"(-autoexec /home/c226507/sasgsub_autoexec.sas)\"


