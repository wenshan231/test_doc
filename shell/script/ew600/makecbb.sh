#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: QiaoTing (on 2010/04/15) add platform rlease branch

svnreversion=$1
model_list_cbb=$2
mdli=$3
prj=$4
dir=$5
plat=$6
mod=$7


allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

log_file=$allpath/logs/make_$prj.log
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
idmd=0
flag=0
flagcute=0

if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ] || [ "$prj" = "shanxi_mstar_7c51g" ]
then
	pro=shanxi
elif [ "$prj" = "hubei_gcable_hi3716m" ] || [ "$prj" = "hubei_ngb_hi3716m" ]
then
	pro=hubei
elif [ "$prj" = "sichuan_4.7_osg" ]
then
	pro=sichuan	
else
	pro=none
fi


echo -e "====================== iconv exportSvnVersion 6export_mmcp_ver setupenv =====================" >> $log_file
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

if [ "$pro" = "shanxi" ]
then
	cd $workpath/integration/product/shanxi
	mytype=`file --mime-encoding -b "setupenv"`
	mytype=`echo $mytype |cut -c 1-3`
	if [ "$mytype" != "utf" ]
	then
		echo setupenv >> setupenv.bak
		mv setupenv setupenv.bak
		iconv -f gb2312 -t utf-8 setupenv.bak > setupenv
		chmod 777 -Rf setupenv
	fi
fi

#### get product version and write into include/mmcp_project_version.h
if [ "$pro" = "shanxi" ]
then
	cd $workpath/integration/product/shanxi
	if [ "$plat" == "ali_m3701c" ]
	then	
		. setupenv pf=ali manu=juying typeid=64 ca=dvn
	elif [ "$plat" == "mstar_7c51c" ]
	then
		. setupenv pf=mstar manu=hisense typeid=64
	elif [ "$plat" == "hi3716M_hisiv200" ]
	then
		. setupenv pf=hisi manu=jiulian	
	elif [ "$plat" == "MSD7C51G" ]
	then
		. setupenv pf=7c51g manu=coship ca=tf typeid=65
	

	fi
	
fi

### set mmcp env
cd $workpath
if [ "$prj" == "hubei_gcable_hi3716m" ] || [ "$prj" == "hubei_ngb_hi3716m" ]
then
	. bin/setupenv --ia bin/envfile_fortrunk/setenv\_$plat\_$mod\_hubei
elif [ "$prj" == "sichuan_4.7_osg" ]
then
	. bin/setupenv --ia bin/envfile_fortrunk/setenv\_$plat\_$mod\_sichuan
elif [ "$prj" == "trunk_4.7" ]
then
	. bin/setupenv --ia bin/envfile_fortrunk/setenv\_$plat\_$mod\_guangdong
elif [ "$prj" == "ew600_4.7_osg" ] || [ "$prj" == "guangdong_4.7" ] || [ "$prj" == "guangdong_android_hi3716c_v200" ] || [ "$prj" == "guangdong_android_hi3716c_v200_client" ]
then
	. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod
elif [ "$pro" = "shanxi" ]
then
	. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod\_shanxi
elif [ "$prj" == "ew600_wuhan_hi3716H" ]
then
	echo ============this is ew600_wuhan_hi3716H=========================
	. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod\_EW600_wuhan
else
   . bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod
fi


showenv >> $log_file

### set ca env
. bin/casetupenv --ia bin/envfile_fortrunk/setenv_ca_tfcdca_release

if [ "$pro" = "shanxi" ]
then
	export MMCP_CATYPE=tongfangca
	export MMCP_COMPANY=OTHER_COMPANY
fi

echo $model_list_cbb | grep "kernel"
if [ $? -eq 0 ]
then :
else
         model_list_cbb="kernel $model_list_cbb"
fi


echo -e "====================== rm libmmcp_ew600.a =====================" >> $log_file
cd $workpath/lib/$plat/$mod
rm libmmcp_ew* -f


### build qt_4.7
export build_qt47=true

