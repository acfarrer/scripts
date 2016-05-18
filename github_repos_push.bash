#! /bin/bash
### Template to populate github repository
reposname=scripts
echo "# $HOSTNAME $PWD" >> README.md
git init
git add README.md
git commit -m "First commit"
git remote set-url origin git@github.com:acfarrer/$reposname..git
git push -u origin master
