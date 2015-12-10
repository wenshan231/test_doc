#!/bin/bash
#########write by qiaoting 4/23/2013
#copy from 6a801
prj=$1
workspace_6a801=$2
workspace_6a801_dvb=$3
workspace=/home/hudson/$prj


#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
pakage_info= /home/hudson/$prj/log_version.txt
apk_dist_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app
cd $workspace && rm -fr package
cd $workspace && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt
cd $workspace_6a801/output/
pakage_version=`ls stp_package_mstar6a801_*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not 6a801 new package \n" >> $workspace/log_version.txt
else 
echo "copy platform 6a801 pakage,6a801 version: $pakage_version \n" >> $workspace/log_version.txt 
cd $workspace/platform/
rm -f stp_package_mstar6a801.tar.gz
cp -f $workspace_6a801/output/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt

cp -f $workspace_6a801/output/$pakage_version    $workspace/package/ 
mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt

fi

echo -e "" >> $workspace/log_version.txt  


############aucopy 6a801_dvb
#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
cd $workspace_6a801_dvb/
pakage_version=`ls *stp_package_mstar6a801_*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not 6a801 dvb  new package \n" >> $workspace/log_version.txt
else
echo "copy platform 6a801 pakage dvb,6a801 version: $pakage_version \n" >> $workspace/log_version.txt
cd $workspace/platform_dvb/
rm -f stp_package_mstar6a801.tar.gz
cp -f $workspace_6a801_dvb/$pakage_version    $workspace/platform_dvb/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt

cp -f $workspace_6a801_dvb/$pakage_version    $workspace/package/
mv $workspace/platform_dvb/$pakage_version  $workspace/platform_dvb/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt

fi

echo -e "" >> $workspace/log_version.txt




#copy from appstore

#apk_appstore=com.coship.tvappstore_mstar
#apk_appstore_output=/home/qiaoting/SRC/AppStore/client/CLIENT_CLASSIC/trunk/output
#cd $apk_appstore_output
#pwd
#pakage_version=`ls *.zip`
#echo $pakage_version
#if [ "$pakage_version" == "" ]
#	then
#		echo "$i not $apk_appstore new package " >> $workspace/log_version.txt
#	else 
#		echo "$i copy $apk_appstore begin " >> $workspace/log_version.txt 
#		cd $apk_dist_dir
#		rm -fr tmp && mkdir tmp
#		cp -f $apk_appstore_output/$pakage_version		   tmp/
#		cp -f $apk_appstore_output/$pakage_version		   $workspace/package/
#		cd tmp
#		chmod -R  777 tmp
#		unzip $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar $pakage_version error"  >> $workspace/log_version.txt 
#		cp -f $apk_appstore\.apk  $apk_dist_dir/$apk_appstore.apk  && echo  "copy $apk_appstore.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_appstore.apk error" >> $workspace/log_version.txt
#	
#	fi
#	echo -e "" >> $workspace/log_version.txt 
#
#
##copy from apk 
#apk_list="FlyUI_Portal FlyUI_VOD FlyUI_HomePlayer FlyUI_BootWizard FlyUI_Live FlyUI_Setting FlyUI_ScreenSaver "
#src_path=/home/qiaoting/SRC
#cd $apk_dist_dir
#
#for apk_mdl in $apk_list
#do
#	i=$(($i+1))
#	cd $src_path/$apk_mdl/output
#	pwd
#	pakage_version=`ls *.zip`
#	echo $pakage_version
#	if [ "$pakage_version" == "" ]
#	then
#		echo "$i not $apk_mdl new package " >> $workspace/log_version.txt
#	else 
#		echo "$i copy $pakage_version begin " >> $workspace/log_version.txt 
#		cd $apk_dist_dir
#		rm -fr tmp && mkdir tmp
#		chmod -R 777 tmp
#		cp -f $src_path/$apk_mdl/output/$pakage_version		   tmp/
#		cp -f $src_path/$apk_mdl/output/$pakage_version		 $workspace/package/
#		cd tmp
#		unzip $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar $pakage_version error"  >> $workspace/log_version.txt 
#		cp -f *.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/log_version.txt
#		
#	fi
#	echo -e "" >> $workspace/log_version.txt 
#done



#copy from apk 
#apk_list="com.coship.app.vaf com.coship.ChangeTheAudioOutput  com.coship.netfirmware com.coship.NetworkNavigation  com.coship.TestApp com.coship.trafficmonitor BluetoothHeadsetICS com.coship.netfirmware "
#src_path=/home/hudson/apps

#for apk_mdl in $apk_list
#do
#	i=$(($i+1))
#	cd $src_path/$apk_mdl/output
#	pwd
#	pakage_version=`ls *.tar.gz`
#	echo $pakage_version
#	if [ "$pakage_version" == "" ]
#	then
#		echo "$i not $apk_mdl new package " >> $workspace/log_version.txt
#	else 
#		echo "$i copy $pakage_version begin " >> $workspace/log_version.txt 
#		cd $apk_dist_dir
#		rm -fr tmp && mkdir tmp
#		cp -f $src_path/$apk_mdl/output/$pakage_version		   tmp/
#		cp -f $src_path/$apk_mdl/output/$pakage_version		   $workspace/package/
#		cd tmp
#		tar -zxvf $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar $pakage_version error"  >> $workspace/log_version.txt 
#		cp -f $apk_mdl\.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/log_version.txt
#		
#	fi
#	echo -e "" >> $workspace/log_version.txt
#	 
#done
chmod -R 777   $apk_dist_dir/ 






