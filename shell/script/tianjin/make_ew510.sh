#! /bin/bash
# This script is auto make mmcp  incream 
# @author: QiaoTing (on 2010/02/10)
# modify @author: xieyue (on 2010/06/01) 

prj=$1
dir=$2
plat_list=$3
productname=$4

shellbash=$(pwd)/makecbb.sh


allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

rm $allpath/logs -rf
rm $allpath/output -rf
mkdir $allpath/logs $allpath/output -p



log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
log_failedinfo=$allpath/logs/infotxt.log


mdli=0
flag=0
flagall=1
flagmmcpnomake=1
flag3rdnomake=0
mdli=0
flagdebug=0
copyall=1
flag3rdresult=0

lastmmcpverlog=/home/hudson/lastver/lastver\_$prj\_mmcp.log





nowmmcpver=`head -11 $workpath/.svn/entries | tail -1`
lastmmcpver=`cat $lastmmcpverlog`
echo -e "====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================" >> $log_file
echo ====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================

last3rdver=0
now3rdver=0
### if there is 3rd we need to get the 3rd ver
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	last3rdver=0
  now3rdver=`head -11 $workpath/integration/product/$productname/.svn/entries | tail -1`
  echo -e "===================== project version:$now3rdver ==================" >> $log_file
  echo ====================== project version:$now3rdver =====================	
fi
okmsg="[CC]Result of $prj make success revision $nowmmcpver"
errormsg="[CC]Result of $prj make failed revision $nowmmcpver"

echo -e "<infoxml>" > $log_failedinfo



if [ "$lastmmcpver" -eq 0 ]
then 
	flagall=0
else
	cd $workpath
	
 if [ "$prj" = "tianjin_android_6a801" ]
	then
		echo ================ current project is tianjin_android_6A801 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun-tianjin/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus/g'`
  fi
	echo -e "==================== modified models compared to last version:"$model_list_all" ==================" >> $log_file

	if [ "$model_list_all" = "" ]
	then
		echo "only noncbb modules change and not build" >> $log_file
		flagmmcpnomake=0
	else	
		echo $model_list_all | grep -E "include|bin|build" 
		if [ $? -eq 0 ]
		then
			flagall=0
		else
			echo $model_list_all | grep "dtvmx"
			if [ $? -eq 0 ]
			then 
					model_list=`echo  $model_list_all | sed 's/jvm//g' | sed 's/dtvmx/dtvmx jvm/g'`
				echo $model_list
			else
				model_list=$model_list_all
			fi
		fi 
	fi
fi

if [ "$flagmmcpnomake" -eq 0 ]
then
	echo "no mmcp cbb need to make ~~~~~~~~~~~~~~~~~~~~~"
else
	echo "some mmcp cbb has been modified, need to make ~~~~~~~~~~~~~~~~~~~~~~~~"

	model_list_dbg="jvm"
	model_list_dbg_author="huhuatao"
	if [ $flagall -eq 0 ]
	then
		rm -fr $workpath/lib
		model_list_author="yanghuiyuan huhuatao fushouwei caorui longshirong zhaodemin caozhenliang fushouwei zhuokeqiao zhengfen zhangminrui lianxijian caorui caorui zhuokeqiao fanyong fanyong"
	
    if [ "$prj" = "tianjin_android_6a801" ]
		then
			echo ================ current project is wuhan_android_6A801 ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp cfg thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/shumashixun-tianjin porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/lcsp_udi1 "	
	 fi	
	echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
	echo -e "================ all need to make models:"$model_list" =============="
	for plat in $plat_list
		do
			case "$plat" in
			Android_6A801)
				source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
      	;;

			Android_6A801_Client)
				source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				;;
		esac
	done
fi	
 

### get the lastest version of binder_510apk
binderapk_pubpath=/home/hudson/publisher/binder_510apk
cd $binderapk_pubpath
lastest_package=`ls -rt | tail -n1`
echo -e "============= now, begin to copy binder_510apk:$lastest_package ============" >> $log_file
apksvn=`cat $lastest_package/logs/apksvn.log`
bindersvn=`cat $lastest_package/logs/bindersvn.log`


### premake need to copy binder to product
binder_tongfang3_src=/home/hudson/publisher/binder_510apk/$lastest_package/mstar6a801/Temp/binder/tongfang3
binder_irdeto3_src=/home/hudson/publisher/binder_510apk/$lastest_package/mstar6a801/Temp/binder/irdeto3
binder_suma_src=/home/hudson/publisher/binder_510apk/$lastest_package/mstar6a801/Temp/binder/suma
binder_udrm_src=/home/hudson/publisher/binder_510apk/$lastest_package/mstar6a801/Temp/binder/udrm
binder_des=$workpath/integration/product/$productname/porting/Android_6A801/coship/lib
rm $binder_des/libBinderManager*.a -f
cp $binder_tongfang3_src/libBinderManager*.a $binder_des/. -f
cp $binder_irdeto3_src/libBinderManager*.a $binder_des/. -f
cp $binder_suma_src/libBinderManager*.a $binder_des/. -f
cp $binder_udrm_src/libBinderManager*.a $binder_des/. -f


