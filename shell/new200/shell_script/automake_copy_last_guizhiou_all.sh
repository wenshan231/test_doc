#!/bin/bash
#########write by qiaoting 4/23/2013
#copy from 6a801
prj=$1
prj_6a801=$2
workspace=/home/hudson/$prj
#workspace_6a801=/home/ott-admin/hudson/jobs/6a801/lastSuccessful/archive
workspace_6a801=/home/ott-admin/.hudson/jobs/$prj_6a801/lastSuccessful/archive

pakage_info= /home/hudson/$prj/log_version.txt

cd $workspace && rm -fr package && mkdir package
echo "`date "+%Y%m%d%H%M%S"` Begin copy all compiled package to S1001"  > $workspace/log_version.txt
cd $workspace_6a801/output/
pakage_version=`ls stp_package_mstar6a801_*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then echo "not 6a801 new package \n" >> $workspace/log_version.txt
else 
echo "copy platform 6a801 pakage,6a801 version: $pakage_version \n" >> $workspace/log_version.txt 
cd $workspace/platform/
rm -f stp_package_mstar6a801.tar.gz
cp -f $workspace_6a801/output/$pakage_version    $workspace/platform/ && echo "copy $pakage_version ok"  >> $workspace/log_version.txt  || echo "copy $pakage_version error"  >> $workspace/log_version.txt

cp -f $workspace_6a801/output/$pakage_version    $workspace/package/ 
mv $workspace/platform/$pakage_version  $workspace/platform/stp_package_mstar6a801.tar.gz  && echo "mv $pakage_version ok"  >> $workspace/log_version.txt  || echo "mv $pakage_version error"  >> $workspace/log_version.txt

fi

echo -e "" >> $workspace/log_version.txt  



mmcp_list="libmmcp510_jni.so libmmcp_product_client.so libmmcpdata.so"
mmcp_list_path_from=/home/ott-admin/share_5.176/guizhou_android_6a801_client
mmcp_list_path_to=$workspace/stp_integration/6a801.demo/stp_custom/system/lib
cd $mmcp_list_path_from
mmcp_list_last_version=`ls -ct | head -1`
cd $mmcp_list_path_to
rm -f $mmcp_list && \
cd $mmcp_list_path_from/$mmcp_list_last_version/lib/lib/mmcp_publish && \
cp -f $mmcp_list  $mmcp_list_path_to && \
cp -f $mmcp_list  $workspace/package/ && \
echo "cp $mmcp_list_path_from/$mmcp_list_last_version/lib/lib/mmcp_publish/$mmcp_list  ok" >> $workspace/log_version.txt || echo " cp  $mmcp_list_path_from/$mmcp_list_last_version/lib/lib/mmcp_publish/$mmcp_list failed" >> $workspace/log_version.txt

mmcp_product_list="libmmcp_product.so"
mmcp_product_path_from=/home/ott-admin/share_5.176/guizhou_android_6a801
mmcp_product_path_to=$workspace/stp_integration/6a801.demo/stp_custom/system/lib
cd $mmcp_product_path_from
mmcp_product_last_version=`ls -ct | head -1`
cd $mmcp_product_path_to
rm -f $mmcp_product_list && \
cd $mmcp_product_path_from/$mmcp_product_last_version/lib/lib/mmcp_publish && \
cp -f $mmcp_product_list  $mmcp_product_path_to && \
cp -f $mmcp_product_list  $workspace/package/ && \
echo " cp  $mmcp_product_last_version/lib/lib/mmcp_publish/$mmcp_product_list  ok" >> $workspace/log_version.txt || echo "cp $mmcp_product_last_version/lib/lib/mmcp_publish/$mmcp_product_list  failed" >> $workspace/log_version.txt


mmcp_framework_list="dtvmxlib.jar"
mmcp_framework_path_from=/home/ott-admin/share_5.176/guizhou_android_6a801
mmcp_framework_path_to=$workspace/stp_integration/6a801.demo/stp_custom/system/framework
cd $mmcp_framework_path_from
mmcp_framework_last_version=`ls -ct | head -1`
echo $mmcp_framework_last_version
cd $mmcp_framework_path_to
rm -f $mmcp_framework_list && \
cd $mmcp_framework_path_from/$mmcp_framework_last_version/lib/lib/mmcp_publish  && \
cp -f $mmcp_framework_list  $mmcp_framework_path_to/ && \
cp -f $mmcp_framework_list  $workspace/package/ && \
echo " cp  $mmcp_framework_path_from/$mmcp_framework_last_version/lib/lib/mmcp_publish/$mmcp_framework_list  ok" >> $workspace/log_version.txt || echo "cp  $mmcp_framework_path_from/$mmcp_framework_last_version/lib/lib/mmcp_publish/$mmcp_framework_list failed" >> $workspace/log_version.txt





mmcp_apk_list="com.coship.mmcp510.apk"
mmcp_apk_path_from=/home/ott-admin/share_5.176/guizhou_android_6a801
mmcp_apk_path_to=$workspace/stp_integration/6a801.demo/stp_custom/system/app
cd $mmcp_apk_path_from
mmcp_apk_last_version=`ls -ct | head -1`
echo $mmcp_apk_last_version
cd $mmcp_apk_path_to
rm -f $mmcp_apk_list && \
cd $mmcp_apk_path_from/$mmcp_apk_last_version/lib/lib/mmcp_publish && \
cp -f $mmcp_apk_list  $mmcp_apk_path_to && \
cp -f $mmcp_apk_list  $workspace/package/ && \
echo " cp  $mmcp_apk_last_version/lib/lib/mmcp_publish/$mmcp_apk_list  ok" >> $workspace/log_version.txt || echo "cp  $mmcp_apk_last_version/lib/lib/lib/lib/mmcp_publish/$mmcp_apk_list  failed" >> $workspace/log_version.txt
chmod -R a+x $workspace/stp_integration/6a801.demo/stp_custom/system
#sudo chmod -R a+x $workspace/stp_integration/6a801.demo/stp_custom/system

 



#apk_dist_dir=/home/hudson/$prj/stp_integration/6a801.demo/stp_custom/system/app
#cd $apk_dist_dir

#for apk_mdl in $apk_list
#do
#        i=$(($i+1))
#        cd $src_path/$apk_mdl
#	last_version=`ls -ct | head -1`
#	cat $last_version
#	cd $last_version/bin
#	pakage_version=`ls *$apk_mdl.apk`
#	echo $pakage_version
#        if [ "$pakage_version" == "" ]
#        then
#                echo "$i not $apk_mdl new package " >> $workspace/log_version.txt
#        else
#                echo "$i copy $last_version/bin/$pakage_version begin" >> $workspace/log_version.txt
#                cd $apk_dist_dir
#		
#        fi
#        echo -e "" >> $workspace/log_version.txt
#done










 
