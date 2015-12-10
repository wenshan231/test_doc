#!/bin/bash
workspace=$1
mmcp_path=$2
dist_dir=$3

cd $workspace
if [ "mmcp_path" == "" ]
then
	echo "mmcp path in is no exist,not to copy"
else
	cd $mmcp_path
	pakage_version=`ls main.out`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "not mmcp new package \n " >> $workspace/package/log_version_rom.txt
	else 
		echo "copy mmcp version: $pakage_version \n" >> $workspace/package/log_version_rom.txt	
		cd $dist_dir
		rm main.out

		cp -f $mmcp_path/$pakage_version $dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt
		
		cp -rf $dist_dir/main.out $workspace/package
		cp -rf $mmcp_path/out_version.txt $workspace/package
	fi

fi
