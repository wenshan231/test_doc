#!/bin/bash
workspace=$1
porting_path=$2
dist_dir = $3

cd $workspace && mkdir package
if [ "porting_path" == "" ]
then
	echo "porting path in is no exist,not to copy"
else
	cd $porting_path
	pakage_version=`ls main.out`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "not porting new package \n " >> $workspace/package/log_version_rom.txt
	else 
		echo "copy main.out version: $pakage_version \n" >> $workspace/package/log_version_rom.txt	
		cd $dist_dir
		rm main.out

		cp -f $porting_path/$pakage_version $dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt
		
		#cp -rf $porting_path/platform $workspace/package
	fi

fi
