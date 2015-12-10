#!/bin/bash

#########write by wanghuimin 10/25/2014
prj=$1
workspace_porting=$2
workspace=/home/hudsonworkspace/$prj
pakage_name=$3
#workspace_porting=/home/ott-admin/hudson/jobs/$prj_porting/lastSuccessful/archive/output


pakage_info= /home/hudsonworkspace/$prj/log_version.txt

echo "`date "+%Y%m%d%H%M%S"` Begin copy amlogic_porting compiled package"  > $workspace/package/log_version_porting.txt
#cd $workspace_porting/output/
cd $workspace_porting
pakage_version=`ls $pakage_name*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not porting new package \n" >> $workspace/package/log_version_porting.txt
else 
echo "copy porting amlogic pakage,amlogic version: $pakage_version \n" >> $workspace/package/log_version_porting.txt
cd $workspace/platform/
rm -f $pakage_name*.tar.gz
cp -f $workspace_porting/$pakage_name*.tar.gz    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_porting.txt  || echo "copy $pakage_version error"  >> $workspace/package/log_version_porting.txt

cp -f $workspace_porting/$pakage_name*.tar.gz    $workspace/package/ 

fi

echo -e "" >> $workspace/package/log_version_porting.txt








