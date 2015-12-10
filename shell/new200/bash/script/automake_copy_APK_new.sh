#!/bin/bash
#########write by qiaoting 4/23/2013
#copy from 6a801
prj=S1001_CIBN_real-time
workspace=/home/hudson/$prj
workspace_6a801=/home/hudson/6a801
pakage_info= /home/hudson/$prj/log_version.txt

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
cp -f $workspace_6a801/output/$pakage_version    $workspace/platform/
mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz
fi

#copy from apk
apk_dist_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app
apk_list="com.coship.adjustthevolume com.coship.app.vaf com.coship.ChangeTheAudioOutput com.coship.dvbplayer com.coship.dvbsetting com.coship.Multimedia com.coship.netfirmware com.coship.NetworkNavigation com.coship.startwizard com.coship.TestApp com.coship.trafficmonitor"
cd $apk_dist_dir

for apk_mdl in $apk_list
	do
	cd /home/hudson/apps/$apk/output
	pakage_version=`ls *.tar.gz`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then echo "not $apk_mdl new package " >> $workspace/log_version.txt
	else 
		echo "\n\n copy $pakage_version begin " >> $workspace/log_version.txt 
		cd $apk_dist_dir
		mkdir tmp
		cp -f /home/hudson/apps/$apk_mdl/output/$pakage_version		   tmp/
		cd tmp
		tar -zxvf $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo echo "tar $pakage_version ok"  >> $workspace/log_version.txt 
		cp -f $pakage_version_apk  $apk_dist_dir/ >> $workspace/log_version.txt  || echo echo "tar $pakage_version ok"  >> $workspace/log_version.txt 
		rm -fr tmp
done







  