#!/bin/bash
#########write by maxiuhong 4/14/2014
#copy from hisi
prj=$1
workspace_hisi=$2
workspace=/home/hudson/$prj
#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
#workspace_6a801=/home/ott-admin/share_96.200/$prj_6a801/lastSuccessful/archive
#workspace_amlogic=/home/ott-admin/hudson/jobs/$prj_amlogic/lastSuccessful/archive/autobuild


pakage_info=/home/hudson/$prj/package/log_version_platform.txt
cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy hisi platform "  > $workspace/package/log_version_platform.txt
cd $workspace_hisi/
pakage_version=`ls hisi3716CV200_android_git*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not hisi new package \n" >> $workspace/package/log_version_platform.txt
else 
echo "copy platform hisi pakage,hisi version: $pakage_version \n" >> $workspace/package/log_version_platform.txt 
cd $workspace/platform/ && rm -f hisi3716CV200_android_git*.tar.gz
cp -f $workspace_hisi/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_platform.txt  && mv hisi3716CV200_android_git*.tar.gz stp_package_hisi3716cv200.tar.gz  || echo "copy $pakage_version error"  >> $workspace/package/log_version_platform.txt

cp -f $workspace_hisi/$pakage_version    $workspace/package/ 
#mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/package/log_version_platform.txt  || echo "mv $pakage_version error"  >> $workspace/package/log_version_platform.txt

fi

echo -e "" >> $workspace/package/log_version_platform.txt  








