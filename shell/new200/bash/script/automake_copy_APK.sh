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

apk_dis_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app
apk_list="AdjustTheVolume ChangeTheAudioOutput com.coship.netfirmware Coship_VAF dvbplayer dvbsetting Multimedia NetworkNavigation StartGuide TestApp TrafficMonitor"
cd $apk_dis_dir
mkdir tmp
for apk in $apk_list
		do
		  case "$apk" in
   			AdjustTheVolume)
                        cd /home/hudson/apps/$apk/output
                        pakage_version=`ls *.tar.gz`
                        echo $pakage_version
												if [ "$pakage_version" == "" ]
												then echo "not APK new package \n" >> $workspace/log_version.txt
												else 
												echo "copy APK: $pakage_version \n" >> $workspace/log_version.txt 
												cd $apk_dis_dir
												cp -f /home/hudson/apps/$apk/output/$pakage_version		   tmp
												cd tmp
												tar -xvf $pakage_version
												pakage_version_apk=`ls *.apk`
												cp -f $pakage_version_apk  $apk_dis_dir/ >>  $workspace/log_version.txt  2>&1
fi
                        
                        
                        
                        ;;
                        shell)
                                model_list_author="$model_list_author huhuatao"
                        ;;
                        codec)
                                model_list_author="$model_list_author fushouwei"
                        ;;
                        dtv)
                                model_list_author="$model_list_author caorui"
                        ;;
                        graph)
                                model_list_author="$model_list_author jiangfeng"
                        ;;
                        jsext)
                                model_list_author="$model_list_author zhaodemin"
                        ;;
                        kernel)
                                model_list_author="$model_list_author caozhenliang"
                        ;;
                        mediaplayer)
                                model_list_author="$model_list_author fushouwei"
                        ;;
                        midp)
                                model_list_author="$model_list_author zhuokeqiao"
                        ;;
                        protocol)
                                model_list_author="$model_list_author zhengfen"
                        ;;
                        guitool)
                                model_list_author="$model_list_author zhangminrui"
                        ;;
                        jvm)
                                model_list_author="$model_list_author lianxijian"
                        ;;
                        pvr)
                                model_list_author="$model_list_author huhuatao"
                        ;;
                        thirdparty/tts)
                                model_list_author="$model_list_author liuchao"
                        ;;
                        thirdparty/mis)
                                model_list_author="$model_list_author liuchao"
                        ;;
			thirdparty/unionPay)
                                model_list_author="$model_list_author zhuokeqiao"
                        ;;

			esac
		done







 