#! /bin/sh
### Strip extension from filename. Write PID to similar filename
echo $(basename $0 .sh) 
echo $$ > $(basename $0 .sh).pid
