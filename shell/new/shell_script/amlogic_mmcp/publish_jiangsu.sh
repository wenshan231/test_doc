
#! /bin/bash
# This script is auto make jiangsu mmcp_publish

prj=$1
dir=$2

allpath=/hudson16/$prj
workpath=$allpath/$dir
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
lib_path=$workpath/lib/hi3716M_hisiv200/release

if [ -d $workpath/lib/mmcp_publish ]
then
	rm $workpath/lib/mmcp_publish -rf
fi
mkdir $workpath/lib/mmcp_publish -p

echo -e "============= now, begin to make jiangsu_hi3716m mmcp_publish ============" >> $log_file
echo -e "============= now, begin to make jiangsu_hi3176m mmcp_publish ============"
if [ -d $workpath/lib/mmcp_publish ]
then
	rm $workpath/lib/mmcp_publish -rf
fi

##produce:jiangsu_hi3716M_Cloud2
product_name=jiangsu_hi3716M_Cloud2
mkdir $workpath/lib/mmcp_publish/$product_name -p
jiangsu_path=$workpath/integration/product/$product_name
cp $lib_path/*.a $jiangsu_path/mmcp_lib/hi3716M_hisiv200

env_list="cm 2eth cm_eth eoc 2eth_256 cm_256 eoc_256"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m nanjing skyworth $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/nanjing/skyworth/mmcp_publish_hi3716M_hisiv200_nanjing_skyworth_$envname $workpath/lib/mmcp_publish/$product_name
   done

env_list="eoc cm"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m nanjing panda $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/nanjing/panda/mmcp_publish_hi3716M_hisiv200_nanjing_panda_$envname $workpath/lib/mmcp_publish/$product_name
   done

env_list="eth"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m shuyang yinhe $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/yinhe/mmcp_publish_hi3716M_hisiv200_yinhe_$envname $workpath/lib/mmcp_publish/$product_name
   done

##produce:jiangsu_wifi
product_name=jiangsu_wifi
mkdir $workpath/lib/mmcp_publish/$product_name -p
jiangsu_path=$workpath/integration/product/$product_name
cp $lib_path/*.a $jiangsu_path/mmcp_lib/hi3716M_hisiv200

env_list="eth eoc cm_eth cm"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m nanjing skyworth $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/nanjing/skyworth/mmcp_publish_hi3716M_hisiv200_nanjing_skyworth_$envname $workpath/lib/mmcp_publish/$product_name
   done

env_list="eoc cm"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m nanjing panda $envname
      make clean
      make
      make publish
      echo -----src:$jiangsu_path/porting/hi3716M_hisiv200/panda/mmcp_publish_hi3716M_hisiv200_panda--------------------------------
      echo -----dst:$workpath/lib/mmcp_publish/$product_name--------------------------------
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/nanjing/panda/mmcp_publish_hi3716M_hisiv200_nanjing_panda_$envname $workpath/lib/mmcp_publish/$product_name
    done


##produce:yixing_hi3716M
product_name=yixing_hi3716M
mkdir $workpath/lib/mmcp_publish/$product_name -p
jiangsu_path=$workpath/integration/product/$product_name
cp $lib_path/*.a $jiangsu_path/mmcp_lib/hi3716M_hisiv200

env_list="dvn_2eth tf_2eth"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m skyworth $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/skyworth/mmcp_publish_hi3716M_hisiv200_skyworth_$envname $workpath/lib/mmcp_publish/$product_name
   done


##produce:jiangsu_hotel_cloud2
product_name=jiangsu_hotel_cloud2
mkdir $workpath/lib/mmcp_publish/$product_name -p
jiangsu_path=$workpath/integration/product/$product_name
cp $lib_path/*.a $jiangsu_path/mmcp_lib/hi3716M_hisiv200

env_list="eth eoc 2eth_wifi eoc_wifi cm_wifi"
for envname in $env_list
   do
      cd $jiangsu_path
      . setupenv --m skyworth $envname
      make clean
      make
      make publish
      cp -r $jiangsu_path/porting/hi3716M_hisiv200/skyworth/mmcp_publish_hotel_skyworth_$envname $workpath/lib/mmcp_publish/$product_name
   done


