#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: QiaoTing (on 2010/04/15) add platform rlease branch

svnreversion=$1
model_list_cbb=$2
mdli=$3
prj=$4
dir=$5
mod=$6

plat=hi3716M_hisiv200

allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

log_file=$allpath/logs/make_$prj.log
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
idmd=0
flag=0
flagcute=0

#### set $prj env
cd $workpath
echo $workpath
. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod
showenv >> $log_file

### build qt_4.7
export build_qt47=true

echo -e "====================== rm update lib =====================" >> $log_file
cd $workpath/lib/$plat/$mod
rm libmmcp_ew600*.a -f

echo -e "====================== iconv exportSvnVersion 6export_mmcp_ver =====================" >> $log_file
cd $workpath/bin
mytype=`file --mime-encoding -b "exportSvnVersion"`
mytype=`echo $mytype |cut -c 1-3`
if [ "$mytype" != "utf" ]
then
	echo exportSvnVersion >> exportSvnVersion.bak
	mv exportSvnVersion exportSvnVersion.bak
	iconv -f gb2312 -t utf-8 exportSvnVersion.bak > exportSvnVersion
	chmod 777 -Rf exportSvnVersion	
fi

mytype=`file --mime-encoding -b "6export_mmcp_ver"`
mytype=`echo $mytype |cut -c 1-3`
if [ "$mytype" != "utf" ]
then
	echo 6export_mmcp_ver >> 6export_mmcp_ver.bak
	mv 6export_mmcp_ver 6export_mmcp_ver.bak
	iconv -f gb2312 -t utf-8 6export_mmcp_ver.bak > 6export_mmcp_ver
	chmod 777 -Rf 6export_mmcp_ver		
fi


### copy lib form hi3716H/$mod
echo $model_list_cbb | grep "kernel"
if [ $? -eq 0 ]
then :
else
         model_list_cbb="kernel $model_list_cbb"
fi

if [ -d $workpath/lib/$plat/$mod ]
then
	echo -e "====================== $workpath/lib/$plat/$mod exits =====================" >> $log_file
else
	echo -e "====================== $workpath/lib/$plat/$mod not exits =====================" >> $log_file
	mkdir $workpath/lib/$plat/$mod -p
fi


for mdlcbb in $model_list_cbb
do
	echo $mdlcbb
	echo -e "====================== update cbb:$mdlcbb =====================" >> $log_file
	if [ "$mdlcbb" = "cute" ]
	then
		cd $workpath/lib/$plat/$mod
		rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf
		cp $workpath/lib/hi3716H/release/qt_lib qt_lib -rf
		cp $workpath/lib/hi3716H/release/qt_lib_static qt_lib_static -rf
                cp $workpath/lib/hi3716H/release/libqtmicrowin.a libqtmicrowin.a -f
                cp $workpath/lib/hi3716H/release/libwebkitPlatform.a libwebkitPlatform.a -f
		cp $workpath/lib/hi3716H/release/libwebkitshell.a libwebkitshell.a -f

        elif  [ "$mdlcbb" = "mediaplayer" ]
        then
                cd $workpath/lib/$plat/$mod
                rm libmediaplayer*.a libffmpeg.a -f
                cp $workpath/lib/hi3716H/$mod/libmediaplayer*.a . -f
								cp $workpath/lib/hi3716H/$mod/libffmpeg.a . -f

        elif  [ "$mdlcbb" = "jvm" ] || [ "$mdlcbb" = "dtvmx" ]
        then
                cd $workpath/lib/$plat/$mod
                rm libdtvmx.a libjavaclass.a libjavavm.a -f
                cp $workpath/lib/hi3716H/$mod/libdtvmx.a . -f
		cp $workpath/lib/hi3716H/$mod/libjavaclass.a . -f
		cp $workpath/lib/hi3716H/$mod/libjavavm.a . -f
                
	elif  [ "$mdlcbb" = "thirdparty/ca/tfcdcasa" ]
	then
		cd $workpath/lib/$plat/$mod
                rm libcstfcdcasa.a -f
                cp $workpath/lib/hi3716H/$mod/libcstfcdcasa.a . -f
		
	
        elif  [ "$mdlcbb" = "thirdparty/ca/shumashixun_multi" ]
        then
                cd $workpath/lib/$plat/$mod
                rm libcssumavisioncamulti.a -f
                cp $workpath/lib/hi3716H/$mod/libcssumavisioncamulti.a . -f
 
	elif  [ "$mdlcbb" = "share/udi2/hdicommon/udi2_caadapter" ]
	then
		cd $workpath/lib/$plat/$mod
		rm libudi2_caadapter.a -f
		cp $workpath/lib/hi3716H/$mod/libudi2_caadapter.a . -f 

	elif  [ "$mdlcbb" = "share/udiplus" ]
	then
		cd $workpath/lib/$plat/$mod
                rm libUDIPlus.a -f
                cp $workpath/lib/hi3716H/$mod/libUDIPlus.a . -f

	elif  [ "$mdlcbb" = "share/udi2/lcsp_udi1" ]
	then
                cd $workpath/lib/$plat/$mod
                rm libos_udi2_to_udi1.a  -f
                cp $workpath/lib/hi3716H/$mod/libos_udi2_to_udi1.a  . -f

	else
		cd $workpath/lib/$plat/$mod
		rm lib$mdlcbb* -f
		cp $workpath/lib/hi3716H/$mod/lib$mdlcbb* . -f
	fi
done


