#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: xieyue (on 2010/06/01) 

mod=$1
svnreversion=$2
model_list_cbb=$3
model_list_author_cbb=$4
mdli=$5
plat=$6
prj=$7
dir=$8


allpath=/home/hudson/project/$prj
workpath=$allpath/$dir

log_file=$allpath/logs/make_$prj.log
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
idmd=0
flag=0


echo $model_list_cbb | grep "kernel"
if [ $? -eq 0 ]
then :
else 
	 model_list_cbb="kernel $model_list_cbb"
fi


#### set $prj env
if [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ]
then
	cd $workpath/integration/product/guizhou_jiulian_hi3716M
        . setupenv	
elif [ "$prj" = "mmcp_jilin_hi3716m" ]
then
        cd $workpath/integration/product/jilin
        . setupenv --m yinhe
elif [ "$prj" = "mmcp_tianjin_hi3716m_v300" ]
then
        cd $workpath/integration/product/tianjin_hi3716M
        . setupenv

elif [ "$prj" = "mmcp_jiangsu_android_6A801_3rd" ]
then
	export MMCP_CATYPE=tongfangca
	export MMCP_COMPANY=OTHER_COMPANY    
	cd $workpath
	. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod 
else
	cd $workpath
	. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod
fi

showenv >> $log_file


export MMCP_LIB_NODEBUG=1

### acquire the right mod
echo $mod | grep "release"
if [ $? -eq 0 ]
then
	mod=release
else
	echo $mod | grep "debug"
	if [ $? -eq 0 ]
	then
		mod=debug
	fi
fi

### rm libmmcp.a
cd $workpath/lib/$plat/$mod
if [ $? -eq 0 ]
then
	rm libmmcp_ew* -f
fi

echo begin to make jvm FIRST~~~~~~~~~

### jvm first and make
echo -e "------------------ $mdli $mdl for $prj make begin --------------------\n " >> $log_file_detail
cd $workpath/jvm
make FIRST=true >> $log_file_detail  2>&1
if [ $? -eq 0 ]
then
	echo -e "------- $mdli jvm FIRST=true for $prj $plat make success \n------"
	echo -e "$mdli jvm FIRST=true for $prj $plat make success ----- " >> $log_file
	echo -e "$mdli jvm FIRST=true for $prj $plat make success ----- " >> $log_file_detail
else
	echo -e "------- $mdli jvm FIRST=true for $prj $plat make failed ------\n"
	echo -e "$mdli jvm FIRST=true for $prj $plat make failed ------ " >> $log_file_detail
	echo -e "$mdli jvm FIRST=true for $prj $plat make failed message is :------ " >> $log_file
	tail -10 $log_file_detail >>  $log_file
fi
	
