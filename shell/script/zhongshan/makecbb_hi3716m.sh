#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: QiaoTing (on 2010/04/15) add platform rlease branch

svnreversion=$1
model_list_cbb=$2
mdli=$3
prj=$4
dir=$5
mod=$6

plat=hi3716M_hisiv200

allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

log_file=$allpath/logs/make_$prj.log
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
idmd=0
flag=0
flagcute=0

#### set $prj env
cd $workpath
echo $workpath
. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod\_EW600
showenv >> $log_file

### build qt_4.7
export build_qt47=true

echo -e "====================== rm update lib =====================" >> $log_file
cd $workpath/lib/$plat/$mod
rm libmmcp_ew600*.a -f

echo -e "====================== iconv exportSvnVersion 6export_mmcp_ver =====================" >> $log_file
cd $workpath/bin
mytype=`file --mime-encoding -b "exportSvnVersion"`
mytype=`echo $mytype |cut -c 1-3`
if [ "$mytype" != "utf" ]
then
	echo exportSvnVersion >> exportSvnVersion.bak
	mv exportSvnVersion exportSvnVersion.bak
	iconv -f gb2312 -t utf-8 exportSvnVersion.bak > exportSvnVersion
	chmod 777 -Rf exportSvnVersion	
fi

mytype=`file --mime-encoding -b "6export_mmcp_ver"`
mytype=`echo $mytype |cut -c 1-3`
if [ "$mytype" != "utf" ]
then
	echo 6export_mmcp_ver >> 6export_mmcp_ver.bak
	mv 6export_mmcp_ver 6export_mmcp_ver.bak
	iconv -f gb2312 -t utf-8 6export_mmcp_ver.bak > 6export_mmcp_ver
	chmod 777 -Rf 6export_mmcp_ver		
fi


### copy lib form hi3716H/$mod
echo $model_list_cbb | grep "kernel"
if [ $? -eq 0 ]
then :
else
         model_list_cbb="kernel $model_list_cbb"
fi

if [ -d $workpath/lib/$plat/$mod ]
then
	echo -e "====================== $workpath/lib/$plat/$mod exits =====================" >> $log_file
else
	echo -e "====================== $workpath/lib/$plat/$mod not exits =====================" >> $log_file
	mkdir $workpath/lib/$plat/$mod -p
fi


for mdlcbb in $model_list_cbb
do
	echo $mdlcbb
	echo -e "====================== update cbb:$mdlcbb =====================" >> $log_file
	if [ "$mdlcbb" = "cute" ]
	then
		cd $workpath/lib/$plat/$mod
		rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf
		cp $workpath/lib/hi3716H/release/qt_lib qt_lib -rf
                cp $workpath/lib/hi3716H/release/libqtmicrowin.a libqtmicrowin.a -f
                cp $workpath/lib/hi3716H/release/libwebkitPlatform.a libwebkitPlatform.a -f
		cp $workpath/lib/hi3716H/release/libwebkitshell.a libwebkitshell.a -f

        elif  [ "$mdlcbb" = "mediaplayer" ]
        then
                cd $workpath/lib/$plat/$mod
                rm libmediaplayer*.a libffmpeg.a -f
                cp $workpath/lib/hi3716H/$mod/libmediaplayer*.a . -f
		cp $workpath/lib/hi3716H/$mod/libffmpeg.a . -f

        elif  [ "$mdlcbb" = "jvm" ] || [ "$mdlcbb" = "dtvmx" ]
        then
                cd $workpath/lib/$plat/$mod
                rm libdtvmx.a libjavaclass.a libjavavm.a -f
                cp $workpath/lib/hi3716H/$mod/libdtvmx.a . -f
		cp $workpath/lib/hi3716H/$mod/libjavaclass.a . -f
		cp $workpath/lib/hi3716H/$mod/libjavavm.a . -f
		
	elif [ "$mdlcbb" = "cfg" ]	
	then
		echo current module is cfg........
	else
		cd $workpath/lib/$plat/$mod
		rm lib$mdlcbb* -f
		cp $workpath/lib/hi3716H/$mod/lib$mdlcbb* . -f
	fi
done


echo $model_list_cbb | grep "cfg"
if [ $? -eq 0 ]
then
	cd $workpath/lib/$plat/$mod
	rm libcfg_zhongshan_hi3716M.a -f
	cd $workpath/cfg/zhongshan_hi3716M
	chmod 777 -Rf *
	
	make clean > /dev/null 2>&1
	make  >> $log_file_detail  2>&1
	if [ $? -ne 0 ]
	then
		rm $workpath/lib/$plat/$mod/libcfg_zhongshan_hi3716M.a -f
		echo ===================== cfg/zhongshan_hi3716M make failed message is :  ========================
		tail -10 $log_file_detail
		echo ===================== cfg/zhongshan_hi3716M make failed message is :  ======================== >> $log_file
		tail -10 $log_file_detail >>  $log_file
	else
		echo ===================== cfg/zhongshan_hi3716M make success ========================
		echo ===================== cfg/zhongshan_hi3716M make success ======================== >> $log_file
	fi

  cd $workpath/lib/$plat/$mod
	rm libcfg_zhongshan_3rd_hi3716M.a -f
	cd $workpath/cfg/zhongshan_3rd_hi3716M
	chmod 777 -Rf *
	
	make clean > /dev/null 2>&1
	make  >> $log_file_detail  2>&1
	if [ $? -ne 0 ]
	then
		rm $workpath/lib/$plat/$mod/libcfg_zhongshan_3rd_hi3716M.a -f
		echo ===================== cfg/zhongshan_3rd_hi3716M make failed message is :  ========================
		tail -10 $log_file_detail
		echo ===================== cfg/zhongshan_3rd_hi3716M make failed message is :  ======================== >> $log_file
		tail -10 $log_file_detail >>  $log_file
	else
		echo ===================== cfg/zhongshan_3rd_hi3716M make success ========================
		echo ===================== cfg/zhongshan_3rd_hi3716M make success ======================== >> $log_file
	fi

fi

echo -e "====================== Now,begin to make pack =====================" 
echo -e "====================== Now,begin to make pack =====================" >> $log_file
cd $workpath
make mmcp >> $log_file_detail



