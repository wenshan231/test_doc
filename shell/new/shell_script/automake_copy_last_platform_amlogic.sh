#!/bin/bash
#########write by qiaoting 4/23/2013
#copy from 6a801
prj=$1
prj_6a801=$2
workspace=/home/hudson/$prj
#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
#workspace_6a801=/home/ott-admin/share_96.200/$prj_6a801/lastSuccessful/archive
workspace_6a801=/home/ott-admin/hudson/jobs/$prj_6a801/lastSuccessful/archive/autobuild


pakage_info= /home/hudson/$prj/log_version.txt
apk_dist_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app
cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt
cd $workspace_6a801/output/
pakage_version=`ls stp_package_amlogics802*`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not 6a801 new package \n" >> $workspace/log_version.txt
else 
echo "copy platform 6a801 pakage,6a801 version: $pakage_version \n" >> $workspace/log_version.txt 
cd $workspace/platform/
rm -f stp_package_amlogics802*.tar.gz
cp -f $workspace_6a801/output/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt

cp -f $workspace_6a801/output/$pakage_version    $workspace/package/ 
#mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt

fi

echo -e "" >> $workspace/log_version.txt  








