#! /bin/bash

mod=$1
svnreversion=$2
model_list_cbb=$3
mdli=$4
plat=$5
prj=$6
dir=$7

allpath=/home/hudson/$prj
workpath=$allpath/$dir

log_file=$allpath/logs/make_$prj.log
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_tmp=$allpath/logs/result.log
log_failedinfo=$allpath/logs/infotxt.log
idmd=0
flag=0

### set $prj env
cd $workpath
. bin/setupenv --ia bin/envfile_fortrunk/setenv_$plat\_$mod
showenv >> $log_file

export MMCP_LIB_NODEBUG=1

### rm libmmcp.a
cd $workpath/lib/Android_AmS802/$mod
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
else
	echo -e "------- $mdli jvm FIRST=true for $prj $plat make failed ------\n"
	tail -10 $log_file_detail >>  $log_file
fi
echo ====================model_list_cbb is  $model_list_cbb===============================	
for mdlcbb in $model_list_cbb
do
	mdli=$(($mdli+1))

	cd $workpath/$mdlcbb
	chmod 777 -Rf *
	if [ "$mdlcbb" = "dtvmx" ] 
	then
		make clean > /dev/null 2>&1
		make >> $log_file_detail  2>&1
		if [ $? -ne 0 ]
		then
			result=failed
			flag=1
			echo  ------- dtvmx make failed ----------------
			rm $workpath/lib/$plat/$mod/libdtvmx.a
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
			echo ------module $moli make failed---------------------
   
        	fi
 	fi

done

### make limmcp_ew510.a 
	cd $workpath
	make cleanmmcp > /dev/null 2>&1
	echo -----make cleanmmcp-----------
	if [ "$plat" = "Android_AmS802_Client" ]
        then
        echo -----make mmcp_client-----------
        make mmcp_client >> $log_file_detail  2>&1
	else
	  echo -----make mmcp-----------
		make mmcp >> $log_file_detail  2>&1
	fi
	
	





