#!/bin/bash
workspace=$1
porting_path=$2

cd $workspace && mkdir package
if [ "porting_path" == "" ]
then
	echo "porting path in is no exist,not to copy"
else
	cd $porting_path
	pakage_version=`ls *_release2integration*.tar.gz`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "not porting new package \n " >> $workspace/package/log_version_rom.txt
	else 
		echo "copy porting version: $pakage_version \n" >> $workspace/package/log_version_rom.txt
		dist_dir=$workspace/platform/ROM	
		cd $dist_dir
		rm *_release2integration*.tar.gz
		rm emmc.zip
		cp -f $porting_path/$pakage_version $dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt
		
		cp -rf $porting_path/platform $workspace/package
		cd $workspace/package
		mv platform emmc
		zip -r emmc.zip ./emmc
		rm -rf emmc
		mv emmc.zip $dist_dir && echo "copy emmc.zip ok"  >> $workspace/package/log_version_rom.txt || echo "copy emmc.zip error"  >> $workspace/package/log_version_rom.txt

		cp -f $porting_path/porting/*_svn_/porting/libporting.so $dist_dir && echo "copy libporting.so ok"  >> $workspace/package/log_version_rom.txt || echo "copy libporting.so error"  >> $workspace/package/log_version_rom.txt
	fi

fi
