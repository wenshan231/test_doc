#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: xieyue (on 2010/06/01) 

prj=$1
dir=$2
plat_list=$3
productname=$4

shellbash=$(pwd)/makecbb_hisi.sh


allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

rm $allpath/logs -rf
rm $allpath/output -rf
rm $workpath/lib -rf
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
##°æ±¾ºÅ¹ÜÀí
cd $workpath
svn info >$allpath/output/mmcp.txt


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


#########compile all modules###############
echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
echo -e "================ all need to make models:"$model_list" =============="
for plat in $plat_list
		do
			case "$plat" in
			Android_Hi3716C_V200)
				model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx jvm shell guitool graph thirdparty/unionPay cfg/taiwan_hi3716C_V200 cfg/ottdvb_hi3716C_V200 cfg_dvbott/ottdvb_hi3716C_V200_TF"
				#source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
      	;;
			Android_Hi3716C_V200_Client)
				model_list="dtv kernel protocol codec midp jsext mediaplayer dtvmx shell guitool graph thirdparty/unionPay cfg/taiwan_hi3716C_V200_client cfg/ottdvb_hi3716C_V200_client cfg_dvbott/ottdvb_hi3716C_V200_client_TF"
				#source $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				;;
				
		esac
done

 
### make over begin to copy

		cp $workpath/lib $allpath/output -fr 
		cp $workpath/include $workpath/include_release -fr
		cd $workpath/include_release && \
		echo  ======================== find .svn with include and remove them ==========================
		#find -name ".svn"  -exec rm -fr {} \;
		mv  $workpath/include_release  $allpath/output/

		
		## copy to pub
		creattime=`date +%Y%m%d%H%M`
		pubdir=/home/hudson/publisher/$prj/$creattime\_mmcp$nowmmcpver\_product$now3rdver
		mkdir $pubdir/lib -p
		if [ $? -eq 0 ]
		then
                	cp $allpath/output/* $pubdir/lib -fr
                	cp $allpath/logs $pubdir/log -fr
		else
			echo  -e "========================== mkdir public file failed ==========================" >> $log_file
		fi

		## end




   
