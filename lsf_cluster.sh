#! /bin/sh
# From LSF 8.0 Quick Ref 5
# Viewing information about your cluster
# Test using c226507@gridpmgr01 . Andrew Farrer 12Feb2016 

#source /sasfs/prod/platformcomputing/lsf/conf/profile.lsf

echo bhosts - Displays hosts and their static and dynamic resources
bhosts
echo -----------
echo blimits - Displays information about resource allocation limits of running jobs
blimits
echo -----------
echo bparams - Displays information about tunable batch system parameters
bparams -l
echo -----------
echo bqueues - Displays information about batch queues
bqueues
echo -----------
echo busers - Displays information about users and user groups
busers -w all
echo -----------
echo lshosts - Displays hosts and their static resource information
lshosts
echo -----------
echo lsid - Displays the current LSF version number, cluster name and master host name
lsid
echo -----------
echo lsinfo - Displays load sharing configuration information
lsinfo -m
echo -----------
echo lsload - Displays dynamic load indices for hosts
lsload

