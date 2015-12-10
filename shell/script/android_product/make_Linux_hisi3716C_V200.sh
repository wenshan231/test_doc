#! /bin/bash
# This script is auto make mmcp  incream
# @author: wanghuanhuan (on 2014/05/6)

prj=$1
dir=$2
plat_list=$3
productname=$4
plat_flag=$5
cfg_name=$6
setenv_name=$7
out_name=$8
evn_config=$9

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
	
		 model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/msc thirdparty\/unionPay/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/cfg/cfg\/$cfg_name/g'`

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

	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/$cfg_name thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc"

fi
echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
echo -e "================ all need to make models:"$model_list" =============="

#########compile all modules###############
for plat in $plat_list
do
	case "$plat" in
		Linux_Hi3716C_V200)
		   source $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir $evn_config
		;;

	esac
done
  
echo $nowmmcpver > $lastmmcpverlog
echo -----write this version to txt,nowmmcpver:$nowmmcpver------------------------

### make over begin to copy

## copy to pub
creattime=`date +%Y%m%d%H%M`

pubdir=/home/hudson/publisher/$prj/$creattime\_mmcp$nowmmcpver\_product$now3rdver
if [ $? -eq 0 ]
then
	cp $workpath/lib $pubdir -fr
else
	echo  -e "========================== mkdir public file failed ==========================" >> $log_file
fi


### make product
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	
	#############开始编译工程###########
	make_workspace=$workpath/integration/product/$productname
	output_path=$make_workspace\/porting/Linux_Hi3716C_V200/coship/exec/Linux_Hi3716C_V200/debug
	cd $make_workspace

	###设置环境变量

if [ "$env_config" != "" ] && [ "$env_config" != "none" ]
       
 then
       . $setenv_name --ia $env_config coship

else
		. $setenv_name --ia setenv_Linux_Hi3716C_V200_debug coship

fi

	make clean
	make  >> $log_file_detail  2>&1
	make bin  >> $log_file_detail  2>&1
	echo -------write version to version file------------------
	version_file=$make_workspace/mmcp_publish/version.log
	echo -e "====================== mmcp_version :$nowmmcpver=====================">> $version_file	
	echo -e "====================== product_version :$now3rdver=====================">> $version_file	

	

	       product_file=`ls $output_path/$out_name`


	cp $allpath/logs $pubdir/log -fr
	if [ "$product_file" == "" ]
	then
		ls $output_path
		echo "------------compile main.out error------------------------"	
		cp -r $output_path/$out_name $pubdir
		exit 1 
	else
		ls $output_path
		echo "-------------compile main.out ok------------------------"	
	
	       	cp -r $output_path/$out_name $pubdir
		exit 0

	fi

	fi
		  
fi
