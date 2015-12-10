#!/bin/bash
echo "!!!!!!!!!!!!!!!build rom start!!!!!!!!!!!!!!!!!"

#脚本运行当前路径
#TOPDIR=/home/hudson/script/Ams802

#工作目录
WORKPATH=/home/hudson/project/amlogics802_OTTDVB_Inspection
WORKDIR=/home/hudson/project/amlogics802_OTTDVB_Inspection/package

#CM构建根路径
#CMDIR=/home/hudson/jobs/CyanogenMod_cm-10.1-coship/lastSuccessful/archive/output
#CMDIR=$1

#mmcp server构建根路径
MMCP510DIR_server=/home/ott-admin/hudson/jobs/delivery_android_AmS802/lastSuccessful/archive/delivery/lib/mmcp_publish/
#MMCP510DIR_server=$2

#mmcp client构建根路径
MMCP510DIR_client=/home/ott-admin/hudson/jobs/delivery_android_AmS802_Client/lastSuccessful/archive/delivery/lib/mmcp_publish/OTT_DVB
#MMCP510DIR_client=$3

#mmcp dtvmxjar构建根路径
MMCP510DIR_dtvmxjar=/home/ott-admin/share_5.176_new/dtvmx_jar/lastSuccessful/archive/dtvmx/bin
#MMCP510DIR_dtvmxjar=$4

#mmcp510apk构建根路径
MMCP510APKDIR=/home/hudson/jobs/com.coship.mmcp510.merge/lastSuccessful/archive/output
#MMCP510APKDIR=$5

#多屏互动构建根路径
MUILTSCREENDIR=/home/ott-admin/hudson/share_5.161/CBB_csmsi_amlogic4.3/lastSuccessful/archive/output
#MUILTSCREENDIR=$6

#驱动构建根路径
PORTINGDIR=/home/hudson/jobs/hisi3716CV200_android/lastSuccessful/archive/porting_hisi_Hi3716C_V200_Android/lib
#PORTINGDIR=$7

#二次开发包路径
STPPACKAGEDIR=/home/ott-admin/hudson/jobs/amlogics802_develop/lastSuccessful/archive/autobuild/output


#调试选项，是否查看解压缩过程
Verbose=v

#二次开发包
PACKAGE_NAME=stp_package_amlogics802_*.tar.gz
TARGET_FILES_DIR=$WORKDIR/temp/target_files


#日期
datestr=`date +%Y-%m-%d`

myexit() {
	echo "error: mk_product.sh error, exit at $1 !!!" && exit $1;
}

checkFileAndExit() {
	if [ ! -e $1 ]; then
		echo "error: $1 not exist!!!" && myexit $LINENO
	fi
}


#准备工作
prepare_workdir(){
	echo "!!!!!!!!!!!!!!!prepare workdir!!!!!!!!!!!!!!!!!"
	cd $WORKPATH
	rm -rf $WORKDIR
	mkdir $WORKDIR
	#echo "*******************1.cp $CMDIR" > $WORKDIR/copylist.txt
	cd $WORKDIR
	#ls -l $CMDIR >> $WORKDIR/copylist.txt
	#cp $CMDIR/* $WORKDIR/ -rf && echo " cp $CMDIR OK"  >> $WORKDIR/copylist.txt || echo "cp $CMDIR error" >> $WORKDIR/copylist.txt
	mkdir temp
	
	#echo "!!!!!!!!!!!!!!!cp cm-10.1-coship_Hi3716CV200 release!!!!!!!!!!!!!!!!!"
	#cp cm-10.1-coship_Hi3716CV200_release2integration_* temp 
	
	#echo "!!!!!!!!!!!!!!!tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_.tar.gz!!!!!!!!!!!!!!!!!"
	cd temp
	mkdir target_files
	#tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_*
	#echo "!!!!!!!!!!!!!!!tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_*.tar.gz over!!!!!!!!!!!!!!!!!"
  
}

extractPlatformPkg() {
	echo ""
	echo "tar xvf $PLATFORM_PACKAGE  $INTEGRATION_DIR/"
	cd $WORKDIR/temp/
	tar xvf $PACKAGE_NAME  || myexit $LINENO
	tar xvf porting_* || myexit $LINENO
	checkFileAndExit $WORKDIR/temp/stp_package_amlogics802
	checkFileAndExit $WORKDIR/temp/stp_package_amlogics802/k200-out-files
	checkFileAndExit $WORKDIR/temp/stp_package_amlogics802/tools
	checkFileAndExit $WORKDIR/temp/stp_package_amlogics802/k200-target_files-*.zip
	checkFileAndExit $WORKDIR/temp/porting/SYSTEM/lib
	cd stp_package_amlogics802
	unzip k200-target_files-*.zip -d $TARGET_FILES_DIR/ || myexit $LINENO
	
	checkFileAndExit $TARGET_FILES_DIR/SYSTEM/lib
	cp $WORKDIR/temp/porting/SYSTEM/lib/libporting.so  $TARGET_FILES_DIR/SYSTEM/lib
	cp $WORKDIR/temp/porting/SYSTEM/lib/libporting_client.so  $TARGET_FILES_DIR/SYSTEM/lib
	
	echo "  extract platform package ok!!!"
}


