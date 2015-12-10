#!/bin/bash
######################### write by whh 4/28/2014 ########################
workspace=$1
mmcp_dst_path=$2

pakage_info=$workspace/package/log_version_mmcp.txt
echo " Begin copy amlogic mmcp" > $workspace/package/log_version_mmcp.txt

##dtvmxlib_src_path=/home/hudson/jobs/dtvmx_jar_AmS802/lastSuccessful/archive/output
dtvmxlib_src_path=$3
##501apk_src_path=/home/hudson/jobs/com.coship.mmcp510.merge/lastSuccessful/archive/output
apk_path=$4
echo "whh:$4" >> $workspace/package/log_version_mmcp.txt
echo "510apk_path:$apk_path" >> $workspace/package/log_version_mmcp.txt

##product_server_path=/home/hudson/jobs/delivery_android_AmS802/lastSuccessful/archive/output/2014*/lib/mmcp_publish/OTT_DVB
product_server_path=$5
##product_client_path=/home/hudson/jobs/delivery_android_AmS802_Client/lastSuccessful/archive/output/2014*/lib/mmcp_publish/OTT_DVB
product_client_path=$6

#dataso=$7

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




echo "510apk_path:$apk_path" >> $workspace/package/log_version_mmcp.txt
cd $apk_path
if [ $? -eq 0 ]
then
   echo "510 apk ,the right path " >> $workspace/package/log_version_mmcp.txt
   ls
fi
pakage_version=`ls com.coship.mmcp510.merge*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "510apk,not 510apk package exist " >> $workspace/package/log_version_mmcp.txt
else
	echo "copy 510apk,510apk version: $pakage_version \n" >> $workspace/package/log_version_mmcp.txt
	cd $mmcp_dst_path
	rm -rf com.coship.mmcp510.merge*.tar.gz
	cp -f $apk_path/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt
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
	cp -f $product_server_path/*.so  $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $product_server_path/*.so error"  >> $workspace/package/log_version_mmcp.txt

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
	cp -f $product_client_path/*.so $mmcp_dst_path && echo "copy libmmcpdata*.so"  >> $workspace/package/log_version_mmcp.txt || echo "copy *.so  error"  >> $workspace/package/log_version_mmcp.txt
fi


#cd $dataso
#pakage_version=`ls libmmcpdata_0851001.so`
#echo $pakage_version
#if [ "$pakage_version" == "" ]
#then
#        echo "not libmmcpdata_0851001.so exist \n " >> $workspace/package/log_version_mmcp.txt
#else
#        echo "copy libmmcpdata_0851001.so  version: $pakage_version \n" >> $workspace/package/log_version_mmcp.txt
#        cd $mmcp_dst_path
#        rm -rf libmmcpdata_0851001.so
#        cp -f $dataso/$pakage_version $mmcp_dst_path && echo "copy $pakage_version ok"  >> $workspace/package/log_version_mmcp.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_mmcp.txt

#fi
