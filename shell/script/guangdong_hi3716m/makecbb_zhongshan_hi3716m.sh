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

#### set $prj & ca env
cd $workpath
echo $workpath
#. bin/setupenv --ia bin/envfile_fortrunk/setenv\/$plat\_$mod
. bin/setupenv --ia bin/envfile_fortrunk/setenv_hi3716M_hisiv200_release_EW600
showenv >> $log_file
echo ====================makecbb_zhongshan_hi3716M release ============================
#. bin/casetupenv --ia bin/envfile_fortrunk/setenv_ca_tfcdca_release

echo $model_list_cbb | grep "kernel"
if [ $? -eq 0 ]
then :
else
         model_list_cbb="kernel $model_list_cbb"
fi


echo -e "====================== rm libmmcp_ew600.a =====================" >> $log_file
cd $workpath/lib/$plat/$mod
rm libmmcp_ew* -f


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

### build qt_4.7
export build_qt47=true

### jvm first and make
echo -e "------$mdli $mdl for $prj make begin------ " >> $log_file_detail
cd $workpath/jvm
make clean > /dev/null 2>&1
make FIRST=true >> $log_file_detail  2>&1


if [ $? -eq 0 ]
then
				echo -e "----------- $mdli jvm FIRST=true for $prj $plat make success --------\n"
        echo -e "$mdli jvm FIRST=true for $prj $plat make success----- " >> $log_file
        echo -e "$mdli jvm FIRST=true for $prj $plat make success----- " >> $log_file_detail
else
				echo -e "----------- $mdli jvm FIRST=true for $prj $plat make failed --------\n"
        echo -e "$mdli jvm FIRST=true for $prj $plat make failed------ " >> $log_file_detail
        echo -e "$mdli jvm FIRST=true for $prj $plat make failed message is :------ " >> $log_file
        tail -10 $log_file_detail >>  $log_file
fi

for mdlcbb in $model_list_cbb
do
        mdli=$(($mdli+1))
        author=`echo $model_list_author_cbb | awk {'print $1'}`
        model_list_author_cbb=`echo $model_list_author_cbb | sed "s/$author//g"`
	

	if [	"$mdlcbb" = "cute" ]
	then
		echo ===================== the current cbb is cute,make cute later.... >> $log_file
		flagcute=1
	else
        	cd $workpath/$mdlcbb
		chmod 777 -Rf *
        	make clean > /dev/null 2>&1
        	make  >> $log_file_detail  2>&1


		if [ $? -eq 0 ]
	        then
        	        result=success
        	        echo -e "--------------- $mdli $mdlcbb for $prj $plat $mod make success ---------------\n"
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success----- " >> $log_file
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success----- " >> $log_file_detail
	        else
        	        result=failed
        	        echo -e "--------------- $mdli $mdlcbb for $prj $plat $mod make failed message is : ---------------\n"
        	        tail -10 $log_file_detail
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make failed message is :------ " >> $log_file
			tail -10 $log_file_detail >>  $log_file
			### libmmcp_ew600.a doesn't contain these libs
			if [ "$mdlcbb" = "thirdparty/ca/tfcdcasa" ] || [ "$mdlcbb" = "thirdparty/ca/shumashixun_multi" ] || [ "$mdlcbb" = "share/udi2/hdicommon/udi2_caadapter" ] || [ "$mdlcbb" = "share/udiplus" ] || [ "$mdlcbb" = "share/udi2/lcsp_udi1" ]
                	then
                        	flag=0
			else
                        	cd $workpath/lib/$plat/$mod
				echo -e "================ the current path and lib: $(pwd),$mdlcbb.a ==================" >> $log_file
                        	rm lib$mdlcbb* -f
                        	flag=1
                        	logfaild="$logfaild $mdlcbb:$author"
                	fi
		fi
        fi

        echo -e "<items>" >> $log_tmp
        echo -e "<id>$mdli</id>" >> $log_tmp
        echo -e "<modules>$mdlcbb</modules>"  >> $log_tmp
        echo -e "<author>$author</author>"  >> $log_tmp
        echo -e "<svn_version>$svnreversion</svn_version>" >> $log_tmp
        echo -e "<mod>$mod</mod>" >> $log_tmp
        echo -e "<result>$result</result>" >> $log_tmp
        echo -e "</items>" >> $log_tmp
