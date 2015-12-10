#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2014/02/20)

platform=$1
platform_flag2=$2
workspace=/home/hudson/project/taiwan_$platform_flag2\/delivery
make_workspace=/home/hudson/project/taiwan_$platform_flag2\/delivery/integration/product/taiwan_android_merge
output_path=$make_workspace\/mmcp_lib/$platform


cd $make_workspace
pwd

svn_version=`head -11 $make_workspace/.svn/entries | tail -1`
log_file=$workspace/output/mmcp_product/svn\_$svn_version.log
echo -e "====================== libmmcp_product.so :$svn_version =====================" >> $log_file
##¹¤³Ì°æ±¾ºÅ¹ÜÀí
cd $make_workspace
svn info >> $workspace/output/mmcp.txt

echo setenv_$platform_flag2\_debug 
. setupenv --ia setenv_$platform_flag2\_debug coship
make clean
make USE_PRODUCT_LIB=y
if [ "$platform_flag2" = "Android_Hi3716C_V200" ]
then
echo "begin to make bin "
make bin
cp $make_workspace/bin/libmmcpdata*.so  $workspace/output/mmcp_product/
echo " make bin end "
fi
if [ -f $output_path/libmmcp_product*.so ] 
then
	echo "compile .so ok"
	cp $output_path/libmmcp_product*.so  $workspace/output/mmcp_product/
	exit 0
else
		echo "compile .so error"
	exit 1
fi 
