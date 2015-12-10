# modify @author: xieyue (on 2010/04/15) 
# @author: xieyue (on 2010/02/10)
#! /bin/bash
# This script is auto make mmcp incream
# @author: xieyue (on 2012/04/11)

prj=$1
dir=$2
productname=$3

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
now3rdver=0

lastverlog=/home/hudson/lastver/lastver_$prj.log
lastverlog_cute=/home/hudson/lastver/lastver\_$prj\_cute.log
lastverlog_webkit=/home/hudson/lastver/lastver\_$prj\_webkit.log

cd $allpath/logs
if [ $? -eq 0 ]
then
	rm -f  $allpath/logs/*.*
fi

svnreversion=`head -11 $workpath/.svn/entries | tail -1`

### get cute version
cute_nowver=`head -11 $workpath/cute/.svn/entries | tail -1`
cute_lastver=`cat $lastverlog_cute`

### get webkit version
webkit_nowver=`head -11 $workpath/include/webkit/.svn/entries | tail -1`
webkit_lastver=`cat $lastverlog_webkit`

### if there is 3rd we need to get the 3rd ver
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	now3rdver=`head -11 $workpath/integration/product/$productname/.svn/entries | tail -1`
fi

echo -e "------ `date +%F-%H-%M` $prj begin make reversion $svnreversion ------" >> $log_file
echo -e "------ `date +%F-%H-%M` $prj begin make reversion $svnreversion ------" >> $log_file_detail
echo -e "<tstxml>" > $log_tmp
echo -e "<infoxml>" >> $log_failedinfo

lastver=`cat $lastverlog`
echo "================== mmcp lastversion=$lastver  nowversion=$svnreversion ===================" 
echo "================== cute lastversion=$cute_lastver  nowversion=$cute_nowver ===================" 
echo "================== webkit lastversion=$webkit_lastver  nowversion=$webkit_nowver ===================" 
echo "================== mmcp lastversion=$lastver  nowversion=$svnreversion ==================="  >> $log_file
echo "================== cute lastversion=$cute_lastver  nowversion=$cute_nowver ==================="  >> $log_file
echo "================== webkit lastversion=$webkit_lastver  nowversion=$webkit_nowver ==================="  >> $log_file




if [ "$lastver" -eq 0 ] || [ $webkit_lastver -lt $webkit_nowver ]
then
        flagall=0
else
        cd $workpath
	if [ $prj = "mmcp_hi3716m_yaha" ]
	then
	model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastver:$svnreversion | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
       else
        model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastver:$svnreversion | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi thirdparty\/mis/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
    fi	
if [ $cute_lastver -lt $cute_nowver ]
	then	
		model_list_all="$model_list_all cute"
	fi
	
        echo -e "======================= modified model:"$model_list_all" =======================" >> $log_file
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
          if [ $prj = "mmcp_hi3716m_yaha" ]
        	then
		model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol shell cfg cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1 csmsg easybus recordstream"
   else
                model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol shell cfg ngb cute thirdparty/mis thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"
   fi
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
	
	echo $model_list | grep "ngb"
	echo -e "================= ngb needs to renew ================"  >> $log_file
	if [ $? -eq 0 ]
	then
		echo -e "=================enter ================"  >> $log_file
		cd $workpath/lib/ngbjar
		if [ $? -eq 0 ]
		then
			echo -e "================= begin to copy ngbjar ================"  >> $log_file
			rm $workpath/lib/ngbjar -fr
		fi
        		
		cp $workpath/ngb/lib $workpath/lib/ngbjar -fr
		cd $workpath/lib/ngbjar
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

### if there is 3rd need to make publish
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	if [ "$prj" = "guangdong_hi3716m" ]
	then
	        rm -rf $workpath/lib/mmcp_publish_yinhe
		rm -rf $workpath/lib/mmcp_publish_chuangjia
		cd $workpath/integration/product/$productname
		source ./setupenv yinhe
		make clean
		make 
		make publish
		cp $workpath/integration/product/$productname/mmcp_publish_yinhe $workpath/lib/. -rf

		cd $workpath/integration/product/$productname
		source ./setupenv cj
		make clean
		make 
		make publish
		cp $workpath/integration/product/$productname/mmcp_publish_chuangjia $workpath/lib/. -rf

		flagnomake=1

	fi
fi

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

	cp $workpath/lib $pubdir/lib -fr
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
		baseapp_url=http://10.10.5.46/jsuit/project/广东省/省网/code/BaseApp_HD;
		appversion=$(svn info $baseapp_url | grep "^最后修改的版本: "| grep -Eo '[0-9]+');		
		svn export $baseapp_url baseApp_HD_svn$appversion --username 904795 --password Coship1000
	fi
	
fi

echo -e "</tstxml>" >> $log_tmp
echo $svnreversion > $lastverlog
echo $cute_nowver > $lastverlog_cute
echo $webkit_nowver > $lastverlog_webkit

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
