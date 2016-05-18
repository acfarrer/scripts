#! /bin/ksh
### Start SAS94/Connect spawner. May need to run as root or need pam.d
# Alternative to signon 'SASApp94 - Connect Server' - not enabled at Lilly
nohup /sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/utilities/bin/cntspawn -service 5002 -nocleartext -sascmd /home/c226507/scripts/dmr_startup.ksh &
# Above probably needs to run as root. Running this SAS code and entering credentials
# %let tcpsec = _prompt_ ;
# %let grdtmgr = gridtmgr01 5002 ;
# options comamid=tcp connectremote = grdtmgr ;
# signon grdtmgr ;
# Gives this stderr:
# WARN: Client connection 0x7f3143d2bf60's user "c226507" from IX1GRIDPDM01.am.lilly.com (::ffff:40.1.244.27) failed authentication.
# ERROR: Unable to authenticate user.
# Client connection 0x7f3143d2bf60 terminating.
