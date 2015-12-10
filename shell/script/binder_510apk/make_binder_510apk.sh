#! /bin/bash

# This script is auto make 510apk & binder
# @author: xieyue (on 2013/10/20)

prj=$1

allpath=/home/hudson/project/$prj
workpath=$allpath/trunk
buildlog=$allpath/logs/build_binder_and_apk.log


apksvn_last=`cat /home/hudson/lastver/lastver_apksvn.log`
bindersvn_last=`cat /home/hudson/lastver/lastver_bindersvn.log`
echo "================== apksvn_last:$apksvn_last                 bindersvn_last:$bindersvn_last ===================" 

echo "" > $buildlog

apksvn=`head -11 $workpath/app_src/com.coship.mmcp510.merge/.svn/entries | tail -1`
bindersvn=`head -11 $workpath/ext_src/.svn/entries | tail -1`
echo "================== apksvn:$apksvn			bindersvn:$bindersvn ===================" 
echo "================== apksvn:$apksvn                 bindersvn:$bindersvn ===================" >> $buildlog

if [ $apksvn_last -eq $apksvn ] && [ $bindersvn_last -eq $bindersvn ]
then
	echo ================= no need to make exit now =====================
	exit 0
fi

### rm last build result
rm $allpath/stp_package_publish/mstar6a801 -rf

cd $allpath/stp_integration
./build_mmcp_dtvmx_binder_510apk.sh stp_envfile/setenv_Android_6A801.cfg >> $buildlog
if [ $? -eq 0 ]
then
	echo -e "----------- binder_apk make success --------\n"
else
	echo -e "----------- binder_apk make failed --------\n"
	exit 1
fi


echo $apksvn > $allpath/logs/apksvn.log
echo $bindersvn > $allpath/logs/bindersvn.log
echo $apksvn > /home/hudson/lastver/lastver_apksvn.log
echo $bindersvn > /home/hudson/lastver/lastver_bindersvn.log

echo ======================= make end, begin to copy ===================================
creattime=`date +%Y%m%d%H%M`

### begin to copy
pubdir=/home/hudson/publisher/$prj/$creattime\_apksvn$apksvn\_bindersvn$bindersvn
mkdir -p $pubdir
cp $allpath/stp_package_publish/mstar6a801 $pubdir -fr
cp $allpath/logs $pubdir -fr

