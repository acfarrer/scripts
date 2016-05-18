#! /bin/sh
### Count the frequency of words in a file
# From http://stackoverflow.com/questions/15598935/awk-words-frequency-from-one-text-file-how-to-ouput-into-myfile-txt
# Take file name of text as parameter
srcdir=$1
textfname=$2
trgtdir=~/wordcounts
 awk '{a[$1]++}END{for(k in a)print $1,a[k],k}' RS=" |\n" $srcdir/$textfname | sort -h > $trgtdir/$textfname.wc

