#!/bin/bash
echo "!!!!!!!!!!!!!!!build rom start!!!!!!!!!!!!!!!!!"

#脚本运行当前路径
#TOPDIR=/home/hudson/hisi3716c_v200_intergration

#工作目录
WORKDIR=/home/hudson/hisi3716c_v200_intergration

#CM构建根路径
#CMDIR=/home/hudson/jobs/CyanogenMod_cm-10.1-coship/lastSuccessful/archive/output
CMDIR=$1
#mmcp server构建根路径
#MMCP510DIR_server=/home/ott-admin/share_5.176/taiwan_Android_Hi3716C_V200/lastSuccessful/archive/delivery/output/mmcp_product
MMCP510DIR_server=$2
#mmcp client构建根路径
#MMCP510DIR_client=/home/ott-admin/share_5.176/taiwan_Android_Hi3716C_V200_Client/lastSuccessful/archive/delivery/output/mmcp_product
MMCP510DIR_client=$3
#mmcp dtvmxjar构建根路径
#MMCP510DIR_dtvmxjar=/home/ott-admin/share_5.176/dtvmx_jar/lastSuccessful/archive/dtvmx/bin
MMCP510DIR_dtvmxjar=$4
#mmcp510apk构建根路径
#MMCP510APKDIR=/home/hudson/jobs/com.coship.mmcp510.merge/lastSuccessful/archive/output
MMCP510APKDIR=$5
#多屏互动构建根路径
#MUILTSCREENDIR=/home/hudson/jobs/hisi_csmsi/lastSuccessful/archive/output
MUILTSCREENDIR=$6
#调试选项，是否查看解压缩过程
Verbose=v

#准备工作
prepare_workdir(){
	echo "!!!!!!!!!!!!!!!prepare workdir!!!!!!!!!!!!!!!!!"
	rm -rf $WORKDIR
	mkdir $WORKDIR
	echo "!!!!!!!!!!!!!!!cp $CMDIR!!!!!!!!!!!!!!!!!" > $WORKDIR/copylist.txt
	cd $WORKDIR
	ls -l $CMDIR/* >> $WORKDIR/copylist.txt
	cp $CMDIR/* $WORKDIR/ -rf && echo "cp_mmcp510_release_server OK"  >> $WORKDIR/copylist.txt || echo "cp_mmcp510_release_server error" >> $WORKDIR/copylist.txt
	mkdir temp
	
	echo "!!!!!!!!!!!!!!!cp cm-10.1-coship_Hi3716CV200 release!!!!!!!!!!!!!!!!!"
	cp cm-10.1-coship_Hi3716CV200_release2integration_* temp 
	
	echo "!!!!!!!!!!!!!!!tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_.tar.gz!!!!!!!!!!!!!!!!!"
	cd temp
	tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_*
	echo "!!!!!!!!!!!!!!!tar x"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration_*.tar.gz over!!!!!!!!!!!!!!!!!"
  
}

#集成mmcp server中间件
cp_mmcp510_release_server(){
	
	cd $WORKDIR
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release!!!!!!!!!!!!!!!!!"
	ls -l $MMCP510DIR_server/libmmcp_product.so >> $WORKDIR/copylist.txt
	cp $MMCP510DIR_server/libmmcp_product.so $WORKDIR/temp/target_files/SYSTEM/lib && echo "cp_mmcp510_release_server OK" >> $WORKDIR/copylist.txt || echo "cp_mmcp510_release_server error" >> $WORKDIR/copylist.txt
	#cp $MMCP510DIR_server/libmmcpdata.so $WORKDIR/temp/target_files/SYSTEM/lib
}


#集成mmcp client中间件
cp_mmcp510_release_client(){
	cd $WORKDIR
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release_client!!!!!!!!!!!!!!!!!"
	ls -l $MMCP510DIR_client/libmmcp_product_client.so >> $WORKDIR/copylist.txt
	cp $MMCP510DIR_client/libmmcp_product_client.so $WORKDIR/temp/target_files/SYSTEM/lib && echo "cp_mmcp510_release_client OK" >> $WORKDIR/copylist.txt  || echo "cp_mmcp510_release_client error" >> $WORKDIR/copylist.txt
	#cp $MMCP510DIR/libmmcpdata.so $WORKDIR/temp/target_files/SYSTEM/lib
}



#集成dtvmxjar中间件
cp_mmcp510_release_dtvmxjar(){
	
	cd $WORKDIR	
	echo "!!!!!!!!!!!!!!!cp_mmcp510_dtvmxjar!!!!!!!!!!!!!!!!!"
	
	ls -l  $MMCP510DIR_dtvmxjar/dtvmxlib.jar  >>  $WORKDIR/copylist.txt
	cp $MMCP510DIR_dtvmxjar/dtvmxlib.jar $WORKDIR/temp/target_files/SYSTEM/framework/ && echo "cp_mmcp510_dtvmxja OK"  >> $WORKDIR/copylist.txt || echo "cp_mmcp510_dtvmxja error"  >> $WORKDIR/copylist.txt
}




#集成mmcp510apk
cp_mmcp510apk_release(){
	cd $WORKDIR
	echo "!!!!!!!!!!!!!!!cp_mmcp510apk_release!!!!!!!!!!!!!!!!!"
	ls -l $MMCP510APKDIR/*  >> $WORKDIR/copylist.txt
	cp $MMCP510APKDIR/510.apk $WORKDIR/temp/target_files/SYSTEM/app
	cp $MMCP510APKDIR/libmmcp510_jni.so $WORKDIR/temp/target_files/SYSTEM/lib && echo "cp_mmcp510apk_release OK"  >> $WORKDIR/copylist.txt || echo "cp_mmcp510apk_release error"  >> $WORKDIR/copylist.txt
}

#发布
release2integration(){
	echo "!!!!!!!!!!!!!!!release2integration!!!!!!!!!!!!!!!!!"
	
	cd $WORKDIR/temp/
	
	#打包压缩文件
	rm -rf cm-10.1-coship_Hi3716CV200_release2integration_*
	tar zc"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration.tar.gz *
	rm -rf ../cm-10.1-coship_Hi3716CV200_release2integration_*
	mv cm-10.1-coship_Hi3716CV200_release2integration.tar.gz ../
	
	#制作system.img文件
	tools/bin/make_ext4fs -s -l 500M -a system system.img target_files/SYSTEM
	mv system.img ../platform
}

#清理垃圾文件
relase_over(){
	echo "!!!!!!!!!!!!!!!relase_over!!!!!!!!!!!!!!!!!"
	
	cd $WORKDIR/
	
	rm -rf temp
	
	echo "!!!!!!!!!!!!!!!relase_over!!!!!!!!!!!!!!!!!"
}

prepare_workdir
cp_mmcp510_release_server
cp_mmcp510_release_client
cp_mmcp510_release_dtvmxjar
cp_mmcp510apk_release
pause
release2integration
relase_over 