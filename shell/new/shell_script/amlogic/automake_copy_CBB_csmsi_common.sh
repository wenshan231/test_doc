#!/bin/bash

#########write by wanghuimin 10/25/2014
workspace=$1
csmsi_dist_dir=$2
src_path=$3
pakage_name=$4


cd $src_path
pakage_version=`ls $pakage_name*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not csmsi new package \n " >> $workspace/package/log_version_csmsi.txt
else 
	echo "copy csmsi,csmsi version: $pakage_version \n" >> $workspace/package/log_version_csmsi.txt
cd $csmsi_dist_dir
rm -f $pakage_name*.tar.gz
cp -f $src_path/$pakage_version    $csmsi_dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_csmsi.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_csmsi.txt
cp -f $src_path/$pakage_version    $workspace/package/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_csmsi.txt  || echo "copy $pakage_version error"  >> $workspace/package/log_version_csmsi.txt
cd $csmsi_dist_dir 
mkdir tmp
tar  -xvzf   $pakage_name*.tar.gz -C ./tmp
cd tmp/csmsi/
echo "csmsi version:">> $workspace/apk_csmsi_version.txt
cat version.h >>$workspace/apk_csmsi_version.txt
cd $csmsi_dist_dir
rm -rf tmp
fi