#拷贝二次开发包和驱动的库
cp_stp_package(){
 cd $WORKDIR
	echo "\n******1.cp stp_package_amlogics802"
	ls -l $STPPACKAGEDIR >> copylist.txt
	cp $STPPACKAGEDIR/stp_package_amlogics802* $WORKDIR/temp/ && \
	cp $STPPACKAGEDIR/porting_* $WORKDIR/temp/ && \
	echo "cp_stp_package OK" >> $WORKDIR/copylist.txt || echo "cp_stp_package error" >> $WORKDIR/copylist.txt
	extractPlatformPkg
}



#集成mmcp server中间件
cp_mmcp510_release_server(){
	
	cd $WORKDIR
	echo "\n\n\n\n\n*******************2.cp_mmcp510_release"
	ls -l $MMCP510DIR_server/OTT_DVB/* >> $WORKDIR/copylist.txt
	ls -l $MMCP510DIR_server/com.coship.mmcp510.apk >> $WORKDIR/copylist.txt
	ls -l $MMCP510DIR_server/dtvmxlib.jar >> $WORKDIR/copylist.txt
	ls -l $MMCP510DIR_server/libmmcp510_jni.so >> $WORKDIR/copylist.txt
	cp $MMCP510DIR_server/OTT_DVB/libmmcpdata_*.so $TARGET_FILES_DIR/SYSTEM/lib &&\
	cp $MMCP510DIR_server/OTT_DVB/libmmcp_product.so $TARGET_FILES_DIR/SYSTEM/lib &&\
	cp $MMCP510DIR_server/com.coship.mmcp510.apk $TARGET_FILES_DIR/SYSTEM/app &&\
	cp $MMCP510DIR_server/dtvmxlib.jar $TARGET_FILES_DIR/SYSTEM/framework &&\
	cp $MMCP510DIR_server/libmmcp510_jni.so $TARGET_FILES_DIR/SYSTEM/lib &&\
	echo "cp_mmcp510_release_server OK" >> $WORKDIR/copylist.txt || echo "cp_mmcp510_release_server error" >> $WORKDIR/copylist.txt
}

#集成mmcp client中间件
cp_mmcp510_release_client(){
	cd $WORKDIR
	echo "\n\n\n\n\n*******************3.cp_mmcp510_release_client"
	ls -l $MMCP510DIR_client/libmmcp_product_client.so >> $WORKDIR/copylist.txt
	cp $MMCP510DIR_client/libmmcp_product_client.so $TARGET_FILES_DIR/SYSTEM/lib && echo "cp_mmcp510_release_client OK" >> $WORKDIR/copylist.txt  || echo "cp_mmcp510_release_client error" >> $WORKDIR/copylist.txt
}



#集成多屏互动
cp_muiltscreen(){
	cd $WORKDIR
	echo "\n\n\n\n\n*******************6.cp_muiltscreen"
	ls -l $MUILTSCREENDIR/*  >> $WORKDIR/copylist.txt
	rm temp2 
	mkdir temp2
	cp $MUILTSCREENDIR/csmsi-amlogic.tar.gz temp2
	cd temp2
	tar x"$Verbose"f csmsi-amlogic.tar.gz &&＼
	cp csmsi/dlna/stp.homeplayerlib.jar $WORKDIR/temp/target_files/SYSTEM/framework/  &&\
	cp -r csmsi/system/app/*.apk $WORKDIR/temp/target_files/SYSTEM/app  &&\
	cp csmsi/system/bin/dnssd $WORKDIR/temp/target_files/SYSTEM/bin  &&\
	cp csmsi/system/bin/easycontrol $WORKDIR/temp/target_files/SYSTEM/bin  &&\
	cp csmsi/system/bin/mdnsd $WORKDIR/temp/target_files/SYSTEM/bin  &&\
	cp -r csmsi/system/lib/*.so $WORKDIR/temp/target_files/SYSTEM/lib  &&\
	cp -r csmsi/system/lib/hw $WORKDIR/temp/target_files/SYSTEM/lib  &&\
	cp -r csmsi/system/lib/modules $WORKDIR/temp/target_files/SYSTEM/lib  &&\
	cp -r csmsi/system/usr/idc $WORKDIR/temp/target_files/SYSTEM/usr  &&\
	cp -r csmsi/system/usr/keylayout $WORKDIR/temp/target_files/SYSTEM/usr  &&\
	
	cd $WORKDIR
	#cp ../system/bin/devsuffix  $WORKDIR/temp/target_files/SYSTEM/bin &&\
	echo "cp muiltscreen ok"  >> $WORKDIR/copylist.txt  || echo "cp muiltscreen error"  >> $WORKDIR/copylist.txt 
}



#集成驱动porting库
cp_porting(){
	cd $WORKDIR
	echo "\n\n\n\n\n*******************7.cp_porting"
	ls -l $PORTINGDIR/*  >> $WORKDIR/copylist.txt
	rm temp3 
  	mkdir temp3
	cp $PORTINGDIR/hisi3716CV200_android_git_* temp3
	cd temp3
	echo "!!!!!!!!!!!!!!!tar x"$Verbose"f hisi3716CV200_android_git_tar.gz!!!!!!!!!!!!!!!!!"
	tar x"$Verbose"f hisi3716CV200_android_git_*
	echo "!!!!!!!!!!!!!!!tar x"$Verbose"f hisi3716CV200_android_git_tar.gz over!!!!!!!!!!!!!!!!!"
	
	#集成testapp
	cd Hi3716C_V200_Android/stepbystep/20*
	tar x"$Verbose"f system.tar.gz
	cp system/bin/testapp $WORKDIR/temp/target_files/SYSTEM/bin &&\
	cd -
	
	cp Hi3716C_V200_Android/stepbystep/porting/libporting.so $WORKDIR/temp/target_files/SYSTEM/lib &&\
	cp Hi3716C_V200_Android/stepbystep/porting/libporting_client.so $WORKDIR/temp/target_files/SYSTEM/lib &&\
	echo  " cp porting ok"  >> $WORKDIR/copylist.txt  || echo  " cp porting error"  >> $WORKDIR/copylist.txt 
}


#集成直播apk
cp_playapk(){
	cd $WORKDIR
	echo "\n\n\n\n\n*******************8.cp_play apk"
	cd apps
	svn cleanup
	svn up
	cd $WORKDIR
	cp -r ../apps/*.apk $WORKDIR/temp/target_files/SYSTEM/app &&\
	#cp ../system/lib/*.so $WORKDIR/temp/target_files/SYSTEM/lib &&\
	#copyhisi烧录工具
	cp -r ../tools $WORKDIR
	echo "cp playapk ok"  >> $WORKDIR/copylist.txt  || echo  " cp playapk error"  >> $WORKDIR/copylist.txt 

}

#集成节目单方便拷机
cp_program(){

	cd $WORKDIR
	echo "\n\n\n\n\n*******************9.cp_program"
	cp -r ../databases $WORKDIR/temp/target_files/SYSTEM/lib &&\
	echo " cp_program ok"
}


#修改init.rc
cp_initrc(){	

	cd $WORKDIR
	echo "\n\n\n\n\n*******************10.cp_initrc"

	cat ../system/init.rc >> $WORKDIR/temp/target_files/BOOT/RAMDISK/init.rc &&\
	echo " cp_initrc ok"
}



#发布
release2integration(){
	echo "!!!!!!!!!!!!!!!release2integration!!!!!!!!!!!!!!!!!"
	
	cd  $WORKDIR/temp/stp_package_amlogics802
	#打包压缩文件
	
	rm -rf k200-target_files-*.zip
	cd $WORKDIR/temp/
	zip -r $WORKDIR/temp/stp_package_amlogics802/k200-target_files_$datestr.zip  target_files/*
	rm -rf $TARGET_FILES_DIR/
	cd  $WORKDIR/temp/ 
	rm -rf porting_*.tar.gz
	rm -rf porting
	
	tar zc"$Verbose"f stp_package_amlogics802_$datestr.tar.gz stp_package_amlogics802
	rm -rf stp_package_amlogics802
	mv stp_package_amlogics802_$datestr.tar.gz ../
	
	#制作system.img文件
	#tools/bin/make_ext4fs -s -l 500M -a system system.img target_files/SYSTEM
	#制作kernel.img文件
	#tools/bin/make_ext4fs -s -l 40M -a kernel kernel.img target_files/BOOT

	#mv kernel.img ../platform
	#mv system.img ../platform
}

#整理需要发布的img
cp_img(){
	echo "!!!!!!!!!!!!!!!cp_img!!!!!!!!!!!!!!!!!"
	cd $WORKDIR/platform

	cp -r *.img Hisi_origin_img
	
	cd Hisi_origin_img

	rm system.ext4
	rm userdata.ext4
	rm cache.ext4
	cd $WORKDIR/platform
	rm -rf *.img
	mv Hisi_origin_img emmc
	cd $WORKDIR
	
	cp ../ReadMe.txt $WORKDIR
	echo "!!!!!!!!!!!!!!!cp_img over!!!!!!!!!!!!!!!!!"
}


#清理垃圾文件
relase_over(){
	echo "!!!!!!!!!!!!!!!relase_over!!!!!!!!!!!!!!!!!"
	
	cd $WORKDIR/
	rm -rf temp
	echo "!!!!!!!!!!!!!!!relase_over!!!!!!!!!!!!!!!!!"
}

prepare_workdir
cp_stp_package
cp_mmcp510_release_server
cp_mmcp510_release_client
#cp_mmcp510_release_dtvmxjar
#cp_mmcp510apk_release
cp_muiltscreen
#cp_porting
#cp_playapk
#cp_program
release2integration
#cp_img
relase_over 
