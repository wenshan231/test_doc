#!/bin/bash
#########write by qiaoting 3/27/2014
apk_list=$1
workspace=$2

apk_dist_dir=$3
apk_from_dir=/home/ott-admin/hudson/share_5.161_win

#######begin copy
#cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy $apk_list"  > $workspace/package/log_version_apk.txt

cd $apk_dist_dir

for apk_mdl in $apk_list
do
	i=$(($i+1))
	cd $apk_from_dir/$apk_mdl/builds
	last_dir=`ls -ct | head -1`
	cd $apk_from_dir/$apk_mdl/builds/$last_dir
	if [ -f archive/output/*.zip ]
	then 
		echo "copy $i  $apk_mdl begin " >> $workspace/package/log_version_apk.txt

		cd $apk_dist_dir
		rm -fr tmp && mkdir tmp
		chmod -R 777 tmp
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/*.zip		   tmp/
		cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/output/*.zip		   $workspace/package/
		cd tmp
		echo "all apk version:">>$workspace/package/log_version_apk.txt
		ls -l  >>$workspace/package/log_version_apk.txt
		unzip *.zip && echo "tar $apk_mdl*.zip  ok"  >> $workspace/package/log_version_apk.txt  || echo "tar $apk_mdl*.zip error"  >> $workspace/package/log_version_apk.txt 
		cp -f *_hisi.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/package/log_version_apk.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/package/log_version_apk.txt
	else 
	 	if [ -f archive/src/trunk/output/*.zip ]
		then 
			echo "copy $i  $apk_mdl begin " >> $workspace/package/log_version_apk.txt
	
			cd $apk_dist_dir
			rm -fr tmp && mkdir tmp
			chmod -R 777 tmp
			cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/src/trunk/output/*.zip		   tmp/
			cp -f $apk_from_dir/$apk_mdl/builds/$last_dir/archive/src/trunk/output/*.zip		   $workspace/package/
			cd tmp
			unzip *.zip && echo "tar $apk_mdl*.zip  ok"  >> $workspace/package/log_version_apk.txt  || echo "tar $apk_mdl*.zip error"  >> $workspace/package/log_version_apk.txt 
			cp -f *_hisi.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/package/log_version_apk.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/package/log_version_apk.txt
		else 
	 		echo  "not exit $i $apk_mdl new package " >> $workspace/package/log_version_apk.txt 
		fi
	fi
	echo -e "" >> $workspace/package/log_version_apk.txt
done

rm -rf $apk_dist_dir/tmp
rm $workspace/package/*.zip
chmod -R 777   $apk_dist_dir/ 

#cd  $apk_dist_dir/  && ls -l  *  >> $workspace/package/log_version_apk.txt





