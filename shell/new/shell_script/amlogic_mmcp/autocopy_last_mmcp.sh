#!/bin/bash
######################### write by whh 4/28/2014 ########################
workspace=$1
mmcp_dst_path=$2

pakage_info=$workspace/package/log_version_mmcp.txt
echo " Begin copy amlogic mmcp" > $workspace/package/log_version_mmcp.txt

dtvmxlib_src_path=/home/hudson/jobs/dtvmx_jar_AmS802/lastSuccessful/archive/output
501apk_src_path=/home/hudson/jobs/com.coship.mmcp510.merge/lastSuccessful/archive/output
##product_server_path=/home/hudson/jobs/delivery_android_AmS802/lastSuccessful/archive/delivery/lib/mmcp_publish/OTT_DVB
##product_client_path=/home/hudson/jobs/delivery_android_AmS802_Client/lastSuccessful/archive/delivery/lib/mmcp_publish/OTT_DVB
product_server_path=/home/hudson/jobs/delivery_android_AmS802/lastSuccessful/archive/output/2014*/lib/mmcp_publish/OTT_DVB
product_client_path=/home/hudson/jobs/delivery_android_AmS802_Client/lastSuccessful/archive/output/2014*/lib/mmcp_publish/OTT_DVB

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

cd $product_server_path
if [ $? -eq 0 ]
then
   echo "the right path " >> $workspace/package/log_version_mmcp.txt
fi
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
	cp -f $product_server_path/libmmcpdata*.so $mmcp_dst_path && echo "copy libmmcpdata*.so"  >> $workspace/package/log_version_mmcp.txt || echo "copy libmmcpdata*.so"  >> $workspace/package/log_version_mmcp.txt
fi
###copy libmmcp_product_client.so
cd $product_client_path
pakage_version=`ls libmmcp_product*.so`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "not libmmcp_product_client.so exist \n " >> $workspace/package/log_version_mmcp.txt
else
	cd $mmcp_dst_path
	rm -rf libmmcp_product_client.so
	cp -f $product_client_path/libmmcpdata*.so $mmcp_dst_path && echo "copy libmmcpdata*.so"  >> $workspace/package/log_version_mmcp.txt || echo "copy libmmcpdata*.so"  >> $workspace/package/log_version_mmcp.txt
	cp -f $product_client_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt
fi
