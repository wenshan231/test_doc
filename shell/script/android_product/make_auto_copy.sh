#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2014/02/20)
plat=Android_Hi3716C_V200
plat_flag=Android_Hi3716C_V200_Client
workspace=/home/hudson/project/taiwan_$plat_flag\/delivery

cd $workspace
rm -fr output 
mkdir output output/mmcp output/binder output/dtvmx_jar output/510apk output/mmcp_product


mmcp_autocopy_path_dir=/home/hudson/publisher/delivery_$plat_flag
mmcp_autocopy_version=`ls -ct $mmcp_autocopy_path_dir | head -1`
mmcp_autocopy_path=/home/hudson/publisher/delivery_$plat_flag\/$mmcp_autocopy_version\/lib/lib/$plat\/debug
mmcp_dist=$workspace\/integration/product/taiwan_android_merge/mmcp_lib/$plat
#mmcp_files="libcfg_taiwan_hi3716C_V200*.a  libmmcp_ew510*.a"
cp -f $mmcp_autocopy_path/libcfg_taiwan_hi3716C_V200*.a   $mmcp_dist
cp -f $mmcp_autocopy_path/libcfg_taiwan_hi3716C_V200*.a   $workspace/output/mmcp
cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $mmcp_dist
cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $workspace/output/mmcp




bind_autocopy_path=/home/hudson/public_96.200/bindermanager/lastSuccessful/archive/output
bind_dist=$workspace\/integration/product/taiwan_android_merge/porting/Android_Hi3716C_V200/coship/lib/androidlib
cd $bind_autocopy_path
ll *
cd $workspace && rm -fr tmp && mkdir  tmp
cp $bind_autocopy_path/bindermanager*.tar.gz $workspace/output/binder
cp $bind_autocopy_path/bindermanager*.tar.gz $workspace/tmp
cd $workspace/tmp && tar -xvf bindermanager*.tar.gz  
cd $workspace/tmp &&  filelist_del=`find ./ -name "*provider.a"` && rm -f $filelist_del &&  filelist=`find ./ -name "*.a"` 
cp -f $workspace/tmp/$filelist $bind_dist/




mmcp_510APK_path=/home/hudson/public_96.200/com.coship.mmcp510.merge/lastSuccessful/archive/output
mmcp_files="com.coship.mmcp510.apk com.coship.mmcp510.apk"
cp $mmcp_510APK_path/com.coship.mmcp510.merge.tar.gz  $workspace/output/510apk/



#dtvmx_jar_path=/home/hudson/publisher/dtvmx
#dtvmx_jar_version=`ls -ct $dtvmx_jar_path | head -1`
#cp -fr $dtvmx_jar_path/$dtvmx_jar_version $workspace/output/dtvmx_jar/
dtvmx_jar_path=/home/tmp/dtvmx_jar_taiwan/lastSuccessful/archive/dtvmx/bin
cp -fr $dtvmx_jar_path/* $workspace/output/dtvmx_jar/















  