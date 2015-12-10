#!/bin/bash
#########write by qiaoting 4/23/2013
#copy from amlogic
prj=$1
workspace_amlogic=$2
workspace=/home/hudsonworkspace/$prj
pakage_name=$3
#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
#workspace_6a801=/home/ott-admin/share_96.200/$prj_6a801/lastSuccessful/archive
#workspace_amlogic=/home/ott-admin/hudson/jobs/$prj_amlogic/lastSuccessful/archive/autobuild


pakage_info=/home/hudsonworkspace/$prj/package/log_version_platform.txt
apk_dist_dir=/home/hudsonworkspace/$prj/stp_integration/6a801.demo/stp_custom/system/app
# cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy amlogic platform "  > $workspace/package/log_version_platform.txt
cd $workspace_amlogic/
pakage_version=`ls $pakage_name*`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not amlogic new package \n" >> $workspace/package/log_version_platform.txt
else 
echo "copy platform amlogic pakage,amlogic version: $pakage_version \n" >> $workspace/package/log_version_platform.txt 
cd $workspace/platform/
rm -f $pakage_name*.tar.gz
cp -f $workspace_amlogic/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_platform.txt  || echo "copy $pakage_version error"  >> $workspace/package/log_version_platform.txt

cp -f $workspace_amlogic/$pakage_version    $workspace/package/ 
#mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/package/log_version_platform.txt  || echo "mv $pakage_version error"  >> $workspace/package/log_version_platform.txt

fi

echo -e "" >> $workspace/package/log_version_platform.txt  








