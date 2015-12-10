#!/bin/bash
######################### write by whh 4/28/2014 ########################
workspace=$1
mmcp_dst_path=$2
pakage_info=$workspace/package/log_version_mmcp.txt
echo " Begin copy amlogic mmcp" > $workspace/package/log_version_mmcp.txt
###  com.coship.mmcp510.apk && libmmcp510_jni.so
#501apk_src_path=/home/hudson/jobs/com.coship.mmcp510.merge/lastSuccessful/archive/output
###  dtvmxlib.jar
dtvmxlib_src_path=/home/hudson/jobs/dtvmx_jar_AmS802/lastSuccessful/archive/output
###  libmmcp_product.so 
product_server_path=/home/hudson/jobs/delivery_android_AmS802/lastSuccessful/archive/delivery/lib/mmcp_publish/OTT_DVB
### libmmcp_product_client.so  
product_client_path=/home/hudson/jobs/delivery_android_AmS802_Client/lastSuccessful/archive/delivery/lib/mmcp_publish/OTT_DVB
###
#cd $501apk_src_path
#pakage_version=`ls *.tar.gz`  
#echo $pakage_version
#if [ "$pakage_version" == "" ]
#then
#	echo "not 501apk exist \n " >> $workspace/package/log_version_mmcp.txt
#else 
#	echo "copy 510apk,510apk version: $pakage_version \n" >> $workspace/package/log_version_mmcp.txt
#	cd $mmcp_dst_path
#	rm -rf *.tag.gz
#	cp -f $501apk_src_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_m#mcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt
#fi
###
cd $dtvmxlib_src_path
pakage_version=`ls dtvmxlib.jar`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not dtvmxlib.jar exist \n " >> $workspace/package/log_version_mmcp.txt
else
	echo "copy dtvmxlib.jar,dtvmxlib.jar version: $pakage_version \n" >> $workspace/package/log_version_mmcp.txt
	cd $mmcp_dst_path
	rm -rf dtvmxlib.jar
	cp -f $dtvmxlib_src_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt
fi
###mmcp_product.so
cd $product_server_path
pakage_version=`ls libmmcp_product.so`  
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not libmmcp_product.so exist \n " >> $workspace/package/log_version_mmcp.txt
else
	echo "copy libmmcp_product.so,libmmcp_product.so version: $pakage_version \n" >> $workspace/package/log_version_mmcp.txt
	cd $mmcp_dst_path
	rm -rf libmmcp_product.so
	cp -f $product_server_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt
fi
###libmmcp_product_client.so
cd $product_client_path
pakage_version=`ls libmmcp_product.so`  
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not libmmcp_product_client.so exist \n " >> $workspace/package/log_version_mmcp.txt
else
	cd $mmcp_dst_path
	rm -rf libmmcp_product_client.so
	cp -f $product_client_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt

fi

