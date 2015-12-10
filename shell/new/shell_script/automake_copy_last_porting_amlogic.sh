#!/bin/bash
#########write by maxiuhong 3/27/2014
#copy from amlogic
prj=$1
prj_porting=$2
workspace=/home/hudson/$prj
workspace_porting=/home/ott-admin/hudson/jobs/$prj_porting/lastSuccessful/archive/output


pakage_info= /home/hudson/$prj/log_version.txt
apk_dist_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app

cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt
#cd $workspace_porting/output/
cd $workspace_porting
pakage_version=`ls libporting*.so`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not porting new package \n" >> $workspace/log_version.txt
else 
echo "copy porting amlogic pakage,amlogic version: $pakage_version \n" >> $workspace/log_version.txt 
cd $workspace/platform/
rm -f libporting.so libporting_client.so
cp -f $workspace_porting/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt

cp -f $workspace_porting/$pakage_version    $workspace/package/ 
#mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt

fi

echo -e "" >> $workspace/log_version.txt  








