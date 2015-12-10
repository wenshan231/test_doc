#!/bin/bash
#####
#copy from mtk8638 二次软件包
#$3  depend on   mtk8638 of hudson
prj=$1
prj_name=$2
workspace=/home/hudson/$prj/trunk
workspace_mtk8638=/home/ott-admin/hudson/jobs/$3/lastSuccessful/archive/code
pakage_info= $workspace/log_version.txt
apk_dist_dir=$workspace/platform
package_name=mt8658sdkcoship.tar.gz
cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt
cd $workspace_mtk8638/output/
pakage_version=`ls *_int*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not mtk8638 new package \n" >> $workspace/log_version.txt
else 
echo "copy platform mtk8638 pakage,mtk8638 version: $pakage_version \n" >> $workspace/log_version.txt 
cd $apk_dist_dir
rm -f $package_name
cp -f $workspace_mtk8638/output/$pakage_version    $apk_dist_dir/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt
cp -f $workspace_mtk8638/output/$pakage_version    $workspace/package/ 
#mv $apk_dist_dir/$pakage_version  $apk_dist_dir/$package_name  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt
tar -xvf $apk_dist_dir/$pakage_version  && echo "tar  $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar  $pakage_version error"  >> $workspace/log_version.txt
fi
echo -e "" >> $workspace/log_version.txt 

###copy from apk 
###apk_list="FlyUI_Portal FlyUI_VOD"
###src_path=/home/qiaoting/SRC
###apk_dist_dir=$workspace/product/$prj_name/android/platform/system/app/apk



###for apk_mdl in $apk_list
###do
###	i=$(($i+1))
###	cd $src_path/$apk_mdl/output
###	pwd
###	pakage_version=`ls *.zip`
###	echo $pakage_version
###	if [ "$pakage_version" == "" ]
###	then
###		echo "$i not $apk_mdl new package " >> $workspace/log_version.txt
###	else 
###		echo "$i copy $pakage_version begin " >> $workspace/log_version.txt 
###		cd $apk_dist_dir
###		rm -fr tmp && mkdir tmp
###		chmod -R 777 tmp
###		cp -f $src_path/$apk_mdl/output/$pakage_version		   tmp/
###		cp -f $src_path/$apk_mdl/output/$pakage_version		 $workspace/package/
###		cd tmp
###		unzip $pakage_version && echo "tar $pakage_version ok"  >> $workspace/log_version.txt  || echo "tar $pakage_version error"  >> $workspace/log_version.txt 
###		cp -f $apk_mdl\.apk  $apk_dist_dir/  && echo  "copy $apk_mdl.apk ok" >> $workspace/log_version.txt  || echo  "copy $apk_mdl.apk error" >> $workspace/log_version.txt
###		
###	fi
###	echo -e "" >> $workspace/log_version.txt 
### done











