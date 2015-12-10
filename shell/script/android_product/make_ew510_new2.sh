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
	if [ "$prj" = "guizhou_android_6a801" ]
	then
		echo ================ current project is guizhou_android_6A801 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/guizhou_coship_Android6A801 cfg\/ottdvb_Android6A801/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdcasa/g' | sed 's/porting//g'`

	elif [ "$prj" = "guizhou_android_6a801_client" ]
	then
		echo ================ current project is guizhou_android_6A801_client ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/guizhou_coship_Android6A801_Client cfg\/ottdvb_Android6A801_Client/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/ca\/tfcdcasa/g' | sed 's/jvm//g' | sed 's/guitool//g' | sed 's/graph//g' | sed 's/midp//g' | sed 's/porting//g'`
 elif [ "$prj" = "wuhan_android_6a801" ]
	then
		echo ================ current project is wuhan_android_6A801 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdcasa/g' | sed 's/porting//g'`

	elif [ "$prj" = "wuhan_android_6a801_client" ]
	then
		echo ================ current project is wuhan_android_6A801_client ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/ca\/tfcdcasa/g' | sed 's/jvm//g' | sed 's/guitool//g' | sed 's/graph//g' | sed 's/midp//g' | sed 's/porting//g'`

	elif [ "$prj" = "delivery_android_6a801" ]
	then
		echo ================ current project is delivery_android_6A801 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/ottdvb_Android6A801/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/camanager thirdparty\/ca\/caudiadapter/g' | sed 's/porting//g'`
                echo $model_list_all | grep "cfg/ottdvb_Android6A801"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg/ottdvb_Android6A801"
                fi

	elif [ "$prj" = "delivery_android_6a801_client" ]
	then
		echo ================ current project is delivery_android_6A801_client ================ >> $log_file	
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/makefile/kernel/g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/ottdvb_Android6A801_Client/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/ca\/camanager/g' | sed 's/jvm//g' | sed 's/midp//g' | sed 's/porting//g'`
                echo $model_list_all | grep "cfg/ottdvb_Android6A801_Client"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg/ottdvb_Android6A801_Client"
                fi

	elif [ "$prj" = "changsha_android_6a801" ]
	then
		echo ================ current project is changsha_android_6A801 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/changsha_coship_Android6A801/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/porting//g'`
		echo $model_list_all | grep "cfg/changsha_coship_Android6A801"
		if [ $? -eq 0 ]
		then
			echo cfg exits~~~~~~~~
		else
			model_list_all="$model_list_all cfg/changsha_coship_Android6A801"
		fi
          
	elif [ "$prj" = "changsha_android_6a801_client" ]
	then
		echo ================ current project is changsha_android_6A801_client ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/changsha_coship_Android6A801_Client/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis/g' | sed 's/jvm//g' | sed 's/midp//g' | sed 's/porting//g'`
		echo $model_list_all | grep "cfg/changsha_coship_Android6A801_Client"
		if [ $? -eq 0 ]
		then
			echo cfg exits~~~~~~~~
		else
			model_list_all="$model_list_all cfg/changsha_coship_Android6A801_Client"
		fi
		
		
		
	elif [ "$prj" = "delivery_Android_Hi3716C_V200" ]
	then
		echo ================ current project is delivery_Android_Hi3716C_V200 ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/ottdvb_Android6A801/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/camanager thirdparty\/ca\/caudiadapter/g' | sed 's/porting//g'`
                echo $model_list_all | grep "cfg/taiwan_hi3716C_V200"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg/taiwan_hi3716C_V200"
                fi

	elif [ "$prj" = "delivery_Android_Hi3716C_V200_Client" ]
	then
		echo ================ current project is delivery_Android_Hi3716C_V200_Client ================ >> $log_file	
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/makefile/kernel/g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/ottdvb_Android6A801_Client/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/ca\/camanager/g' | sed 's/jvm//g' | sed 's/midp//g' | sed 's/porting//g'`
                echo $model_list_all | grep "cfg/taiwan_hi3716C_V200_client"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg/taiwan_hi3716C_V200_client"
                fi
		pause
		
		
		
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
				if [ "$prj" != "guizhou_android_6a801_client" ] && [ "$prj" != "changsha_android_6a801_client" ]
				then	
					model_list=`echo  $model_list_all | sed 's/jvm//g' | sed 's/dtvmx/dtvmx jvm/g'`
				else
					model_list=$model_list_all
				fi
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

		if [ "$prj" = "guizhou_android_6a801"  ]
		then
			echo ================ current project is guizhou_android_6A801 ================ >> $log_file
			model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdcasa cfg/guizhou_coship_Android6A801 cfg/ottdvb_Android6A801"
		
		elif [ "$prj" = "guizhou_android_6a801_client" ]
		then
			echo ================ current project is guizhou_android_6A801_client ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx shell thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdcasa cfg/guizhou_coship_Android6A801_Client cfg/ottdvb_Android6A801_Client"
		
                elif [ "$prj" = "delivery_android_6a801" ]
                then
                        echo ================ current project is delivery_android_6A801 ================ >> $log_file 
                        model_list="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/camanager  thirdparty/ca/caudiadapter cfg/ottdvb_Android6A801"
                elif [ "$prj" = "delivery_android_6a801_test" ]
                then
                        
                        echo ================ current project is delivery_android_6a801_test ================ 
                        model_list="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/camanager  thirdparty/ca/caudiadapter cfg/ottdvb_Android6A801"

                elif [ "$prj" = "delivery_android_6a801_client" ]
                then
                        echo ================ current project is delivery_android_6a801_client ================ >> $log_file
                        model_list="dtv kernel protocol codec jsext mediaplayer dtvmx shell guitool graph thirdparty/tts thirdparty/mis thirdparty/ca/camanager cfg/ottdvb_Android6A801_Client"		
    elif [ "$prj" = "wuhan_android_6a801" ]
		then
			echo ================ current project is wuhan_android_6A801 ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay "
			
		elif [ "$prj" = "wuhan_android_6a801_client" ]
		then
			echo ================ current project is wuhan_android_6A801_client ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx shell guitool graph thirdparty/tts thirdparty/mis "
			
		elif [ "$prj" = "changsha_android_6a801" ]
		then
			echo ================ current project is changsha_android_6A801 ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay cfg/changsha_coship_Android6A801"
			
		elif [ "$prj" = "changsha_android_6a801_client" ]
		then
			echo ================ current project is changsha_android_6A801_client ================ >> $log_file
			model_list="dtv kernel protocol codec jsext mediaplayer dtvmx shell guitool graph thirdparty/tts thirdparty/mis cfg/changsha_coship_Android6A801_Client"
		
						
		elif [ "$prj" = "delivery_Android_Hi3716C_V200_Client" ]
		then
			echo ================ current project is Android_Hi3716C_V200_Client ================ >> $log_file
			model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool graph thirdparty/unionPay cfg/taiwan_hi3716C_V200_client"
			pause	
		elif [ "$prj" = "delivery_Android_Hi3716C_V200" ]
		then
			echo ================ current project is Android_Hi3716C_V200 ================ >> $log_file
			model_list="dtv kernel protocol codec midp jsext jvm mediaplayer dtvmx shell guitool graph thirdparty/unionPay cfg/taiwan_hi3716C_V200"
			pause	
	fi	
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
		  Android_Hi3716C_V200)
				source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
      	;;
			Android_Hi3716C_V200_Client)
				#source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
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
if [ "$prj" = "delivery_android_6a801" ] || [ "$prj" = "delivery_android_6a801_client" ]
then
	binder_des_ott=$workpath/integration/product/OTT_DVB/porting/Android_6A801/coship/lib
	rm $binder_des_ott/libBinderManager*.a -f
	cp $binder_tongfang3_src/libBinderManager*.a $binder_des_ott/. -f
	cp $binder_irdeto3_src/libBinderManager*.a $binder_des_ott/. -f
	cp $binder_suma_src/libBinderManager*.a $binder_des_ott/. -f
	cp $binder_udrm_src/libBinderManager*.a $binder_des_ott/. -f
