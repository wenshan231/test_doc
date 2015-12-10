# @author: xieyue (on 2013/01/17)
# This script is auto bak hudson config
#! /bin/bash

hudsonpath=/usr/local/tomcat/webapps/hudson
backuppath=/home/hudson/hudsonbak2013

mkdir $backuppath/hudson/jobs -p

echo ============= now, begin to copy hudson config ============
cp $hudsonpath/config.xml $backuppath/hudson/config.xml -f

job_list="binder_510apk changsha_android_6a801 changsha_android_6a801_client changsha_Android_Hi3716C_V200 changsha_Android_Hi3716C_V200_Client chongqing_android_6a801 chongqing_android_6a801_client delivery_android_6a801 delivery_android_6a801_client delivery_Android_Hi3716C_V200 delivery_Android_Hi3716C_V200_Client dtvmx_jar dtvmx_jar_changsha dtvmx_jar_yixing ew600_4.7_osg guangdong_4.7 guangdong_hi3716m guizhou_android_6a801 guizhou_android_6a801_client haerbin_skyworth_hi3716M hubei_gcable_hi3716m hubei_ngb_hi3716m jiangsu_Android_Hi3716C_V200 jiangsu_Android_Hi3716C_V200_Client  liaoning_Android_Hi3716C_V200 liaoning_Android_Hi3716C_V200_Client MMCP_Android_6A801 MMCP_Android_6A801_Client mmcp_hi3716m_yaha mmcp_jilin_android_6a801 mmcp_tag_hi3716h shanxi_4.7 shanxi_ali_4.7 shanxi_mstar_4.7 sichuan_4.7_osg taiwan_Android_Hi3716C_V200 taiwan_Android_Hi3716C_V200_Client tianjin_android_6a801 topway_hi3716c_v200 topway_hi3716c_v200_client wuhan_android_6a801 wuhan_android_6a801_hisense zhongshan_4.7"
for job in $job_list
do	
	echo ============= now, begin to copy $job config ============	
	mkdir $backuppath/hudson/jobs/$job	
	cp $hudsonpath/jobs/$job/config.xml $backuppath/hudson/jobs/$job/config.xml -f
done

enddate=`date +%Y%m%d`
echo ============= enddate:$enddate ============
cd $backuppath
mv hudson hudson_$enddate



