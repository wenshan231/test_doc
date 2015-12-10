#!/bin/bash
#########write by qiaoting 4/15/2013
prj=6a801
workspace=/home/hudson/6a801
cd $workspace
sh build_mstaramber3box.sh


######### get svn version and 
cd $workspace
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
filename_int=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`_int
echo $filename
######### build file.tar.gz
tar -cvf $workspace/output/$filename.tar.gz *