for mdlcbb in $model_list_cbb
do
	mdli=$(($mdli+1))
	author=`echo $model_list_author_cbb | awk {'print $1'}`
	model_list_author_cbb=`echo $model_list_author_cbb | sed "s/$author//g"`
	cd $workpath/$mdlcbb
	chmod 777 -Rf *
	
	if [ "$mdlcbb" = "cfg" ] && [ $prj = "mmcp_tianjin_tcb_hi3716h" ]
	then
		make clean > /dev/null 2>&1
		make config=make_tcb3716.txt >> $log_file_detail  2>&1
		if [ $? -ne 0 ]
                then
			result=failed
			flag=1
			echo  -------------- tianjin cfg hi3716h make failed -----------
                        echo  ------------------- make cfg hi3716h failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libcfgmake_tcb3716.a
                fi
	
	elif [ "$mdlcbb" = "cfg" ] && [ $prj = "mmcp_tianjin_coship_hi3716m" ]
        then
		make clean > /dev/null 2>&1
                make config=make_coship3716.txt >> $log_file_detail  2>&1
		if [ $? -ne 0 ]
                then
			result=failed
			flag=1
			echo  ------------------- tianjin cfg coship make failed -------------------
                        echo  ------------------- make cfg coship failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libcfgmake_coship3716.a
                fi

        elif [ "$mdlcbb" = "cfg" ] && [ $prj = "mmcp_tianjin_hi3716m_v300" ]
        then
                make clean > /dev/null 2>&1
                make config=make_hisi3716M.txt >> $log_file_detail  2>&1
                if [ $? -ne 0 ]
                then
			result=failed
			flag=1
			echo  ------------------- tianjin cfg hisi3716m make failed ----------------
                        echo  ------------------- make cfg hisi3716m failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libcfgmake_hisi3716M.a
                fi

                make clean > /dev/null 2>&1
                make config=make_yh3716.txt >> $log_file_detail  2>&1
                if [ $? -ne 0 ]
                then
			result=failed
			flag=1
			echo  ------------------- make cfg yinhe 3716m failed ------------------
                        echo  ------------------- make cfg yinhe 3716m failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libcfgmake_yh3716.a
                fi

	elif [ "$mdlcbb" = "cfg/jiangsu_coship_hi3716M" ]
        then
                make clean > /dev/null 2>&1
                make >> $log_file_detail  2>&1
                if [ $? -ne 0 ]
                then
			result=failed
			flag=1
			echo  ------------------- make jiangsu cfg hisi3716m failed ------------------------
                        echo  ------------------- make jiangsu cfg hisi3716m failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libcfg_jiangsu_coship_hi3716M.a
                fi

        elif [ "$mdlcbb" = "thirdparty/mis" ] && [ $prj = "mmcp_guangdong_hi3110e" ]
        then
                make clean > /dev/null 2>&1
                make >> $log_file_detail  2>&1
                if [ $? -ne 0 ]
                then
                        result=failed
                        flag=1
                        echo  ------------------- guangdong mis make failed ----------------
                        echo  ------------------- make mis failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libmis.a
                fi
		
		make clean > /dev/null 2>&1
                make config=make_jiesai.txt >> $log_file_detail  2>&1
                if [ $? -ne 0 ]
                then
                        result=failed
                        flag=1
                        echo  ------------------- guangdong mis jiesai make failed ----------------
                        echo  ------------------- make mis jiesai failed -----  >> $log_file
                        rm $workpath/lib/$plat/$mod/libmis_jiesai.a
                fi


	else
        	make clean > /dev/null 2>&1
       		make  >> $log_file_detail  2>&1
		if [ $? -eq 0 ]
        	then
                	result=success
			echo -e "--------- $mdli $mdlcbb for $prj $plat $mod make success -----\n"
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success ----- " >> $log_file
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make success ----- " >> $log_file_detail
        	else
                	result=failed
			echo -e "--------- $mdli $mdlcbb for $prj $plat $mod make failed message is :---------"
			tail -10 $log_file_detail
                	echo -e "$mdli $mdlcbb for $prj $plat $mod make failed message is :------ " >> $log_file
               		tail -10 $log_file_detail >>  $log_file
                	cd $workpath/lib/$plat/$mod
                	if [ $? -eq 0 ]
                	then
                        	echo -e "============== the current path and lib: $(pwd),$mdlcbb.a =============" >> $log_file
                        	rm lib$mdlcbb* -f
                	fi

                	flag=1
                	logfaild="$logfaild $mdlcbb:$author"
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


if [ "$flag" -eq 1 ]
then
        cd $workpath
        make cleanmmcp > /dev/null 2>&1
        echo -e "*********** Result: make $prj $plat $mod failed  reversion $svnreversion **********\n\n"  >> $log_file 
        echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
else
	cd $workpath
	make cleanmmcp > /dev/null 2>&1

	if [ "$prj" == "topway_hi3716c_v200_client" ]
        then
                make mmcp_client >> $log_file_detail  2>&1
	else
		make mmcp >> $log_file_detail  2>&1
	fi

	if [ $? -eq 0 ]
        then
		echo -e "\n\n****************** Result: make $prj $palt $mod success  reversion $svnreversion *****************\n\n"
        	echo -e "\n\n******** Result: make $prj $palt $mod success  reversion $svnreversion **********\n\n"  >> $log_file
	else 
		echo -e "\n\n************ Result: make $prj $plat $mod failed  reversion $svnreversion *****************\n\n"
		echo -e "\n\n************ Result: make $prj $plat $mod failed  reversion $svnreversion *************\n\n"  >> $log_file
	        echo -e "$logfaild $mod  make failed "  >> $log_failedinfo
	fi
fi	





