#!/bin/bash
#########write by qiaoting 4/23/2013
prj=$1
workspace=/home/hudson/$prj
#pakage_info= /home/hudson/$prj/log_version.txt
apk_dist_dir=/home/hudson/$prj/autobuildApk
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt


#copy from apk 
cd $apk_dist_dir


apk_list="FlyUI_Portal2.0_liaoning NetFirmware2_AndroidX_git  FlyUI_Setting2.0_AndroidX_git FlyUI_AppStore2.0 FlyUI_BootWizard_AndroidX_git FlyUI_ScreenSaver_git FlyUI_VOD_git FlyUI_Search_git FlyUI_Agent OTTDVB_Live_Trial_Version_git FlyUI_Account_git FlyUI_Clean_git FlyUI_HomePlayer2_git FlyUI_IME2.0_git FlyUI_NetCheck_git FlyUI_Wallpaper_git FlyUI_WebApp_git FlyUIWidget_TimeDate_git FlyUIWidget_Weather_git"
src_path=/home/qiaoting/SRC
cd $apk_dist_dir

for apk_mdl in $apk_list
do
	i=$(($i+1))
	cd $src_path/$apk_mdl/output
	pwd
	pakage_version=`ls *.zip`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "$i not $apk_mdl new package " >> $workspace/log_version.txt
	else 
		echo "$i copy $pakage_version begin " >> $workspace/log_version.txt 
		cd $apk_dist_dir
		rm -fr tmp && mkdir tmp
		chmod -R 777 tmp
		cp -f $src_path/$apk_mdl/output/$pakage_version		   tmp/
		cp -f $src_path/$apk_mdl/output/$pakage_version		 $workspace/package/
		cd tmp
		unzip $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar $pakage_version error"  >> $workspace/log_version.txt 
		cp -f *_amlogic.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/log_version.txt
		
	fi
	echo -e "" >> $workspace/log_version.txt 
done


chmod -R 777   $apk_dist_dir/ 






