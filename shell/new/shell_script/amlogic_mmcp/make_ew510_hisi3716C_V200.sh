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
	elif [ "$prj" = "jiangsu_Android_Hi3716C_V200" ]
	then
	  model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'| sed 's/cfg/cfg\/yixing_coship_hi3716C_V200/g'`
	elif [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ]
	then
	  model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/amcp thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'| sed 's/cfg/cfg\/yixing_coship_hi3716C_V200_Client/g'`
	else
	  model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/thirdparty/thirdparty\/unionPay/g' | sed 's/porting//g'`
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
	    model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx jvm shell guitool graph thirdparty/unionPay cfg/changsha_coship_hi3716C_V200"
	elif [ "$prj" = "changsha_Android_Hi3716C_V200_Client" ]
	then
	   	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool graph thirdparty/unionPay cfg/changsha_coship_hi3716C_V200_Client"
	elif [ "$prj" = "jiangsu_Android_Hi3716C_V200" ]
	then
	    model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool jvm  cfg/yixing_coship_hi3716C_V200 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
	elif [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ]
	then
	     model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool jvm cfg/yixing_coship_hi3716C_V200 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"
	else
	   	model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool graph thirdparty/unionPay"
	fi
fi

echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
echo -e "================ all need to make models:"$model_list" =============="


#########compile all modules###############
for plat in $plat_list
		do
			case "$plat" in
			Android_Hi3716C_V200)
			  if [ "$prj" = "jiangsu_Android_Hi3716C_V200" ]
			  then
			     source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
			  else		
				   source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
			  fi
      	;;
			Android_Hi3716C_V200_Client)
			   if [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ]
			   then
			       source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
		    	else		
				     source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
			    fi
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
                	cp $allpath/logs $pubdir/log -fr
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
 
  ### copy binder to output  
  bind_autocopy_path=/home/hudson/public_96.200/bindermanager/lastSuccessful/archive/output
	bind_dist=$workpath\/integration/product/$productname/porting/Android_Hi3716C_V200/coship/lib/androidlib
	cd $bind_autocopy_path
	cd $workpath && rm -fr tmp && mkdir  tmp
	cp $bind_autocopy_path/bindermanager*.tar.gz $workpath/output/binder
	cp $bind_autocopy_path/bindermanager*.tar.gz $workpath/tmp
	cd $workpath/tmp && tar -xvf bindermanager*.tar.gz  
	cd $workpath/tmp &&  filelist_del=`find ./ -name "*provider.a"` && rm -f $filelist_del &&  filelist=`find ./ -name "*.a"` 
	rm $bind_dist/libBinderManager*.a
	cp -f $workpath/tmp/$filelist $bind_dist/
	
  ### cpoy 510apk
	mmcp_510APK_path=/home/hudson/public_96.200/com.coship.mmcp510.merge/lastSuccessful/archive/output
	cp $mmcp_510APK_path/com.coship.mmcp510.merge*.tar.gz  $workpath/output/510apk/
  
  ### cfg和510源路径
  if [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] || [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ]
	then
	    mmcp_autocopy_path=$workpath/lib/Android_Hi3716C_V200/debug
	else
      mmcp_autocopy_path=$workpath/lib/Android_Hi3716C_V200/release
  fi
  ### cfg和510要拷贝到的路径
  mmcp_dist=$workpath\/integration/product/$productname/mmcp_lib/$plat
  
  ###先删除工程原来的cfg和ew510.a
  rm $mmcp_dist/libcfg*_hi3716C_V200*.a
  rm $mmcp_dist/libmmcp_ew510*.a
  cp -f $mmcp_autocopy_path/libcfg*_hi3716C_V200*.a   $mmcp_dist
  cp -f $mmcp_autocopy_path/libcfg*_hi3716C_V200*.a   $workpath/output/mmcp
  cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $mmcp_dist
  cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $workpath/output/mmcp
   
  ## copy all to puhlisher
	cp -r $workpath/output/binder $pubdir
	cp -r $workpath/output/mmcp $pubdir
	echo -----copy ok----------------
	
#############开始编译工程###########
	make_workspace=$workpath/integration/product/$productname
  output_path=$make_workspace\/mmcp_lib/Android_Hi3716C_V200
	cd $make_workspace
	
	###设置环境变量
	if [ "$prj" = "jiangsu_Android_Hi3716C_V200" ] || [ "$prj" = "jiangsu_Android_Hi3716C_V200_Client" ]
	then
	  . setupenv --ia setenv_$plat_flag\_debug coship
	else
	  . setupenv --ia setenv_$plat_flag\_release coship
	fi
	
	make clean
	if [ "$prj" = "changsha_Android_Hi3716C_V200" ]|| [ "$prj" = "changsha_Android_Hi3716C_V200_Client" ]
	then
	   make USE_PRODUCT_LIB=y
	else 
	  make
	  make bin
	  chmod 777 $make_workspace/porting/Android_Hi3716C_V200/coship/script/make_publish.sh
	  rm -rf $make_workspace/mmcp_publish
  	make publish
    echo -------write version to version file------------------
	  version_file=$make_workspace/mmcp_publish/version.log
    echo -e "====================== mmcp_version :$nowmmcpver=====================">> $version_file	
    echo -e "====================== product_version :$now3rdver=====================">> $version_file	
 fi

	if [ "$prj" = "changsha_Android_Hi3716C_V200" ]
	then
			echo "begin to make bin "
			make bin
			cp $make_workspace/bin/libmmcpdata*.so  $workpath/output/mmcp_publish/
			echo " make bin end "
	fi
	
	if [ "$prj" = "changsha_Android_Hi3716C_V200" ]|| [ "$prj" = "changsha_Android_Hi3716C_V200_Client" ]
	then
			if [ -f $output_path/libmmcp_product*.so ] 
			then
				echo "--------------------compile .so ok------------------------"
				version_file=$workpath/output/mmcp_publish/version.log
        echo -e "====================== mmcp_version :$nowmmcpver=====================">> $version_file	
        echo -e "====================== product_version :$now3rdver=====================">> $version_file	
        
				cp $output_path/libmmcp_product*.so  $workpath/output/mmcp_publish/
				cp -r $workpath/output/mmcp_publish $pubdir
				
				##将最新的库拷贝出去,，便于做集成
				 rm -rf /home/hudson/publisher/$prj/mmcp_publish
				 cp -r $workpath/output/mmcp_publish /home/hudson/publisher/$prj 
				 
				exit 0
			else
					echo "compile .so error"
				exit 1
			fi
	fi
	
	output_path=$make_workspace/mmcp_publish
	product_file=`ls $output_path/libmmcp*.so`
  if [ "$product_file" == "" ]
	then
	      ls $output_path
				echo "----------13---------compile .so error------------------------"	
				cp -r $make_workspace/mmcp_publish $pubdir
				rm -rf /home/hudson/publisher/$prj/mmcp_publish
				cp -r $make_workspace/mmcp_publish /home/hudson/publisher/$prj
				exit 0 
	else
	      ls $output_path
	      echo "---------------13-----compile .so ok------------------------"	
		    cp -r $make_workspace/mmcp_publish $pubdir
				rm -rf /home/hudson/publisher/$prj/mmcp_publish
				cp -r $make_workspace/mmcp_publish /home/hudson/publisher/$prj 
				exit 1
	fi
		  
fi