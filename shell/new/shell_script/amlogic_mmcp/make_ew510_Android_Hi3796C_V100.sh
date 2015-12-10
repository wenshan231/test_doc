#! /bin/bash
 
prj=$1
dir=$2
plat_list=$3
productname=$4

shellbash=$(pwd)/makecbb_Android_Hi3796C_V100.sh

allpath=/home/hudson/$prj
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

if [ "$lastmmcpver" -eq 0 ]
then 
	flagall=0
else
	cd $workpath
	
	if [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu" ]
	then
		echo ================ current project is delivery_android_Hi3796C_V100_jiangsu================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/jiangsu_coship_hi3796C_V100/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/camanager thirdparty\/ca\/caudiadapter/g' | sed 's/porting//g'`           
	  model_list_all="$model_list_all cfg/jiangsu_coship_hi3796C_V100"
	 
	elif [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu_Client" ]
	then
		echo ================ current project is delivery_android_Hi3796C_V100_jiangsu_Client ================ >> $log_file	
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/makefile/kernel/g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/jiangsu_coship_hi3796C_V100_Client/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis  thirdparty\/unionPay thirdparty\/ca\/caudiadapter thirdparty\/ca\/camanager/g' | sed 's/jvm//g' | sed 's/midp//g'`
	  model_list_all="$model_list_all   cfg/jiangsu_coship_hi3796C_V100_Client"
	fi
	echo ==================== modified models compared to last version:$model_list_all==================
	echo -e "==================== modified models compared to last version:"$model_list_all" ==================" >> $log_file
	
		echo $model_list_all | grep -E "include|bin|build" 
		if [ $? -eq 0 ]
		then
			flagall=0
		fi 
fi


if [ "$flagmmcpnomake" -eq 0 ]
then
	echo "no mmcp cbb need to make ~~~~~~~~~~~~~~~~~~~~~"
else
	echo "some mmcp cbb has been modified, need to make ~~~~~~~~~~~~~~~~~~~~~~~~"
	if [ $flagall -eq 0 ]
	then
		rm -fr $workpath/lib
                if [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu" ]
                then
		        echo ================ current project is delivery_android_Hi3796C_V100_jiangsu ================ 
                         
                        model_list_all="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/camanager thirdparty/ca/caudiadapter cfg/jiangsu_coship_hi3796C_V100"
               
                elif [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu_Client" ]
                then
		        echo ================ current project is delivery_android_Hi3796C_V100_jiangsu_Client================ 
                        
                        model_list_all="dtv kernel protocol codec jsext mediaplayer dtvmx jvm shell guitool graph midp thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/camanager thirdparty/ca/caudiadapter cfg/jiangsu_coship_hi3796C_V100_Client"		
		fi			
	fi	

	echo -e "================ all need to make models:"$model_list_all" ==============" >> $log_file
	echo ================ all need to make models:$model_list_all ==============
	for plat in $plat_list
		do
			case "$plat" in
			Android_Hi3796C_V100)
				###  source $shellbash release $nowmmcpver "$model_list_all" $mdli $plat_list $prj $dir
				source $shellbash debug $nowmmcpver "$model_list_all" $mdli $plat_list $prj $dir
      	;;

			Android_Hi3796C_V100_Client)
                                echo ------------dir:$dir---------------
				source $shellbash release $nowmmcpver "$model_list_all" $mdli $plat_list $prj $dir
				source $shellbash debug $nowmmcpver "$model_list_all" $mdli $plat_list $prj $dir
				;;
		esac
	done
fi	
 
echo $nowmmcpver > $lastmmcpverlog

### premake need to copy binder to product
cd $allpath/delivery/integration/product/jiangsu_android_merge/porting/Android_Hi3796C_V100/coship
##if [ -d binder_src ]
##then
## 	rm -rf binder_src
##fi
##mkdir binder_src
##cd binder_src
##cp /home/hudson/jobs/bindermanager/lastSuccessful/archive/output/bindermanager*.tar.gz .
## tar zxvf bindermanager*.tar.gz

##binder_src_path=$allpath/delivery/integration/product/OTT_DVB/porting/Android_AmS802/coship/binder_src
##binder_des=$allpath/delivery/integration/product/OTT_DVB/porting/Android_AmS802/coship/lib/androidlib

##rm $binder_des/libBinderManager*.a -f
	##cp $binder_src_path/libBinderManager_UDRM_intermediates/libBinderManager_UDRM.a $binder_des/ -f
	##cp $binder_src_path/libBinderManager_UDRM_client_intermediates/libBinderManager_UDRM_client.a $binder_des/ -f
	##cp $binder_src_path/libBinderManager_TF_intermediates/libBinderManager_TF.a $binder_des/ -f
	##cp $binder_src_path/libBinderManager_TF_client_intermediates/libBinderManager_TF_client.a $binder_des/ -f

##cp libBinderManager_TF_client.a $binder_des/
##cp libBinderManager_UDRM_client.a $binder_des/
##cp libBinderManager_TF.a $binder_des/ 
##cp libBinderManager_UDRM.a $binder_des/

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

		mkdir $workpath/lib/mmcp_publish -p

	
	if [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu" ] || [ "$prj" = "delivery_android_Hi3796C_V100_jiangsu_Client" ]
        then
		product_list="jiangsu_android_merge"
		for productname in $product_list
		do
			cd $workpath/integration/product/$productname
                	if [ "$plat_list" = "Android_Hi3796C_V100" ]
                	then
				. setupenv --ia setenv_Android_Hi3796C_V100_debug coship
                	elif [ "$plat_list" = "Android_Hi3796C_V100_Client" ]
			then                          
                                . setupenv --ia setenv_Android_Hi3796C_V100_Client_debug coship
                        fi

			make clean > /dev/null 2>&1
			make >> $log_file_detail  2>&1
			if [ $? -eq 0 ]
			then
                		flag3rdresult=0
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

		fi

		echo -e "================ make publish  end============="
		### copy
        	echo -e "================ now, begin to copy mmcp_publish ==============" >> $log_file
        	cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/. -rf
	fi
  fi

### make over begin to copy
if [ "$flag3rdnomake" -eq 1 ] || [ "$flagmmcpnomake" -eq 1 ]
then
		###cp $workpath/lib $allpath/output -fr 
		cp $workpath/include $workpath/include_release -fr
		cd $workpath/include_release && \
		echo  ======================== find .svn with include and remove them ==========================
		#find -name ".svn"  -exec rm -fr {} \;
		mv  $workpath/include_release  $allpath/output/

		
		## copy to pub
		creattime=`date +%Y%m%d%H%M`
		pubdir=$allpath/output/$creattime\_mmcp$nowmmcpver\_product$now3rdver
		mkdir $pubdir/lib -p
		if [ $? -eq 0 ]
		then
                	cp $workpath/lib $pubdir/ -fr
                	cp $allpath/logs $pubdir/log -fr
			cp $pubdir/lib/mmcp_publish $allpath/output/ -fr
		else
			echo  -e "========================== mkdir public file failed ==========================" >> $log_file
		fi

		## end

 fi

##echo $nowmmcpver > $lastmmcpverlog
echo  ======================== copy now version to laster log $nowmmcpver==========================
#grep "failed"  $log_file
echo  ======================== flag3rdresult= $flag3rdresult ==========================
if [ -f $workpath/lib/Android_Hi3796C_V100/release/libmmcp_ew510*.* ] || [ -f $workpath/lib/Android_Hi3796C_V100/debug/libmmcp_ew510*.* ] && [ $flag3rdresult -eq 0 ]
then
	      echo -e "========================== ew510 make success ==========================" >> $log_file
		echo  -e "========================make ew510 and product success =========================="
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
	echo $nowmmcpver > $lastmmcpverlog
        exit 0
        
else
	echo -e "========================== make failed ==========================" >> $log_file
	echo  -e "========================== make fiiled =========================="
        echo -e "</infoxml>" >> $log_failedinfo
        exit 1
fi







