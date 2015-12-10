#!/bin/bash
#########write by qiaoting 3/27/2014
#apk_list=$1
apk_list="FlyUI_Account_git FlyUI_BootWizard_git"
#workspace=$2
workspace=/home/hudson/amlogics802_product_demo_autocopy_amlogics802_develop_4.4_and_apk_and_porting_and_csmsi
#apk_dist_dir=$3
apk_dist_dir=$workspace/autobuildApk
apk_from_dir=/home/ott-admin/hudson/share_5.161_win

#######begin copy
cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy $apk_list"  > $workspace/package/log_version.txt

cd $apk_dist_dir

for apk_mdl in $apk_list
do
	i=$(($i+1))
	cd $apk_from_dir/$apk_mdl/builds
	last_dir=`ls -ct | head -1`
	cd $apk_from_dir/$apk_mdl/builds/$last_dir
	if [ -f archive/output/$apk_mdl*.zip ]
	then 
		echo "copy $i  $apk_mdl begin " >> $workspace/copy_all_list/log_version.txt 
		cd $apk_dist_dir
		rm -fr tmp && mkdir tmp
		chmod -R 777 tmp
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/$apk_mdl*.zip		   tmp/
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/$apk_mdl*.zip		   $workspace/package/
		cd tmp
		unzip $apk_mdl*.zip && echo "tar $apk_mdl*.zip  ok"  >> $workspace/package/log_version.txt  || echo "tar $apk_mdl*.zip error"  >> $workspace/package/log_version.txt 
		cp -f *_amlogic.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/package/log_version.txt
	else  "not exit $i $apk_mdl new package " >> $workspace/package/log_version.txt 
	fi
	echo -e "" >> $workspace/log_version.txt 
done


chmod -R 777   $apk_dist_dir/ 






