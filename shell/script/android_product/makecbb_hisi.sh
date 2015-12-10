#! /bin/bash


mod=$1
svnreversion=$2
model_list_cbb=$3
model_list_author_cbb=$4
mdli=$5
plat=$6
prj=$7
dir=$8
env_config=$9


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
cd $workpath

if [ "$env_config" != "" ] && [ "$env_config" != "none" ]

then
	. bin/setupenv --ia bin/envfile_fortrunk/$env_config
else

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
echo ====================model_list_cbb is  $model_list_cbb===============================	
for mdlcbb in $model_list_cbb
do
	mdli=$(($mdli+1))
	author=`echo $model_list_author_cbb | awk {'print $1'}`
	model_list_author_cbb=`echo $model_list_author_cbb | sed "s/$author//g"`
	cd $workpath/$mdlcbb
	chmod 777 -Rf *
	echo ==================== now , begin to make  $mdlcbb===============================
	
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

	if [ "$plat" == "Android_6A801_Client" ] || [ "$plat" == "Android_Hi3716C_V200_Client" ] || [ "$prj" == "tianjin_Android_Hi3716C_V200_Client" ]
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





 