
#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: xieyue (on 2010/06/01) 

prj=$1
dir=$2
plat_list=$3

shellbash=$(pwd)/makecbb.sh

allpath=/home/hudson/project/$prj
workpath=$allpath/$dir
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
log_svninfo=$allpath/logs/svnlog_info.log

mdli=0
flag=0
flagall=1
flagmmcpnomake=1
mdli=0
flagdebug=0
libtype=ew510
copyall=1
cppcheckflag=0

lastmmcpverlog=/home/hudson/lastver/lastver\_$prj.log


if [ -d $allpath/logs ]
then
	rm $allpath/logs -rf
	mkdir $allpath/logs
fi
if [ -d $allpath/output ]
then
        rm $allpath/output -rf
        mkdir $allpath/output
fi


timemake=`date +%F-%H-%M`

nowmmcpver=`head -11 $workpath/.svn/entries | tail -1`
lastmmcpver=`cat $lastmmcpverlog`
echo -e "====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================" >> $log_file
echo ====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================



okmsg="[CC]Result of $prj make success revision $nowmmcpver"
errormsg="[CC]Result of $prj make failed revision $nowmmcpver"
echo -e "<tstxml>" > $log_tmp
echo -e "<infoxml>" > $log_failedinfo


if [ "$lastmmcpver" -eq 0 ]
then 
	flagall=0
else
	cd $workpath
	if [ "$prj" = "topway_hi3716c_v200" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/codec/codec codec\/muxer/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/cfg/cfg\/topway_android_hi3716C_v200/g' | sed 's/pvr//g' | sed 's/porting//g'`
	elif [ "$prj" = "topway_hi3716c_v200_client" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/jvm//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/cfg/cfg\/topway_android_hi3716C_v200_Client/g' | sed 's/pvr//g' | sed 's/porting//g'`
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
				if [ "$prj" == "topway_hi3716c_v200" ]
				then
					model_list=`echo  $model_list_all | sed 's/jvm//g' | sed 's/dtvmx/dtvmx jvm/g'`								
				fi
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
	if [ $flagall -eq 0 ]
	then
		rm -fr $workpath/lib
		if [ "$prj" = "topway_hi3716c_v200" ]
		then
			model_list="dtvmx shell codec codec/muxer dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay cfg/topway_android_hi3716C_v200"		
		elif [ "$prj" = "topway_hi3716c_v200_client" ]
		then
			model_list="dtv kernel protocol codec guitool graph jsext mediaplayer dtvmx shell cfg/topway_android_hi3716C_v200_Client"		
		fi	
	fi
	
	echo $model_list_all | grep "dtvmx" 
	if [ $? -eq 0 ]
	then
		cd $workpath/lib
		rm -fr dtvmxjar*
		rm -fr dtvmx.javadoc
	fi

	echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
	echo -e "================ all need to make models:"$model_list" =============="
	for plat in $plat_list
		do
			case "$plat" in

			Android_Hi3716C_V200)
				bash $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				bash $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
			;;

			Android_Hi3716C_V200_Client)
				bash $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				bash $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
			;; 
		esac
	done
echo =======================================1==========================
	cp $workpath/dtvmx/lib $workpath/lib/dtvmxjar -fr
	cd $workpath/lib/dtvmxjar
	if [ $? -eq 0 ]
	then
		find -name ".svn" | xargs rm -rf
	fi


fi	
 
echo =======================================2==========================


cp $workpath/lib $allpath/output -fr 
cp $workpath/include $workpath/include_release -fr
cd $workpath/include_release && \
echo  ======================== find .svn with include and remove them ==========================
find -name ".svn"  -exec rm -fr {} \;
mv  $workpath/include_release  $allpath/output/

echo =======================================3==========================

## copy to pub
creattime=`date +%Y%m%d%H%M`
mkdir /home/hudson/publisher/$prj/$creattime\_$nowmmcpver/lib -p
if [ $? -eq 0 ]
then
	cp $allpath/output/* /home/hudson/publisher/$prj/$creattime\_$nowmmcpver/lib -fr
	cp $allpath/logs /home/hudson/publisher/$prj/$creattime\_$nowmmcpver/log -fr
else
	echo  -e "========================== mkdir public file failed ==========================" >> $log_file
fi


echo $nowmmcpver > $lastmmcpverlog

#grep "failed"  $log_file
if [ "$libtype" = "ew510" ] && [ -f $workpath/lib/Android_Hi3716C_V200/release/libmmcp_ew510*.* ]
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







