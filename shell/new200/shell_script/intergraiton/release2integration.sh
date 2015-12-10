#!/bin/bash
echo "!!!!!!!!!!!!!!!build rom start!!!!!!!!!!!!!!!!!"

#脚本运行当前路径
TOPDIR=/home/

#工作目录
WORKDIR=/home/hudson/hisi3716c_v200_intergration

#CM构建根路径
#CMDIR=/home/huhuatao/release2integration
#mmcp server构建根路径
#MMCP510DIR_server=/home/huhuatao/mmcp510
#mmcp client构建根路径
#MMCP510DIR_client=/home/huhuatao/mmcp510
#mmcp dtvmxjar构建根路径
#MMCP510DIR_dtvmxjar=/home/ott-admin/share_5.176/dtvmx_jar/lastSuccessful/archive/dtvmx/bin
#mmcp510apk构建根路径
#MMCP510APKDIR=/home/huhuatao/mmcp510apk

#多屏互动构建根路径
#MUILTSCREENDIR=/home/huhuatao/muiltscreen

#调试选项，是否查看解压缩过程
Verbose=v

#准备工作
prepare_workdir(){
	echo "!!!!!!!!!!!!!!!prepare workdir!!!!!!!!!!!!!!!!!"
	rm -rf $WORKDIR
	mkdir $WORKDIR
	cd $WORKDIR
	
	echo "!!!!!!!!!!!!!!!cp $CMDIR!!!!!!!!!!!!!!!!!"
	cp $CMDIR/* ./ -rf
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
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release!!!!!!!!!!!!!!!!!"
	
	cp $MMCP510DIR/libmmcp_product.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
	#cp $MMCP510DIR/libmmcpdata.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}


#集成mmcp client中间件
cp_mmcp510_release_client(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release_client!!!!!!!!!!!!!!!!!"
	

	cp $MMCP510DIR/libmmcp_product_client.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
	#cp $MMCP510DIR/libmmcpdata.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}



#集成dtvmxjar中间件
cp_mmcp510_release_dtvmxjar(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510_dtvmxjar!!!!!!!!!!!!!!!!!"
	

	cp $/home/ott-admin/share_5.176/dtvmx_jar/lastSuccessful/archive/dtvmx/bin/dtvmxlib.jar $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/framework/
}




#集成mmcp510apk
cp_mmcp510apk_release(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510apk_release!!!!!!!!!!!!!!!!!"
	
	cp $MMCP510APKDIR/510.apk $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/app
	cp $MMCP510APKDIR/libmmcp510_jni.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}

#发布
release2integration(){
	echo "!!!!!!!!!!!!!!!release2integration!!!!!!!!!!!!!!!!!"
	
	cd $TOPDIR/$WORKDIR/temp/
	
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
	
	cd $TOPDIR/$WORKDIR/
	
	rm -rf temp
	
	echo "!!!!!!!!!!!!!!!relase_over!!!!!!!!!!!!!!!!!"
}

prepare_workdir
cp_mmcp510_release_server
cp_mmcp510_release_client
cp_mmcp510_release_dtvmxjar
cp_mmcp510apk_release
release2integration
relase_over