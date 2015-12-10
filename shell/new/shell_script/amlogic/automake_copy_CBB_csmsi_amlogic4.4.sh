#!/bin/bash
#########write by qiaoting 4/23/2013
workspace=$1
csmsi_dist_dir=$2
src_path=$3
#copy from CBB_csmsi_amlogic4.4 
#src_path=/home/hudson/share_5.161/CBB_csmsi_amlogic4.4/lastSuccessful/archive/output

cd $src_path
pakage_version=`ls *.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not csmsi new package \n " >> $workspace/package/log_version_csmsi.txt
else 
	echo "copy csmsi,csmsi version: $pakage_version \n" >> $workspace/package/log_version_csmsi.txt
cd $csmsi_dist_dir
rm -f csmsi-amlogic4.4*.tar.gz

cp -f $src_path/$pakage_version    $csmsi_dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_csmsi.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_csmsi.txt
cp -f $src_path/$pakage_version    $workspace/package/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_csmsi.txt  || echo "copy $pakage_version error"  >> $workspace/package/log_version_csmsi.txt
cd $csmsi_dist_dir 
mkdir tmp
tar  -xvzf   csmsi-amlogic4.4*.tar.gz -C ./tmp
cd tmp/csmsi/
echo "csmsi version:">> $workspace/apk_csmsi_version.txt
cat version.h >>$workspace/apk_csmsi_version.txt
cd $csmsi_dist_dir
rm -rf tmp
fi

