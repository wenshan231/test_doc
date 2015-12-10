#! /bin/bash
# This script is auto make mmcp incream
# @author: xieyue (on 2012/04/11)

prj=$1
dir=$2
plat=$3


shellbash=$(pwd)/makecbb.sh
shellbash_gd_hi3716m=$(pwd)/makecbb_gd_hi3716m.sh

allpath=/home/hudson/project/$prj
workpath=$allpath/$dir
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log


if [ $allpath == "" ] || [ $workpath == "" ]
then
	echo directory is null!!!!!!!exit now!!!!!!
	exit 1
fi

mdli=0
flag=0
flagall=1
mdli=0

lastverlog_mmcp=/home/hudson/lastver/lastver_$prj.log
lastverlog_cute=/home/hudson/lastver/lastver\_$prj\_cute.log
lastverlog_webkit=/home/hudson/lastver/lastver\_$prj\_webkit.log
if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ] || [ "$prj" = "sichuan_4.7_osg" ] || [ "$prj" = "shanxi_mstar_7c51g" ]
then
	lastverlog_third=/home/hudson/lastver/lastver\_$prj\_third.log
fi
	
### get mmcp version
mmcp_nowver=`head -11 $workpath/.svn/entries | tail -1`
mmcp_lastver=`cat $lastverlog_mmcp`
### get cute version
cute_nowver=`head -11 $workpath/cute/.svn/entries | tail -1`
cute_lastver=`cat $lastverlog_cute`

### get webkit version
webkit_nowver=`head -11 $workpath/include/webkit/.svn/entries | tail -1`
webkit_lastver=`cat $lastverlog_webkit`
if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ]|| [ "$prj" = "shanxi_mstar_7c51g" ]
then
	### get project version
	third_nowver=`head -11 $workpath/integration/product/shanxi/.svn/entries | tail -1`
elif [ "$prj" = "sichuan_4.7_osg" ] 
then
	third_nowver=`head -11 $workpath/integration/product/sichuan/.svn/entries | tail -1`
fi

#cd $allpath/logs
#if [ $? -eq 0 ]
#then
	rm -rf  $allpath/logs
	mkdir $allpath/logs
#fi



echo "================== mmcp lastversion=$mmcp_lastver  nowversion=$mmcp_nowver ===================" 
echo "================== mmcp lastversion=$mmcp_lastver  nowversion=$mmcp_nowver ==================="  >> $log_file
echo "================== cute lastversion=$cute_lastver  nowversion=$cute_nowver ===================" 
echo "================== cute lastversion=$cute_lastver  nowversion=$cute_nowver ==================="  >> $log_file
echo "================== webkit lastversion=$webkit_lastver  nowversion=$webkit_nowver ===================" 
echo "================== webkit lastversion=$webkit_lastver  nowversion=$webkit_nowver ==================="  >> $log_file
if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ] || [ "$prj" = "sichuan_4.7_osg" ]|| [ "$prj" = "shanxi_mstar_7c51g" ]
then
	echo "================== project nowversion=$third_nowver ===================" 
	echo "================== project nowversion=$third_nowver ==================="  >> $log_file
fi

if [ "$mmcp_lastver" -eq 0 ] || [ $webkit_lastver -lt $webkit_nowver ]
then
        flagall=0
