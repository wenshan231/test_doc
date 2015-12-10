#!/bin/bash
#########write by qiaoting 10/25/2013
prj=$1
workspace=$2
#chmod -R 775 $workspace
cd $workspace
#rm -f stp_package_mstar6a801_*.tar.gz
rm -fr release2integration
pwd

source ./script/build_mstaramber3box.sh
cd $workspace
source ./script/package_mstaramber3box.sh ./ ./
cd $workspace
if [ -f release2integration/mstaramber3box.release2integration*.tar.gz ]
then
	echo "compile ok"
	rm -fr output
	mkdir output
	cp -fr release2integration/mstaramber3box.release2integration*.tar.gz  output/
	exit 0
else
	echo "compile error please check log" 
	exit 1
fi


