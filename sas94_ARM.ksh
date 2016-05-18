#! /bin/ksh
### Add ARM logging to SAS job
# Originally from Tom.Kari.Consulting@bell.net 27Feb2014 */
# Modified for Eli Lilly. Andrew Farrer. 17Feb2016 */
# logconfig is unknown option
#/sas94apps/qat94software/SASFoundation/9.4/sas -sysin $1 -armsubsys=arm_dsio -logconfig /home/afarrer/ARM/ArmConfig.xml 
# From http://support.sas.com/kb/35/165.html and SAS track 7611297157
arm_datetime=$(date +%d_%m_%Y_%T)
# From Bell
# /sas94apps/qat94software/SASFoundation/9.4/sas -sysin $1 -ARMSUBSYS=(ARM_DSIO VARINFO WHERETXT) -armloc $HOME/sas94_ARM_${arm_datetime}.log" 
#/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -sysin $1 -ARMSUBSYS=(ARM_DSIO VARINFO WHERETXT) -armloc ~/saslogs/sas94_ARM_${arm_datetime}.log" -work ~/saswork/
/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -armsubsys=[arm_all] -armloc=~/saslogs/sas94_ARM_${arm_datetime}.log -log ~/saslogs -print ~/sasprint -work ~/saswork -sysin $1

