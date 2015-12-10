#! /bin/bash
# This script is auto make mmcp  incream
# @author: wanghuanhuan (on 2014/05/6)


prj=$1
dir=$2
plat_list=$3
productname=$4
plat_flag=$5

shellbash=$(pwd)/makecbb_hisi.sh

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
lastmmcpver=`cat $lastmmcpverlog`
nowmmcpver=`head -11 $workpath/.svn/entries | tail -1`
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
	if [ "$prj" = "changsha_Android_Hi3716C_V200" ] 
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/changsha_coship_hi3716C_V200/g' | sed 's/thirdparty/thirdparty\/unionPay/g' | sed 's/porting//g'`
	elif [ "$prj" = "changsha_Android_Hi3716C_V200_Client" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg/cfg\/changsha_coship_hi3716C_V200_Client/g' | sed 's/thirdparty/thirdparty\/unionPay/g' | sed 's/porting//g'`
	elif [ "$prj" = "topway_Android_Hi3716C_V200" ]
	then
		 model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/cfg/cfg\/topway_coship_hi3716C_V200/g'`
	elif [ "$prj" = "topway_Android_Hi3716C_V200_Client" ] 
	then
		 model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/jvm//g' | sed 's/porting//g' | sed 's/cfg/cfg\/topway_coship_hi3716C_V200_Client/g'`
        elif [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] ||[ "$prj" = "yixing_Android_Hi3716C_V200" ]
	then
		 model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/cfg/cfg\/yixing_coship_hi3716C_V200/g'`
	elif [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ] || [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ]
	then
		 model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/jvm//g' | sed 's/porting//g' | sed 's/cfg/cfg\/yixing_coship_hi3716C_V200_Client/g'`
	elif [ "$prj" = "wuxi_Android_Hi3716C_V200" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/cfg/cfg\/wuxi_coship_AndroidHi3716CV200/g'`
	elif [ "$prj" = "tianjin_Android_Hi3716C_V200" ] 
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib//g' | sed 's/cfg/cfg\/tianjin_ottdvb_hi3716C_V200/g' | sed 's/thirdparty/thirdparty\/unionPay/g'`
	elif [ "$prj" = "tianjin_Android_Hi3716C_V200_Client" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib//g' | sed 's/cfg/cfg\/tianjin_ottdvb_hi3716C_V200_Client/g' | sed 's/thirdparty/thirdparty\/unionPay/g'`
	fi
fi

echo $model_list_all | grep -E "include|bin|build" 
if [ $? -eq 0 ]
then
	flagall=0
else
      model_list=$model_list_all
fi

if [ $flagall -eq 0 ]
then
  rm -fr $workpath/lib
  if [ "$prj" = "changsha_Android_Hi3716C_V200" ]
  then
	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx jvm shell guitool jvm graph thirdparty/unionPay cfg/changsha_coship_hi3716C_V200"
  elif [ "$prj" = "changsha_Android_Hi3716C_V200_Client" ]
  then
	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool jvm graph thirdparty/unionPay cfg/changsha_coship_hi3716C_V200_Client"
  elif [ "$prj" = "topway_Android_Hi3716C_V200" ]
  then
      model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/topway_coship_hi3716C_V200 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
  elif [ "$prj" = "topway_Android_Hi3716C_V200_Client" ]
  then
	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool cfg/topway_coship_hi3716C_V200_Client thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
  elif [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] || [ "$prj" = "yixing_Android_Hi3716C_V200" ]
  then
      model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/yixing_coship_hi3716C_V200 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
  elif [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ] || [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ]
  then
	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool cfg/yixing_coship_hi3716C_V200_Client thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
  elif  [ "$prj" = "wuxi_Android_Hi3716C_V200" ]
  then
	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/wuxi_coship_AndroidHi3716CV200 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
  elif [ "$prj" = "tianjin_Android_Hi3716C_V200" ]
  then
	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx jvm shell guitool jvm graph thirdparty/unionPay cfg/tianjin_ottdvb_hi3716C_V200"
  elif [ "$prj" = "tianjin_Android_Hi3716C_V200_Client" ]
  then
	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool jvm graph thirdparty/unionPay cfg/tianjin_ottdvb_hi3716C_V200_Client"
  fi
fi

echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
echo -e "================ all need to make models:"$model_list" =============="


#########compile all modules###############
for plat in $plat_list
do
	case "$plat" in
		Android_Hi3716C_V200)
		 #if [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] || [ "$prj" = "yixing_Android_Hi3716C_V200" ] || [ "$prj" = "wuxi_Android_Hi3716C_V200" ] || [ "$prj" = "topway_Android_Hi3716C_V200" ]
		 #then
			source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
		 #else		
		 #	source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
		 #fi
		;;
		Android_Hi3716C_V200_Client)
		   #if [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ] || [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ] || [ "$prj" = "topway_Android_Hi3716C_V200_Client" ]
		   #then
			source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
		   #else		
		   #    source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
		   #fi
			;;				
	esac
done
  
echo $nowmmcpver > $lastmmcpverlog
echo -----write this version to txt,nowmmcpver:$nowmmcpver------------------------

### make over begin to copy

## copy to pub
creattime=`date +%Y%m%d%H%M`
pubdir=/home/hudson/publisher/$prj/$creattime\_mmcp$nowmmcpver\_product$now3rdver
mkdir $pubdir/lib -p
if [ $? -eq 0 ]
then
	cp $workpath/lib $pubdir/lib -fr
	##中间件版本管理
	cd $workpath
	svn info > $pubdir/mmcp.txt
else
	echo  -e "========================== mkdir public file failed ==========================" >> $log_file
fi


### make product
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	
	### cpoy all to output
	cd $workpath
	rm -fr output 
	mkdir output output/mmcp output/binder output/510apk output/mmcp_publish

	### cpoy 510apk
	mmcp_510APK_path=/home/hudson/public_96.200/com.coship.mmcp510.merge/lastSuccessful/archive/output
	cp $mmcp_510APK_path/com.coship.mmcp510.merge*.tar.gz  $workpath/output/510apk/
  
	### cfg和510源路径
	#if [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] || [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ] || [ "$prj" = "yixing_Android_Hi3716C_V200" ] || [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ]|| [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ]|| [ "$prj" = "yixing_Android_Hi3716C_V200_Client" ] || [ "$prj" = "topway_Android_Hi3716C_V200" ]|| [ "$prj" = "topway_Android_Hi3716C_V200_Client" ]
	#then
		mmcp_autocopy_path=$workpath/lib/Android_Hi3716C_V200/debug
		
	#else
	#	mmcp_autocopy_path=$workpath/lib/Android_Hi3716C_V200/release
		
	#fi
	
	### cfg和510要拷贝到的路径
	
	  echo -----productname:$productname-------------
	  mmcp_dist=$workpath\/integration/product/$productname/mmcp_lib/$plat
  
	  ###先删除工程原来的cfg和ew510.a
	  rm $mmcp_dist/libcfg*_hi3716C_V200*.a
	  rm $mmcp_dist/libmmcp_ew510*.a
	  cp -f $mmcp_autocopy_path/libcfg*_hi3716C_V200*.a   $mmcp_dist
	  cp -f $mmcp_autocopy_path/libcfg*_hi3716C_V200*.a   $workpath/output/mmcp
	  cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $mmcp_dist
	  cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $workpath/output/mmcp
	
	### copy binder to output && product
	bind_autocopy_path=/home/hudson/public_96.200/bindermanager/lastSuccessful/archive/output
	bind_dist=$workpath\/integration/product/$productname/porting/Android_Hi3716C_V200/coship/lib/androidlib
	if [ "$prj" != "tianjin_Android_Hi3716C_V200" ] && [ "$prj" != "tianjin_Android_Hi3716C_V200_Client" ]
	then
		echo -----prj=$prj----------------
		cd $bind_autocopy_path
		cd $workpath && rm -fr tmp && mkdir  tmp
		cp $bind_autocopy_path/bindermanager*.tar.gz $workpath/output/binder
		cp $bind_autocopy_path/bindermanager*.tar.gz $workpath/tmp
		cd $workpath/tmp && tar -xvf bindermanager*.tar.gz  
		cd $workpath/tmp &&  filelist_del=`find ./ -name "*provider.a"` && rm -f $filelist_del &&  filelist=`find ./ -name "*.a"` 
		rm $bind_dist/libBinderManager*.a
		cp -f $workpath/tmp/$filelist $bind_dist/
	  fi
		## copy all to puhlisher
		cp -r $workpath/output/binder $pubdir
		cp -r $workpath/output/mmcp $pubdir
		echo -----copy ok----------------
      

	#############开始编译工程###########
	make_workspace=$workpath/integration/product/$productname
	output_path=$make_workspace\/mmcp_lib/Android_Hi3716C_V200
	cd $make_workspace

	###设置环境变量
	if [ "$prj" = "wuxi_Android_Hi3716C_V200" ]
	then
		. setupenv --ia setenv_Android_Hi3716C_V200_Citv_debug coship
	else
		. setupenv --ia setenv_$plat_flag\_debug coship
	fi

	rm -rf $make_workspace/mmcp_publish
	make clean
	make  >> $log_file_detail  2>&1
	make bin  >> $log_file_detail  2>&1
	chmod 777 $make_workspace/porting/Android_Hi3716C_V200/coship/script/make_publish.sh
	make publish  >> $log_file_detail  2>&1
	echo -------write version to version file------------------
	version_file=$make_workspace/mmcp_publish/version.log
	echo -e "====================== mmcp_version :$nowmmcpver=====================">> $version_file	
	echo -e "====================== product_version :$now3rdver=====================">> $version_file	

	output_path=$make_workspace/mmcp_publish
	product_file=`ls $output_path/libmmcp_product*.so`
	cp $allpath/logs $pubdir/log -fr
	if [ "$product_file" == "" ]
	then
		ls $output_path
		echo "------------compile product.so error------------------------"	
		cp -r $make_workspace/mmcp_publish $pubdir
		exit 1 
	else
		ls $output_path
		echo "-------------compile product.so ok------------------------"	
		
		##中间件版本管理
	   cd $make_workspace
	   svn info >> $pubdir/mmcp.txt
	   mv $pubdir/mmcp.txt $make_workspace/mmcp_publish
	  
		cp -r $make_workspace/mmcp_publish $pubdir
		rm -rf /home/hudson/publisher/$prj/mmcp_publish
		cp -r $make_workspace/mmcp_publish /home/hudson/publisher/$prj 
		exit 0
	fi
		  
fi