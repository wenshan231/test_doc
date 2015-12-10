#!/bin/bash
workspace=$1
rom_path=$2
dist_dir=$3

cd $workspace && mkdir package
if [ "rom_path" == "" ]
then
	echo "rom path in is no exist,not to copy"
else
	cd $rom_path
	pakage_version=`ls hisi3716CV200_android_git*.tar.gz`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "not rom new package \n " >> $workspace/package/log_version_rom.txt
	else 
		echo "copy rom version: $pakage_version \n" >> $workspace/package/log_version_rom.txt	
		cd $dist_dir
		rm hisi3716CV200_android_git*.tar.gz


		cp -f $rom_path/$pakage_version $dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt
		
		cp -rf $dist_dir/hisi3716CV200_android_git*.tar.gz $workspace/package
		cp -rf $rom_path*_manifest.xml $workspace/package
	fi

fi
