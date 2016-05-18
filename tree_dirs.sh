#! /bin/sh
### Create tree listing of directory structure to file
# Todo: Add option to take parameter
tree -d -L 5 /sasfs/prod/sas/94 -T "Dirs below /sasfs/prod/sas/94" -o ~/refdata/dir_tree_L5_sas94.lst
#tree -d -L 5 /sasfs/prod/sas/94 -T "Dirs below /sasfs/prod/sas/94" -o ~/html/tree_dirs_L5.html -H "http:\\gridtmgr01\~c226507\html"
# Idea came from From http://www.gorgnegre.com/linux/tree-command-as-a-sitemap-generator.html