echo $model_list_cbb | grep "cfg"
if [ $? -eq 0 ]
then
	cd $workpath/lib/$plat/$mod
	rm libcfg* -f
	cd $workpath/cfg
	chmod 777 -Rf *
	make clean > /dev/null 2>&1
	make  >> $log_file_detail  2>&1
	if [ $? -ne 0 ]
	then
		rm $workpath/lib/$plat/$mod/libcfg.a -f
		echo ===================== cfg make failed message is :  ========================
		tail -10 $log_file_detail
		echo ===================== cfg make failed message is :  ======================== >> $log_file
		tail -10 $log_file_detail >>  $log_file
	else
		echo ===================== cfg make success ========================
		echo ===================== cfg make success ======================== >> $log_file
	fi

	make clean > /dev/null 2>&1
	make config=make3716m_3rd.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_3rd.a -f
                echo ===================== cfg_3rd make failed message is :  ========================
                tail -10 $log_file_detail
                echo ===================== cfg_3rd make failed message is :  ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
	else
	echo ===================== cfg_3rd make success ========================
		echo ===================== cfg_3rd make success ======================== >> $log_file
        fi

	make clean > /dev/null 2>&1
	make config=3716m_cloud_mscreen.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfg3716m_cloud_mscreen.a -f
                echo ===================== cfg_cloud_mscreen make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_cloud_mscreen make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
	else
	echo ===================== cfg_cloud_mscreen make success ========================
		echo ===================== cfg_cloud_mscreen make success ======================== >> $log_file
        fi

        make clean > /dev/null 2>&1
        make config=make3716m_wifi.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfg3716m_wifi.a -f
                echo ===================== cfg_wifi for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_wifi for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
	else
	echo ===================== cfg_wifi for hi3716m make success ========================
		echo ===================== cfg_wifi for hi3716m make success ======================== >> $log_file
        fi

        make clean > /dev/null 2>&1
        make config=make3716m_shuma.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_shuma.a -f
                echo ===================== cfg_shuma for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_shuma for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
        else
        echo ===================== cfg_shuma for hi3716m make success ========================
                echo ===================== cfg_shuma for hi3716m make success ======================== >> $log_file
        fi

        make clean > /dev/null 2>&1
        make config=make3716m_shuma_3rd.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_shuma_3rd.a -f
                echo ===================== cfg_shuma_3rd for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_shuma_3rd for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
        else
        				echo ===================== cfg_shuma_3rd for hi3716m make success ========================
                echo ===================== cfg_shuma_3rd for hi3716m make success ======================== >> $log_file
        fi

        make clean > /dev/null 2>&1
        make config=make3716m_wifi_3rd.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_wifi_3rd.a -f
                echo ===================== cfg_wifi_3rd for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_wifi_3rd for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
        else
        				echo ===================== cfg_wifi_3rd for hi3716m make success ========================
                echo ===================== cfg_wifi_3rd for hi3716m make success ======================== >> $log_file
        fi

        make clean > /dev/null 2>&1
        make config=make3716m_wifi_shuma_3rd.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_wifi_shuma_3rd.a -f
                echo ===================== cfg_wifi_shuma_3rd for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_wifi_shuma_3rd for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
        else
        				echo ===================== cfg_wifi_shuma_3rd for hi3716m make success ========================
                echo ===================== cfg_wifi_shuma_3rd for hi3716m make success ======================== >> $log_file     
        fi

				make clean > /dev/null 2>&1
        make config=make3716m_wifi_shuma.txt  >> $log_file_detail  2>&1
        if [ $? -ne 0 ]
        then
                rm $workpath/lib/$plat/$mod/libcfgmake3716m_wifi_shuma.a -f
                echo ===================== cfg_wifi_shuma for hi3716m make failed message is : ========================
                tail -10 $log_file_detail
                echo ===================== cfg_wifi_shuma for hi3716m make failed message is : ======================== >> $log_file
                tail -10 $log_file_detail >>  $log_file
        else
        				echo ===================== cfg_wifi_shuma for hi3716m make success ========================
                echo ===================== cfg_wifi_shuma for hi3716m make success ======================== >> $log_file
        fi

		make clean > /dev/null 2>&1
        	make config=make config=make3716m_wifi_shuma_raoping.txt  >> $log_file_detail  2>&1
        	if [ $? -ne 0 ]
        	then
                	rm $workpath/lib/$plat/$mod/libcfgmake3716m_wifi_shuma_3rd.a -f
                	echo ===================== cfg_wifi_shuma_raoping for hi3716m make failed message is :  ========================
                	tail -10 $log_file_detail
                	echo ===================== cfg_wifi_shuma_raoping for hi3716m make failed message is :  ======================== >> $log_file
                	tail -10 $log_file_detail >>  $log_file
        	else
        					echo ===================== cfg_wifi_shuma_raoping for hi3716m make success ========================
                	echo ===================== cfg_wifi_shuma_raoping for hi3716m make success ======================== >> $log_file
        	fi

		make clean > /dev/null 2>&1
        	make config=make3716m_yinhe_3rd.txt  >> $log_file_detail  2>&1
        	if [ $? -ne 0 ]
        	then
                	rm $workpath/lib/$plat/$mod/libcfgmake3716m_wifi_shuma_3rd.a -f
                	echo ===================== cfg_yinhe_3rd for hi3716m make failed message is :  ========================
                	tail -10 $log_file_detail
                	echo ===================== cfg_yinhe_3rd for hi3716m make failed message is :  ======================== >> $log_file
                	tail -10 $log_file_detail >>  $log_file
        	else
        					echo ===================== cfg_yinhe_3rd for hi3716m make success ========================
                	echo ===================== cfg_yinhe_3rd for hi3716m make success ======================== >> $log_file
        	fi


fi

echo -e "====================== Now,begin to make pack =====================" 
echo -e "====================== Now,begin to make pack =====================" >> $log_file
cd $workpath
make pack >> $log_file_detail



