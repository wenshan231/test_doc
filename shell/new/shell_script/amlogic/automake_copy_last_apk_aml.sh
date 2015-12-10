#!/bin/bash
#########write by qiaoting 3/27/2014
apk_list=$1
#apk_list="FlyUI_Account_git FlyUI_BootWizard_git FlyUI_HomePlayer2_git FlyUI_IME2.0_git FlyUI_NetCheck_git FlyUI_Portal2.0_git FlyUI_Setting2.0_git FlyUI_VOD_git FlyUI_Wallpaper_git FlyUI_WebApp_git FlyUIWidget_TimeDate_git FlyUIWidget_Weather_git FlyUI_Agent FlyUI_Search_git NetFirmware2_AndroidX_git FlyUI_ScreenSaver_git"
workspace=$2
#workspace=/home/hudson/amlogics802_product_demo_autocopy_amlogics802_develop_4.4_and_apk_and_porting_and_csmsi
#apk_dist_dir=$3
apk_dist_dir=$workspace/autobuildApk
apk_from_dir=/home/ott-admin/hudson/share_5.161_win

#######begin copy
#cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy $apk_list"  > $workspace/package/log_version_apk.txt

cd $apk_dist_dir

for apk_mdl in $apk_list
do
	i=$(($i+1))
	cd $apk_from_dir/$apk_mdl/builds
	last_dir=`ls -ct | head -1`
	cd $apk_from_dir/$apk_mdl/builds/$last_dir
	if [ -f archive/output/*.zip ]
	then 
		echo "copy $i  $apk_mdl begin " >> $workspace/package/log_version_apk.txt

		cd $apk_dist_dir
		rm -fr tmp && mkdir tmp
		chmod -R 777 tmp
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/*.zip		   tmp/
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/*.zip		   $workspace/package/
		cd tmp
		echo "all apk version:">>$workspace/apk_csmsi_version.txt
		ls -l  >>$workspace/apk_csmsi_version.txt
		unzip *.zip && echo "tar $apk_mdl*.zip  ok"  >> $workspace/package/log_version_apk.txt  || echo "tar $apk_mdl*.zip error"  >> $workspace/package/log_version_apk.txt 
		cp -f *_amlogic.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/package/log_version_apk.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/package/log_version_apk.txt
	else 
	 	if [ -f archive/src/trunk/output/*.zip ]
		then 
			echo "copy $i  $apk_mdl begin " >> $workspace/package/log_version_apk.txt
	
			cd $apk_dist_dir
			rm -fr tmp && mkdir tmp
			chmod -R 777 tmp
			cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/src/trunk/output/*.zip		   tmp/
			cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/src/trunk/output/*.zip		   $workspace/package/
			cd tmp
			unzip *.zip && echo "tar $apk_mdl*.zip  ok"  >> $workspace/package/log_version_apk.txt  || echo "tar $apk_mdl*.zip error"  >> $workspace/package/log_version_apk.txt 
			cp -f *_amlogic.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/package/log_version_apk.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/package/log_version_apk.txt
		else 
	 		echo  "not exit $i $apk_mdl new package " >> $workspace/package/log_version_apk.txt 
		fi
	fi
	echo -e "" >> $workspace/package/log_version_apk.txt
done









chmod -R 777   $apk_dist_dir/ 
cd  $apk_dist_dir/  && ls -l  *  >> $workspace/package/log_version_apk.txt