fi




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

	if [ "$prj" = "delivery_android_6a801" ] || [ "$prj" = "delivery_android_6a801_client" ]
	then
		mkdir $workpath/lib/mmcp_publish -p
	fi

	
	if [ "$prj" = "delivery_android_6a801" ] || [ "$prj" = "delivery_android_6a801_client" ]
        then
		product_list="haerbin_android_merge OTT_DVB"
		for productname in $product_list
		do
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
                		echo -e "================ make $productname mmcp_publish success =============="        
				echo  -e "================ make $productname mmcp_publish success ==============" >> $log_file
                	else
                		flag3rdresult=1
                        	echo  -e "================ make $productname mmcp_publish failed ==============" >> $log_file
				echo -e "================ make $productname mmcp_publish failed =============="
                             #exit 1
                	fi
                	make bin >> $log_file_detail  2>&1
                	chmod 777 script/make_publish.sh
                	make publish > /dev/null 2>&1
			cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/mmcp_publish/$productname -rf			
		done

	else	
		cd $workpath/integration/product/$productname
		if [ "$plat_list" = "Android_6A801" ]
		then
			if [ "$prj" = "changsha_android_6a801" ]
			then
				. setupenv --m coship
			else
				. setupenv --ia setenv_Android_6A801_debug coship
			fi
		elif [ "$plat_list" = "Android_6A801_Client" ]
		then                                  
			if [ "$prj" = "changsha_android_6a801_client" ]
                	then
                        	. setupenv_client --m coship
			else
				. setupenv --ia setenv_Android_6A801_Client_debug coship
			fi
		
		#######add hi3716
		elif [ "$plat_list" = "Android_Hi3716C_V200_Client" ]
		then                                  
	  	. setupenv --ia setenv_Android_Hi3716C_V200_Client_debug coship
	  echo $plat_list ok qiaoting
	  showenv

		elif [ "$plat_list" = "Android_Hi3716C_V200" ]
		then                                  
	  	. setupenv --ia setenv_Android_Hi3716C_V200_debug coship
		showenv
		echo $plat_list ok qiaoting
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
		chmod 777 script/make_publish.sh
		make publish > /dev/null 2>&1
		
		### copy
        	echo -e "================ now, begin to copy mmcp_publish ==============" >> $log_file
        	cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/. -rf
	fi
  fi
	### copy dtvmxlib.jar to mmcp_publish
	cp $workpath/lib/dtvmxlib.jar $workpath/lib/mmcp_publish/. -f
	
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
echo $prj | grep "Android_Hi3716C_V200"
if [ $? -eq 0 ] 
then echo "0" > $lastmmcpverlog
fi
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







 