done

if [ "$flagcute" -eq 1 ]
then
	if [ "$mod" = "release" ]
	then
		#5 make cute
		echo "+++++++++++++++++++++++++++++++ release, begin to make cute ++++++++++++++++++++++++++++++++" >> $log_file

                cd $workpath/lib/$plat/$mod
                rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf

		cd $workpath/cute
		chmod +x build_modules_4.7.sh

		if [ -f ./build_modules_4.7.sh  ]; then
			echo "exec build_modules_4.7.sh" >> $log_file
			echo 1 | . build_modules_4.7.sh > /dev/null 2>&1
			echo 2 | . build_modules_4.7.sh > /dev/null 2>&1
			if [ $? -eq 0 ]
			then
			echo -e "--------------- cute for $prj $plat $mod make sucess ---------------\n"
				echo -e "------$platform\_$mod\ build_modules_4.7 sucess!-----" >> $log_file
			fi
		else
			echo "no build_modules_4.7.sh" >> $log_file
		fi

		if [ -f $workpath/build_error.log ]; then
			echo "cat to $log_file" >> $log_file_detail
			cat $workpath/build_error.log >> $log_file_detail
		else
			echo "No $workpath/build_error.log" >> $log_file
		fi

		if [ -d $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/qt_lib ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libqtmicrowin.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libwebkitPlatform.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/$MMCP_COMPILING_MODE/libwebkitshell.a ]
		then			
			flag=0	
		else			
			flag=1			
			echo -e "--------------- cute for $prj $plat $mod make faild ---------------\n"	
			echo "cute maybe build failed, make pack faild" >> $log_file			
		fi


	else
		echo "++++++++++++++++++++++++++++++++++ debug, only copy cute +++++++++++++++++++++++++++++++++++" >> $log_file
		cd $workpath/lib/$plat/$mod
                rm qt_lib libqtmicrowin.a libwebkitPlatform.a libwebkitshell.a -rf
		if [ -d $workpath/lib/$MMCP_PLATFORM/release/qt_lib ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libqtmicrowin.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libwebkitPlatform.a ] && [ -f $workpath/lib/$MMCP_PLATFORM/release/libwebkitshell.a ]; then
			flag=0
			cp $workpath/lib/$plat/release/qt_lib qt_lib -rf
			cp $workpath/lib/$plat/release/qt_lib_static qt_lib_static -rf
			cp $workpath/lib/$plat/release/libqtmicrowin.a libqtmicrowin.a -f
			cp $workpath/lib/$plat/release/libwebkitPlatform.a libwebkitPlatform.a -f
			cp $workpath/lib/$plat/release/libwebkitshell.a libwebkitshell.a -f
		else
			echo "cute maybe build failed, make pack faild" >> $log_file
			flag=1
		fi
	fi

fi

if [ "$flag" -eq 1 ]
then
				echo -e "\n\n******** Result: make $prj $plat $mod failed  reversion $svnreversion **********\n\n"
        echo -e "********Result: make $prj $plat $mod failed  reversion $svnreversion**********\n\n"  >> $log_file
        echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
else
        cd $workpath
        make mmcp   >> $log_file_detail  2>&1
        #if [ $? -eq 0 ]
        #then
        #	echo -e "********Result: make pack $prj $palt $mod success  reversion $svnreversion**********\n\n"  >> $log_file
        #else
        #        echo -e "********Result: make pack $prj $plat $mod failed  reversion $svnreversion**********\n\n"  >> $log_file
        #	echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
        #fi
fi



