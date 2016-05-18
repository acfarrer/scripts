#! /bin/sh
### Strip XML comments from file. May also work for some HTML
sed '/<!--/,/-->/d' $1
# Could also strip blanks lines
# sed '/<!--/,/-->/d' $1 | grep -v ^$
 
