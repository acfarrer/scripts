#! /bin/sh
programName=~/sascode/proc_template_ods_path_sgrender.sas
gridContext=SASApp94L

### POC to test sasgsub with -GRIDSASOPTS "(-initstmt )"
# Copied from submitsasjob.sh supplied by David Fleig. 
# Added ods path (prepend) work.template (update) to allow web interface to use LUM and BUM macros without proc template overwrite issues
# Working version after many attempts. ACF 11May2016

sasgsubCommand="/sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub"
submitOptions=" -GRIDSUBMITPGM $programName -GRIDAPPSERVER \"$gridContext\" -GRIDSASOPTS \"(-initstmt 'ods path (prepend) work.templat (update)')\" "

# The only way that quoted strings resolve to something accepted by the sasgsub tokeniser
echo $sasgsubCommand $submitOptions > sasgsub_$$.cmd

#$sasgsubCommand $submitOptions # Original syntax
/bin/sh sasgsub_$$.cmd