### if there is 3rd need to make publish
echo -e "===========productname==$productname ============"
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
if [ "$flagmmcpnomake" -eq 1 ] || [ "$last3rdver" -lt "$now3rdver" ]
then
	flag3rdnomake=1	
	echo -e "============= now, begin to make $plat_list mmcp_publish ============" >> $log_file
	echo -e "============= now, begin to make $plat_list mmcp_publish ============"
	if [ -d $workpath/lib/mmcp_publish ]
	then
		rm $workpath/lib/mmcp_publish -rf
	fi

		cd $workpath/integration/product/$productname
    if [ "$plat_list" = "Android_6A801" ]
    then	
				. setupenv --ia setenv_Android_6A801_debug coship
		elif [ "$plat_list" = "Android_6A801_Client" ]
		then                                  	
				. setupenv --ia setenv_Android_6A801_Client_debug coship
		fi

		make clean > /dev/null 2>&1
		make >> $log_file_detail  2>&1
		if [ $? -eq 0 ]
		then
			echo -e "================ make  mmcp_publish success =============="
			echo  -e "================ make mmcp_publish success ==============" >> $log_file	
		else
			flag3rdresult=1
			echo -e "================ make  mmcp_publish failed =============="	
			echo  -e "================ make mmcp_publish failed ==============" >> $log_file  
	        	#exit 1
		fi
		make bin >> $log_file_detail  2>&1
		if [ "$prj" = "wuhan_android_6a801" ]
		then 
		chmod 777 script/make_publish_coship.sh
		else
		chmod 777 script/make_publish.sh
		fi
		make publish > /dev/null 2>&1
		
		### copy
        	echo -e "================ now, begin to copy mmcp_publish ==============" >> $log_file
        	cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/. -rf
	if [ "$prj" = "wuhan_android_6a801_hisense" ]
	then
		echo -e "wuhan android 6a801 mmcp_publish_hisense"
		cp $workpath/integration/product/$productname/mmcp_publish_hisense $workpath/lib/. -rf
	fi
	fi
  fi
	### copy dtvmxlib.jar to mmcp_publish
	#cp $workpath/lib/dtvmxlib.jar $workpath/lib/mmcp_publish/. -f
	cp $workpath/dtvmx/bin/dtvmxlib.jar $workpath/lib/mmcp_publish/. -f
	### copy 510apk to mmcp_publish
	apk_src=/home/hudson/publisher/binder_510apk/$lastest_package/mstar6a801/Temp/com.coship.mmcp510.merge
	apk_des=$workpath/lib/mmcp_publish
	cp $apk_src/*  $apk_des/. -f
fi



### make over begin to copy
if [ "$flag3rdnomake" -eq 1 ] || [ "$flagmmcpnomake" -eq 1 ]
then
		cp $workpath/lib $allpath/output -fr 
		cp $workpath/include $workpath/include_release -fr
		cd $workpath/include_release && \
		echo  ======================== find .svn with include and remove them ==========================
		#find -name ".svn"  -exec rm -fr {} \;
		mv  $workpath/include_release  $allpath/output/

		
		## copy to pub
		creattime=`date +%Y%m%d%H%M`
		pubdir=/home/hudson/publisher/$prj/$creattime\_mmcp$nowmmcpver\_product$now3rdver\_510apk$apksvn\_binder$bindersvn
		mkdir $pubdir/lib -p
		if [ $? -eq 0 ]
		then
                	cp $allpath/output/* $pubdir/lib -fr
                	cp $allpath/logs $pubdir/log -fr
			cp /home/hudson/publisher/binder_510apk/$lastest_package/logs/* $pubdir/log -fr
		else
			echo  -e "========================== mkdir public file failed ==========================" >> $log_file
		fi

		## end

fi


echo $nowmmcpver > $lastmmcpverlog

#grep "failed"  $log_file
if [ "$prj" = "guizhou_android_6a801_client" ]
then
				if [ -f $workpath/lib/Android_6A801_Client/release/libmmcp_ew510*.* ] && [ $flag3rdresult -eq 0 ]
				then
	        echo -e "========================== ew510 make success ==========================" >> $log_file
	        echo -e "Good all make success" >> $log_failedinfo
	        echo -e "</infoxml>" >> $log_failedinfo
	        exit 0
				else
						echo -e "========================== make failed ==========================" >> $log_file
		        echo -e "</infoxml>" >> $log_failedinfo
		        exit 1
				fi

elif [ -f $workpath/lib/Android_6A801/release/libmmcp_ew510*.* ] && [ $flag3rdresult -eq 0 ]
then
	echo -e "========================== ew510 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
        exit 0
        
else
	echo -e "========================== make failed ==========================" >> $log_file
        echo -e "</infoxml>" >> $log_failedinfo
        exit 1
fi







