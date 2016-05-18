#! /bin/sh
### Template for housekeeping SAS MidTier logs
find /sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebServer/logs/ -name "access*" -mtime -3 >> /tmp/dc4co2_Lev1_SAS7611612097.lst
find /sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebServer/logs/ -name "error*" -mtime -3 >> /tmp/dc4co2_Lev1_SAS7611612097.lst
find /sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebServer/logs/ -name "ssl_request*" -mtime -3 >> /tmp/dc4co2_Lev1_SAS7611612097.lst
find /sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebAppServer/SASServer1_1/logs/ -name "localhost_access_log.2015-*" -mtime -3 >> /tmp/dc4co2_Lev1_SAS7611612097.lst
echo '/sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebAppServer/SASServer1_1/logs/server.log' >> /tmp/dc4co2_Lev1_SAS7611612097.lst
echo '/sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/Logs/SASServer1_1/SASDecMgrShell2.2.log' >> /tmp/dc4co2_Lev1_SAS7611612097.lst

/sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/WebAppServer/SASServer1_1/conf/startup.prerequisites

find /sasfs/test/sas/94/webtier/sasconfig/Lev1/Web/Logs/SASServer1_1/ -type f -name "SAS*.log" -mtime 0 -exec grep -H ^$(date '+%Y-%m-%d') {} \;
