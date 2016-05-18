#! /bin/sh
### Strip SAS comments from file. Regex does not work in grep
sed '//*,/*/d' $1
# Could also strip blanks lines
sed '//*,/*/d' $1 | grep -v ^$
 
