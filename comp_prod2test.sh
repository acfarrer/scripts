#! /bin/sh
### Compare file between prod and test.
# Andrew Farrer. 16Mar2016
if [ $# -eq 0 ]
then
 print "$0: filename is expected " 1>&2
  exit 255
fi
if [ ! -f "$1" ]
then
  print "Error: $1 does not exist"
  exit 15
fi

diff -b $1 $(echo $PWD | sed -e 's/prod/test/')/$1
