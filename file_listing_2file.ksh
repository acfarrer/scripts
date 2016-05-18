#!/bin/ksh
### Create file listings from all locations with user files
##  Run as root but make output readable
##  Filter only files whose status has not changed for 3 days
target=/export/home/vgabbur/tempdata
while read DIR; do
  find /$DIR -type f -ctime +3 -ls > $target/files_$DIR.lst 
# Test available space on target after each loop
# avail=$(df -k $target | tail -1 | cut -c52-53)  # No good for single digits. Use awk below instead
# Available percent. Grab 5th value of 2nd row and strip off last char to leave numeric
avail=$(df -h $target |awk 'NR==2{print substr($5,1,length($5)-1)}')
threshold=72
if [[ $threshold -le $avail ]] ; then
   echo  "less than $threshold free"
   exit 9
fi
done << EOF
data
tmp
util
work
EOF
# Wait for all
wait
# Make output readable
chmod 644 $target/files_*.lst
