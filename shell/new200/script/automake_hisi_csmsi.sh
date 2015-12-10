#! /bin/bash
basespace=$1
workspace=$2
outspace=$3

#basespace=/home/hudson/hisi_csmsi
#workspace=/home/hudson/hisi_csmsi/external/coship/csmsi
#outspace=$basespace/out/target/product/Hi3716CV200/system

export HiAndroid=/home/hudson/hisi3716CV200_android/porting_hisi_Hi3716C_V200_Android/porting/hisi/Hi3716C_V200_Android/Android/Android4.2
cd $workspace
gitverline=`git log -1|head -1`
apkver=${gitverline:7:7}
cd $basespace
source  build/envsetup.sh
lunch Hi3716CV200-eng
export CM_BUILD=Hi3716CV200
export CM_TEST=TRUE
export PATH=/opt/hisi-linux/x86-arm/arm-hisiv200-linux/target/bin:$PATH
cd $basespace/external/coship/csmsi
. setupenv.sh hisi
mm -B

#create packages

cd $workspace
rm -rf output
mkdir -p output/csmsi/system/app output/csmsi/system/lib/hw output/csmsi/system/lib/modules output/csmsi/system/bin output/csmsi/system/usr/idc output/csmsi/system/usr/keylayout output/csmsi/dlna
cp Readme.txt pushcsmsi.bat $workspace/output/csmsi
cp version/version.h $workspace/output/csmsi
cp $basespace/out/target/common/obj/JAVA_LIBRARIES/stp.homeplayerlib_intermediates/classes-full-debug.jar $workspace/output/csmsi/dlna/stp.homeplayerlib.jar
cd $outspace/app
cp mmkcontrol.apk com.coship.airplayservice.apk wfd.apk $workspace/output/csmsi/system/app
cd $outspace/lib
cp libeasybus.so libmmk_jni.so libairplay.so libairplayjni.so libmiracast.so $workspace/output/csmsi/system/lib
cp $outspace/lib/hw/sensors.bigfish.so $workspace/output/csmsi/system/lib/hw
cp $outspace/bin/easycontrol $workspace/output/csmsi/system/bin
cd $outspace/bin
cp dnssd mdnsd $workspace/output/csmsi/system/bin
cp $outspace/lib/libmdnssd.so $workspace/output/csmsi/system/lib
cp $outspace/lib/modules/vinput_drv.ko $workspace/output/csmsi/system/lib/modules
cp $outspace/usr/idc/Stp_MT-touch.idc $workspace/output/csmsi/system/usr/idc
cp $outspace/usr/idc/Stp_touch.idc $workspace/output/csmsi/system/usr/idc
cp $outspace/usr/keylayout/Vendor_2013_Product_0923.kl $workspace/output/csmsi/system/usr/keylayout
cd $workspace/output
tar -czvf $workspace/output/hisi-csmsi\_git_$apkver\_`date "+%Y%m%d%H%M%S"`.tar.gz *