else
        cd $workpath
        if [ "$prj" = "ew600_4.7_osg" ]
        then
        	model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/cfg//g' | sed 's/integration//g' | sed 's/mediaplayer/mediaplayer mediaplayer\/ffmpeg/g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
  elif [ "$prj" = "sichuan_ew600_MSD7C51G" ]
  	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi/g'`
	elif [ "$prj" = "guangdong_hi3716m" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi thirdparty\/mis/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
	elif [ "$prj" = "sichuan_4.7_osg" ] ||  [ "$prj" = "hubei_gcable_hi3716m" ] ||  [ "$prj" = "hubei_ngb_hi3716m" ] ||  [ "$prj" = "hubei_ngb_hi3716m" ] 
	then
        	model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/mediaplayer/mediaplayer mediaplayer\/ffmpeg/g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
	elif [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ] 
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/integration//g' | sed 's/QtApp//g' | sed 's/QtMicrowin//g' | sed 's/webkitPlatform//g' | sed 's/webkitshell//g' | sed 's/thirdparty/thirdparty\/ca\/dvn thirdparty\/ca\/tfcdcasa thirdparty\/ca\/shumashixun_multi thirdparty\/ca\/shumashixun_5200/g' | sed 's/share/share\/udi2\/hdicommon\/udi2_caadapter share\/udiplus share\/udi2\/lcsp_udi1/g'`
		echo $model_list_all | grep "jsext"
	        if [ $? -eq 0 ]
	        then
	                echo jsext exits~~~~~~~~
	        else
	                model_list_all="$model_list_all jsext"
	        fi
	elif [ "$prj" = "ew600_wuhan_hi3716H" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $mmcp_lastver:$mmcp_nowver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | sed 's/porting//g' | sed 's/cfg*//g' | sed 's/test//g' | sed 's/adapter//g' | sed 's/tplib//g'| sed 's/integration//g' | sed 's/mediaplayer/mediaplayer mediaplayer\/ffmpeg/g' | sed 's/thirdparty//g' | sed 's/cfg//g' | sed 's/share//g'`
	fi
				
	if [ $cute_lastver -ne $cute_nowver ]
	then	
		model_list_all="$model_list_all cute"
	fi

	echo -e "======================= modified models:"$model_list_all" ======================="
	echo -e "======================= model_list_all:"$model_list_all" =======================" >> $log_file

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
		echo $model_list_all | grep -E "cfg"
		if [ $? -ne 0 ] && [ "$prj" != "ew600_wuhan_hi3716H" ]&& [ "$prj" != "shanxi_mstar_7c51g" ]
		then                
		      model_list="$model_list_all cfg"
		fi                
        fi
fi


if [ $flagall -eq 0 ]
then
        cd $workpath/lib
	if [ $? -eq 0 ]
	then
		rm -fr $workpath/lib
	fi

	if [ "$prj" = "ew600_4.7_osg" ] 
	then
		model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer mediaplayer/ffmpeg midp protocol shell cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"	
	elif [ "$prj" = "guangdong_4.7" ] 
	then
		model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol shell cfg cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"
	elif [ "$prj" = "sichuan_4.7_osg" ] ||  [ "$prj" = "hubei_gcable_hi3716m" ] ||  [ "$prj" = "hubei_ngb_hi3716m" ]
	then
        	model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer mediaplayer/ffmpeg midp protocol shell cfg cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"
  elif [ "$prj" = "sichuan_ew600_MSD7C51G" ]
	then
        	model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol shell cfg cute thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1"
	elif [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ]|| [ "$prj" = "shanxi_mstar_7c51g" ]
	then
		model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer midp protocol pvr shell cfg cute thirdparty/ca/dvn thirdparty/ca/tfcdcasa thirdparty/ca/shumashixun_multi thirdparty/ca/shumashixun_5200 share/udi2/hdicommon/udi2_caadapter share/udiplus share/udi2/lcsp_udi1 WebXML"
	elif [ "$prj" = "ew600_wuhan_hi3716H" ]
	then
		model_list="codec dtv dtvmx graph jsext jvm kernel mediaplayer mediaplayer/ffmpeg midp protocol shell cute"
	fi
fi

echo -e "======================= all need to make models:"$model_list" ======================="
if [ "$prj" = "sichuan_ew600_MSD7C51G" ]
then
	   bash $shellbash $mmcp_nowver "$model_list" $mdli $prj $dir $plat release
     bash $shellbash $mmcp_nowver "$model_list" $mdli $prj $dir $plat stepbystep
else
		bash $shellbash $mmcp_nowver "$model_list" $mdli $prj $dir $plat release
		bash $shellbash $mmcp_nowver "$model_list" $mdli $prj $dir $plat debug
fi

	
echo $model_list | grep "dtvmx"
echo -e "================= dtvmx need to update ================"  >> $log_file
if [ $? -eq 0 ]
then
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

if [ "$prj" == "guangdong_hi3716m" ]
then
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
if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ]|| [ "$prj" = "shanxi_mstar_7c51g" ]
then
	cd $workpath/lib/mmcp_publish
	if [ $? -eq 0 ]
	then
		echo -e "================= first remove old mmcp_publish ================"  >> $log_file
		rm $workpath/lib/mmcp_publish -fr
	fi
	
	cd $workpath/integration/product/shanxi
	if [ "$plat" == "ali_m3701c" ]
	then	
		. setupenv pf=ali manu=juying typeid=64 ca=dvn
	elif [ "$plat" == "mstar_7c51c" ]
	then
		. setupenv pf=mstar manu=hisense typeid=64
	elif [ "$plat" == "hi3716M_hisiv200" ]
	then
		. setupenv pf=hisi manu=jiulian
	elif [ "$plat" == "MSD7C51G" ]
	then
		. setupenv pf=7c51g manu=coship ca=tf typeid=65
	fi

	export USE_COMPLING_LIB=yes
	cd $workpath/integration/product/shanxi
	. publish.sh >> $log_file_detail  2>&1
	echo "============= now, begin to copy mmcp_publish ============" >> $log_file
	cp $workpath/integration/product/shanxi/mmcp_publish $workpath/lib/. -rf 
elif [ "$prj" = "sichuan_4.7_osg" ]
then
	cd $workpath/integration/product/sichuan
	export USE_COMPLING_LIB=yes
	. publish.sh >> $log_file_detail  2>&1
	echo "============= now, begin to copy mmcp_publish ============" >> $log_file
	cp $workpath/integration/product/sichuan/mmcp_publish $workpath/lib/. -rf 
elif [ "$prj" = "hubei_gcable_hi3716m" ]
then
  cd $workpath/integration/product/hubei_hisi3716M_Gcable
  . setupenv yinhe
  make clean
  make >> $log_file_detail  2>&1
  make publish
  cp $workpath/integration/product/hubei_hisi3716M_Gcable/mmcp_publish_yinhe $workpath/lib/. -rf 
  
  cd $workpath/integration/product/hubei_hisi3716M_Gcable
  . setupenv yinhe_jingmen
  make clean
  make >> $log_file_detail  2>&1
  make publish
  cp $workpath/integration/product/hubei_hisi3716M_Gcable/mmcp_publish_yinhejingmen $workpath/lib/. -rf 
fi

#nowhour=`date +%H`
#if [ $nowhour -gt 22 ]
#then
#	cd $workpath
#	cppcheck_models="dtv jsext kernel shell"
#	cppcheck $cppcheck_models --xml 2> $allpath/logs/CppcheckReports.xml
#fi



echo ======================= make end, begin to copy ===================================
creattime=`date +%Y%m%d%H%M`
### only save the latest 3 files
#cd /home/jiangfeng/mmcp_publishers/Guangdong_ew600_outputs
#fileall=`ls -rt`
#filesave=`ls -rt | tail -n3`
#filedel=`ls -rt | grep -v "$filesave"`
#rm -rf $filedel

### begin to copy
pubdir=/home/hudson/publisher/$prj/$creattime\_mmcp$mmcp_nowver\_cute$cute_nowver
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


if [ "$prj" == "guangdong_hi3716m" ]
then
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
echo $mmcp_nowver > $lastverlog_mmcp
echo $cute_nowver > $lastverlog_cute
echo $webkit_nowver > $lastverlog_webkit
if [ "$prj" = "shanxi_4.7" ] || [ "$prj" = "shanxi_ali_4.7" ] || [ "$prj" = "shanxi_mstar_4.7" ] || [ "$prj" = "sichuan_4.7_osg" ]|| [ "$prj" = "shanxi_mstar_7c51g" ]
then
	echo $third_nowver > $lastverlog_third
fi

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
