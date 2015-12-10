#! /bin/bash
# This script is auto make mmcp  incream
# @author: whh (on 2014/02/20)
prj=$1
platform=$2
productname=$3

workspace=/home/hudson/project/$prj/integration/product/$productname
product_version=`head -11 $workspace/.svn/entries | tail -1`

cd $workspace
rm -fr output 
mkdir output output/mmcp output/binder output/mmcp_publish


log_file=$workspace/output/mmcp_publish/svn\_$product_version.log
echo -e "====================== libmmcp_product.so :$product_version =====================" >> $log_file

mmcp_autocopy_path_dir=/home/hudson/publisher/delivery_$platform
mmcp_autocopy_version=`ls -ct $mmcp_autocopy_path_dir | head -1`
mmcp_autocopy_path=/home/hudson/publisher/delivery_$platform\/$mmcp_autocopy_version\/lib/lib/Android_Hi3716C_V200/debug
mmcp_dist=$workspace/mmcp_lib/Android_Hi3716C_V200
cp -f $mmcp_autocopy_path/libcfg_ottdvb_hi3716C_V200*.a   $mmcp_dist
cp -f $mmcp_autocopy_path/libcfg_ottdvb_hi3716C_V200*.a   $workspace/output/mmcp
cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $mmcp_dist
cp -f $mmcp_autocopy_path/libmmcp_ew510*.a  $workspace/output/mmcp
cp -f $mmcp_autocopy_path/../../../mmcp.txt  $workspace/output/



bind_autocopy_path=/home/hudson/public_96.200/bindermanager/lastSuccessful/archive/output
bind_dist=$workspace/porting/Android_Hi3716C_V200/coship/lib/androidlib
cd $bind_autocopy_path
ll *
cd $workspace && rm -fr tmp && mkdir tmp
cp $bind_autocopy_path/bindermanager*.tar.gz $workspace/output/binder
cp $bind_autocopy_path/bindermanager*.tar.gz $workspace/tmp
cd $workspace/tmp && tar -xvf bindermanager*.tar.gz  
cd $workspace/tmp &&  filelist_del=`find ./ -name "*provider.a"` && rm -f $filelist_del &&  filelist=`find ./ -name "*.a"` 
cp -f $workspace/tmp/$filelist $bind_dist/
cp $bind_autocopy_path/binder.txt $workspace/output



cd $workspace
svn info >> $workspace/output/mmcp.txt
echo "--------begin to make project-----------------------"
. setupenv --ia setenv_$platform\_debug coship
make clean
make USE_PRODUCT_LIB=y >> $log_file  2>&1
#if [ "$platform" = "Android_Hi3716C_V200" ]
#then
echo "begin to make bin "
make bin
cp $workspace/bin/libmmcpdata*.so  $workspace/output/mmcp_publish/
echo " make bin end "
#fi

output_path=$workspace\/mmcp_lib/Android_Hi3716C_V200



##copy to pub
creattime=`date +%Y%m%d%H%M`
pubdir=/home/tmp/$prj/$creattime\_product$product_version
mkdir -p $pubdir
cp -r $workspace/output $pubdir

if [ -f $output_path/libmmcp_product*.so ] 
then
	echo "---------compile libmmcp_product.so ok-------------"
	cp $output_path/libmmcp_product*.so  $workspace/output/mmcp_publish/
	cp $workspace/output/*.txt $workspace/output/mmcp_publish/
	rm -rf /home/tmp/$prj/mmcp_publish
	cp -r $workspace/output/mmcp_publish  /home/tmp/$prj
	exit 0
else
	echo "-------compile libmmcp_product.so error-----------"
	exit 1
fi 
