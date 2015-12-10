#!/bin/bash
workspace=$1
dist_dir=$2
package_path1=$3
package_path2=$package_path1/platform/

cd $workspace && mkdir package

if [ "package_path1" == "" ]
then
	echo "rom package is null,not to copy"
else
	cd $package_path1
	pakage_version=`ls *_release2integration.tar.gz`
	echo $pakage_version
	if [ "$pakage_version" == "" ]
	then
		echo "not rom new package \n " >> $workspace/package/log_version_rom.txt
	else 
		echo "copy rom,rom version: $pakage_version \n" >> $workspace/package/log_version_rom.txt

		cd $package_path2
		cp -rf ./emmc $workspace/package/emmc
		cd $workspace/package/
		zip -r emmc.zip ./emmc

		cd $dist_dir
		rm -f cm-10.1-coship_Hi3716CV200_release2integration.tar.gz
		rm -f emmc.zip

		echo "copy rom,rom version: package_path1 \n" >> $workspace/package/log_version_rom.txt
		cp -f $package_path1/$pakage_version    $dist_dir && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt
		cp -f $package_path1/$pakage_version    $workspace/package/ && echo "copy $pakage_version ok"  >> $workspace/package/log_version_rom.txt  || echo "copy $pakage_version error"  >> $workspace/package/log_version_rom.txt

		cp -f $package_path1/*.txt $workspace/package/ && echo "copy txt file ok"  >> $workspace/package/log_version_rom.txt  || echo "txt file error"  >> $workspace/package/log_version_rom.txt
		cp -f $package_path1/*_manifest.xml $workspace/package/ && echo "copy manifest.xml file ok"  >> $workspace/package/log_version_rom.txt  || echo "copy manifest.xml file error"  >> $workspace/package/log_version_rom.txt


		cp -f $workspace/package/emmc.zip    $dist_dir && echo "copy emmc.zip ok"  >> $workspace/package/log_version_rom.txt || echo "copy emmc.zip error"  >> $workspace/package/log_version_rom.txt
		#cp -f $package_path2/emmc.zip   $workspace/package/ && echo "copy emmc.zip ok"  >> $workspace/package/log_version_rom.txt  || echo "copy emmc.zip error"  >> $workspace/package/log_version_rom.txt
		cd $workspace/package
		rm -rf emmc

               rm *_release2integration.tar.gz

	fi
fi
