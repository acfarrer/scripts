#! /bin/sh
### Old method to send files to SAS TS
# From http://support.sas.com/kb/20/941.html
ftp ftp.sas.com
anonymous
cd /techsup/upload
bin
put $1
bye