### jvm first and make
echo -e "------$mdli $mdl for $prj make begin------ " >> $log_file_detail
cd $workpath/jvm
make clean > /dev/null 2>&1
make FIRST=true >> $log_file_detail  2>&1
if [ $? -eq 0 ]
then
	echo -e "----------- $mdli jvm FIRST=true for $prj $plat make success --------\n"
	echo -e "$mdli jvm FIRST=true for $prj $plat make success----- " >> $log_file
	echo -e "$mdli jvm FIRST=true for $prj $plat make success----- " >> $log_file_detail
else
	echo -e "----------- $mdli jvm FIRST=true for $prj $plat make failed message is :--------\n"
	tail -10 $log_file_detail
  echo -e "$mdli jvm FIRST=true for $prj $plat make failed------ " >> $log_file_detail
  echo -e "$mdli jvm FIRST=true for $prj $plat make failed message is :------ " >> $log_file
  tail -10 $log_file_detail >>  $log_file
fi

for mdlcbb in $model_list_cbb
do
        mdli=$(($mdli+1))
        author=`echo $model_list_author_cbb | awk {'print $1'}`
        model_list_author_cbb=`echo $model_list_author_cbb | sed "s/$author//g"`
        
        
	if [ "$mdlcbb" = "cute" ]
	then
		echo ===================== the current cbb is cute==========
		echo ===================== the current cbb is cute,make cute later.... >> $log_file
		flagcute=1
		if [ "$prj" == "ew600_wuhan_hi3716H" ]
    then
       cp -r /home/tmp/guangdong_hi3716m/release/* $workpath/lib/hi3716H/release/
       cp -r /home/tmp/guangdong_hi3716m/debug/* $workpath/lib/hi3716H/debug/
       flagcute=0
	     echo ============this is ew600_wuhan_hi3716H=========================
	  fi		
		
	elif [ "$mdlcbb" = "mediaplayer" ] && [ "$pro" = "shanxi" ] 
	then
			cd $workpath/$mdlcbb
	    chmod 777 -Rf *
	    make -f makefile_mp clean > /dev/null 2>&1
	    make -f makefile_mp >> $log_file_detail  2>&1
			if [ $? -eq 0 ]
	    then
	            echo =========== mediaplayer make success ============ >> $log_file
	    else
	            echo ============== mediaplayer make failed =========== >> $log_file
	    fi
		
	elif [ "$mdlcbb" = "cfg" ]
	then
		cd $workpath/$mdlcbb
    chmod 777 -Rf *
				
		if [ "$prj" == "hubei_gcable_hi3716m" ] || [ "$prj" == "hubei_ngb_hi3716m" ]
		then
			config_list="make3716m make3716m_3rd"	
		elif [ "$prj" == "sichuan_4.7_osg" ]
		then
			config_list="make3716m_chengdu make3716m_tf_3rd make3716m_shuma_3rd"	
		elif [ "$prj" == "guangdong_4.7" ]
		then
			config_list="make3716h make3716h_wifi make3716h_wifi_shuma make3716m_3rd make3716m_shuma_3rd make3716m_wifi_3rd make3716m_wifi_shuma_3rd make3716m_wifi_shuma_raoping make3716m_yinhe_3rd"				
		elif [ "$prj" == "shanxi_4.7" ] && [ "$plat" == "hi3716M_hisiv200" ]
		then
			config_list="makeShanxi_3rd_3716M makeShanxi_3rd_3716M_dvn makeShanxi_3rd_3716M_dvn makeShanxi_3rd_3716M_shuma makeShanxi_3rd_3716M_tfdvn makeShanxi_N9201_V310 makeShanxi_N9201_V310_dvn makeShanxi_N9201_V310_shuma"				
		elif [ "$prj" == "shanxi_mstar_4.7" ] && [ "$plat" == "mstar_7c51c" ]
		then
			config_list="makeShanxi_Mstar_7c51c makeShanxi_Mstar_7c51c_skyworth makeShanxi_Mstar_7c51c_skyworth_dvn makeShanxi_Mstar_7c51c_skyworth_shuma"				
		elif [ "$prj" == "shanxi_ali_4.7" ] && [ "$plat" == "ali_m3701c" ]
		then
			config_list="makeShanxi_Ali_m3701c makeShanxi_Ali_m3701c_shuma makeShanxi_Ali_m3701c_dvn makeShanxi_N8001C makeShanxi_N8001C_dvn makeShanxi_N8001C_shuma"				
		elif [ "$prj" == "shanxi_mstar_7c51g" ] && [ "$plat" == "MSD7C51G" ]
		then
			config_list="makeShanxi_Mstar_7C51G makeShanxi_Mstar_7C51G_dvn makeShanxi_Mstar_7C51G_shuma"
		elif [ "$prj" == "sichuan_ew600_MSD7C51G" ]
		then
			config_list="make7C51G make7C51G_shuma"
		fi
		echo ===================== the current cbb is cfg==========	
		for config in $config_list
		do
			make clean > /dev/null 2>&1
			configfile=$config.txt
			make config=$configfile  >> $log_file_detail  2>&1
			if [ $? -ne 0 ]
			then
				flag=1
				rm $workpath/lib/$plat/$mod/lib$config.a -f
				echo ===================== cfg make $config failed message is :  ========================
				tail -10 $log_file_detail
				echo ===================== cfg make $config failed message is :  ================ >> $log_file
				tail -10 $log_file_detail >>  $log_file
			else
				echo ===================== cfg $config make success ========================
				echo ===================== cfg $config make success ======================== >> $log_file
			fi
		done

	else
        	cd $workpath/$mdlcbb
					chmod 777 -Rf *
        	make clean > /dev/null 2>&1
        	make  >> $log_file_detail  2>&1
					if [ $? -eq 0 ]
	        then
        	        result=success
        	        echo -e "--------------- $mdli $mdlcbb for $prj $plat $mod make success ---------------\n"
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success----- " >> $log_file
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success----- " >> $log_file_detail
	        else
        	        result=failed
									echo -e "--------------- $mdli $mdlcbb for $prj $plat $mod make failed message is : ---------------\n"
        	        tail -10 $log_file_detail
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make failed message is :------ " >> $log_file
									tail -10 $log_file_detail >>  $log_file
			### libmmcp_ew600.a doesn't contain these libs
			if [ "$mdlcbb" = "thirdparty/ca/tfcdcasa" ] || [ "$mdlcbb" = "thirdparty/ca/shumashixun_multi" ] || [ "$mdlcbb" = "share/udi2/hdicommon/udi2_caadapter" ] || [ "$mdlcbb" = "share/udiplus" ] || [ "$mdlcbb" = "share/udi2/lcsp_udi1" ]
                	then
                        	flag=0
			else
                        	cd $workpath/lib/$plat/$mod
													echo -e "================ the current path and lib: $(pwd),$mdlcbb.a ==================" >> $log_file
                        	rm lib$mdlcbb* -f
                        	flag=1
                        	logfaild="$logfaild $mdlcbb:$author"
                	fi
		fi
        fi

        echo -e "<items>" >> $log_tmp
        echo -e "<id>$mdli</id>" >> $log_tmp
        echo -e "<modules>$mdlcbb</modules>"  >> $log_tmp
        echo -e "<author>$author</author>"  >> $log_tmp
        echo -e "<svn_version>$svnreversion</svn_version>" >> $log_tmp
        echo -e "<mod>$mod</mod>" >> $log_tmp
        echo -e "<result>$result</result>" >> $log_tmp
        echo -e "</items>" >> $log_tmp
done

if [ "$flagcute" -eq 1 ]
then
	if [ "$mod" = "release" ]
	then
		#5 make cute
		echo "+++++++++++++++++++++++++++++++ release, begin to make cute ++++++++++++++++++++++++++++++++"
		echo "+++++++++++++++++++++++++++++++ release, begin to make cute ++++++++++++++++++++++++++++++++" >> $log_file

                cd $workpath/lib/$plat/$mod
                rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf

		cd $workpath/cute
		chmod +x build_modules_4.7.sh

		if [ -f ./build_modules_4.7.sh  ]; then
			echo "exec build_modules_4.7.sh" >> $log_file
			if [ "$prj" = "guangdong_4.7" ] || [ "$prj" = "guangdong_hi3716m" ] || [ "$prj" == "guangdong_android_hi3716c_v200" ] || [ "$prj" == "guangdong_android_hi3716c_v200_client" ]
			then
				echo 1 | . build_modules_4.7.sh > /dev/null 2>&1
				echo 2 | . build_modules_4.7.sh > /dev/null 2>&1
			else
				echo a | . build_modules_4.7.sh 2 2 > /dev/null 2>&1
			fi
		else
			echo "no build_modules_4.7.sh" >> $log_file
		fi

		if [ -f $workpath/build_error.log ]; then
			echo "cat to $log_file" >> $log_file_detail
			cat $workpath/build_error.log >> $log_file_detail
		else
			echo "No $workpath/build_error.log" >> $log_file
		fi

		if [ -d $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/qt_lib ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libqtmicrowin.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libwebkitPlatform.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libwebkitshell.a ]
		then			
			flag=0	
		else			
			flag=1			
			echo -e "--------------- cute for $prj $plat $mod make faild ---------------\n"	
			echo -e "--------------- cute for $prj $plat $mod make faild ---------------\n" >> $log_file			
		fi


	else
		echo "++++++++++++++++++++++++++++++++++ debug, only copy cute +++++++++++++++++++++++++++++++++++" >> $log_file
		cd $workpath/lib/$plat/$mod
                rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf
		if [ -d $workpath/lib/$MMCP_PLATFORM/release/qt_lib ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libqtmicrowin.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libwebkitPlatform.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libwebkitshell.a ]; then
			flag=0
			cp $workpath/lib/$plat/release/qt_lib qt_lib -rf
			if [ "$prj" = "guangdong_4.7" ] || [ "$prj" = "guangdong_hi3716m" ] || [ "$prj" == "guangdong_android_hi3716c_v200" ] || [ "$prj" == "guangdong_android_hi3716c_v200_client" ]
			then
				cp $workpath/lib/$plat/release/qt_lib_static qt_lib_static -rf
			fi
			cp $workpath/lib/$plat/release/libqtmicrowin.a libqtmicrowin.a -f
			cp $workpath/lib/$plat/release/libwebkitPlatform.a libwebkitPlatform.a -f
			cp $workpath/lib/$plat/release/libwebkitshell.a libwebkitshell.a -f
		else
			echo -e "--------------- cute for $prj $plat $mod make faild ---------------\n" >> $log_file	
			echo -e "--------------- cute for $prj $plat $mod make faild ---------------\n"	
			flag=1
		fi
	fi

fi

if [ "$flag" -eq 1 ]
then
	echo -e "\n\n****1**** Result: make $prj $plat $mod failed  reversion $svnreversion **********\n\n"
        echo -e "\n\n****1**** Result: make $prj $plat $mod failed  reversion $svnreversion **********\n\n"  >> $log_file
        echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
else
        cd $workpath
	if [ "$prj" = "trunk_4.7" ] || [ "$prj" == "guangdong_android_hi3716c_v200" ] || [ "$prj" == "guangdong_android_hi3716c_v200_client" ] || [ "$prj" == "ew600_wuhan_hi3716H" ]
	then
		make mmcp   >> $log_file_detail  2>&1
	else
        	make pack   >> $log_file_detail  2>&1
	fi
        if [ $? -eq 0 ]
        then
        	echo -e "\n\n******** Result: make $prj $plat $mod success  reversion $svnreversion **********\n\n"
        	echo -e "********Result: make $prj $palt $mod success  reversion $svnreversion**********\n\n"  >> $log_file
        else
        	echo -e "\n\n***2***** Result: make $prj $plat $mod failed  reversion $svnreversion **********\n\n"
                echo -e "****2****Result: make $prj $plat $mod failed  reversion $svnreversion**********\n\n"  >> $log_file
        	echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
        fi
fi



