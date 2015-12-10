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
			model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool graph thirdparty/unionPay cfg/taiwan_hi3716C_V200"
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
				#source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				#source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
      	;;
			Android_Hi3716C_V200_Client)
				#source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				#source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				;;
				
		esac
	done
fi	
 
