#!/bin/bash
echo "!!!!!!!!!!!!!!!build rom start!!!!!!!!!!!!!!!!!"

#�ű����е�ǰ·��
TOPDIR=/home/

#����Ŀ¼
WORKDIR=/home/hudson/hisi3716c_v200_intergration

#CM������·��
#CMDIR=/home/huhuatao/release2integration
#mmcp server������·��
#MMCP510DIR_server=/home/huhuatao/mmcp510
#mmcp client������·��
#MMCP510DIR_client=/home/huhuatao/mmcp510
#mmcp dtvmxjar������·��
#MMCP510DIR_dtvmxjar=/home/ott-admin/share_5.176/dtvmx_jar/lastSuccessful/archive/dtvmx/bin
#mmcp510apk������·��
#MMCP510APKDIR=/home/huhuatao/mmcp510apk

#��������������·��
#MUILTSCREENDIR=/home/huhuatao/muiltscreen

#����ѡ��Ƿ�鿴��ѹ������
Verbose=v

#׼������
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

#����mmcp server�м��
cp_mmcp510_release_server(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release!!!!!!!!!!!!!!!!!"
	
	cp $MMCP510DIR/libmmcp_product.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
	#cp $MMCP510DIR/libmmcpdata.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}


#����mmcp client�м��
cp_mmcp510_release_client(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510_release_client!!!!!!!!!!!!!!!!!"
	

	cp $MMCP510DIR/libmmcp_product_client.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
	#cp $MMCP510DIR/libmmcpdata.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}



#����dtvmxjar�м��
cp_mmcp510_release_dtvmxjar(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510_dtvmxjar!!!!!!!!!!!!!!!!!"
	

	cp $/home/ott-admin/share_5.176/dtvmx_jar/lastSuccessful/archive/dtvmx/bin/dtvmxlib.jar $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/framework/
}




#����mmcp510apk
cp_mmcp510apk_release(){
	echo "!!!!!!!!!!!!!!!cp_mmcp510apk_release!!!!!!!!!!!!!!!!!"
	
	cp $MMCP510APKDIR/510.apk $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/app
	cp $MMCP510APKDIR/libmmcp510_jni.so $TOPDIR/$WORKDIR/temp/target_files/SYSTEM/lib
}

#����
release2integration(){
	echo "!!!!!!!!!!!!!!!release2integration!!!!!!!!!!!!!!!!!"
	
	cd $TOPDIR/$WORKDIR/temp/
	
	#���ѹ���ļ�
	rm -rf cm-10.1-coship_Hi3716CV200_release2integration_*
	tar zc"$Verbose"f cm-10.1-coship_Hi3716CV200_release2integration.tar.gz *
	rm -rf ../cm-10.1-coship_Hi3716CV200_release2integration_*
	mv cm-10.1-coship_Hi3716CV200_release2integration.tar.gz ../
	
	#����system.img�ļ�
	tools/bin/make_ext4fs -s -l 500M -a system system.img target_files/SYSTEM
	mv system.img ../platform
}

#���������ļ�
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