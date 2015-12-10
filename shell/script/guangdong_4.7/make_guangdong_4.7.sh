# modify @author: xieyue (on 2010/04/15) 
# @author: xieyue (on 2010/02/10)
#! /bin/bash
# This script is auto make mmcp incream
# @author: xieyue (on 2012/04/11)

prj=$1
dir=$2

shellbash_hi3716h=$(pwd)/makecbb_hi3716h.sh
shellbash_hi3716m=$(pwd)/makecbb_hi3716m.sh

allpath=/home/hudson/project/$prj
workpath=$allpath/$dir
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
log_version=$allpath/logs/make_$prj\_version.log
#log_releasenote=$allpath/logs/$prj\_releasenote.log

if [ $allpath == "" ] || [ $workpath == "" ]
then
	echo directory is null!!!!!!!exit now!!!!!!
	exit 1
fi

mdli=0
flag=0
flagall=1
flagnomake=1
mdli=0

lastverlog=/home/hudson/lastver/lastver_$prj.log

cd $allpath/logs
if [ $? -eq 0 ]
then
	rm -f  $allpath/logs/*.*
fi

svnreversion=`head -11 $workpath/.svn/entries | tail -1`


okmsg="[CC]Result of $prj make success revision $svnreversion"
errormsg="[CC]Result of $prj make failed revision $svnreversion"

echo -e "------ `date +%F-%H-%M` $prj begin make reversion $svnreversion ------" >> $log_file
echo -e "------ `date +%F-%H-%M` $prj begin make reversion $svnreversion ------" >> $log_file_detail
echo -e "<tstxml>" > $log_tmp
echo -e "<infoxml>" >> $log_failedinfo

lastver=`cat $lastverlog`
echo "================== mmcp lastversion=$lastver  nowversion=$svnreversion ===================" 




if [ "$lastver" -eq 0 ]
then
        flagall=0
else
        cd $workpath
        model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastver:$svnreversion | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`

				echo -e "======================= modified models:"$model_list_all" ======================="
        echo -e "======================= modified models:"$model_list_all" =======================" >> $log_file
        if [ "$model_list_all" = "" ]
        then
                echo "only porting integration changes and not build" >> $log_file
                flagnomake=0
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

if [ "$flagnomake" -eq 0 ]
then
        echo "no need to make,exit now ~~~~~~~~~~~~~~~~~~"
else
        echo "some model has been modified, need to make ~~~~~~~~~~~~~~~~~~"
        if [ $flagall -eq 0 ]
        then
                cd $workpath/lib
		if [ $? -eq 0 ]
		then
			rm -fr $workpath/lib/*
		fi

                model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol shell cfg cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"
	fi


	echo -e "======================= all need to make models:"$model_list" ======================="
	echo ==================== hi3716H release ============================
	bash $shellbash_hi3716h $svnreversion "$model_list" $mdli $prj $dir release
	echo ==================== hi3716M release ============================
	bash $shellbash_hi3716m $svnreversion "$model_list" $mdli $prj $dir release
        echo ==================== hi3716H debug ============================
        bash $shellbash_hi3716h $svnreversion "$model_list" $mdli $prj $dir debug
        echo ==================== hi3716M debug ============================
        bash $shellbash_hi3716m $svnreversion "$model_list" $mdli $prj $dir debug

	echo $model_list | grep "dtvmx"
	echo -e "================= dtvmx needs to renew ================"  >> $log_file
	if [ $? -eq 0 ]
	then
		echo -e "=================enter ================"  >> $log_file
		cd $workpath/lib/dtvmxjar
		if [ $? -eq 0 ]
		then
			echo -e "================= begin to copy dtvmxjar ================"  >> $log_file
			rm $workpath/lib/dtvmxjar -fr
		fi
        		
		cp $workpath/dtvmx/lib $workpath/lib/dtvmxjar -fr
		cd $workpath/lib/dtvmxjar
		find -name ".svn" | xargs rm -fr
	fi

fi


cd $workpath
odate=`date +%Y-%m-%d --date '7 days ago'`
pdate=`date +%Y-%m-%d`

### write releasenotes 
#svn log -r {$odate}:{$pdate} > svnall.log
#grep -B 4 "fix_bug" svnall.log > svn1.log
#grep -v ^$ svn1.log > svn2.log
#sed -i '/^--/d' svn2.log
#sed -i '/^bug_level/d' svn2.log
#sed '/fix_bug/a\---------------------------------------------------' svn2.log > $log_releasenote


if [ "$flagnomake" -eq 1 ]
then
	echo ======================= begin to copy ===================================
	creattime=`date +%Y%m%d%H%M`
	### only save the latest 3 files
	#cd /home/jiangfeng/mmcp_publishers/Guangdong_ew600_outputs
	#fileall=`ls -rt`
	#filesave=`ls -rt | tail -n3`
	#filedel=`ls -rt | grep -v "$filesave"`
	#rm -rf $filedel

	### begin to copy
	pubdir=/home/hudson/publisher/$prj/$creattime\_$svnreversion
	mkdir -p $pubdir

	cp $workpath/lib/ $pubdir/lib -fr
	cp $workpath/include/ $pubdir/lib/include_release -fr
	cd $pubdir/lib/include_release
	if [ $? -eq 0 ]
	then
		echo -e "======================= find .svn with include and remove them ======================="
		find -name ".svn" | xargs rm -fr
	fi
	
	cp $allpath/logs $pubdir/logs -rf
	cp $workpath/cute/build_cute.log $pubdir/logs/. -f

	### baseapp
	cd $pubdir/lib/dtvmxjar/resident
	if [ $? -eq 0 ]
	then
		echo -e "======================= svn export BaseApp_HD ======================="
		appversion=$(svn info http://10.10.5.46/jsuit/project/%E5%B9%BF%E4%B8%9C%E7%9C%81/%E7%9C%81%E7%BD%91/code/BaseApp_HD | grep "^最后修改的版本: "| grep -Eo '[0-9]+');		
		svn export http://10.10.5.46/jsuit/project/%E5%B9%BF%E4%B8%9C%E7%9C%81/%E7%9C%81%E7%BD%91/code/BaseApp_HD baseApp_HD_svn$appversion --username 904795 --password Coship1000
	fi
	
fi

echo -e "</tstxml>" >> $log_tmp
echo $svnreversion > $lastverlog

#cd $workpath
#svn revert -R *


grep "failed"  $log_file
if [ $? -eq 0 ]
then
        echo -e "</infoxml>" >> $log_failedinfo
        exit 1

else
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
        exit 0
fi
