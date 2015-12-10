#!/bin/bash
#########write by qiaoting 4/15/2013
prj=$1
workspace=$2
#chmod -R 775 $workspace
cd $workspace
rm -f stp_package_mstar6a801_*.tar.gz
pwd
chmod -R 777 script
source ./script/build_mstaramber3box.sh
cd $workspace
source ./script/package_mstaramber3box.sh ./ ./
cd $workspace
if [ -f stp_package_mstar6a801_*.tar.gz ]
then
	echo "compile ok"
	rm -fr output
	mkdir output
	cp stp_package_mstar6a801_*.tar.gz output/
	exit 0
else
	echo "compile error please check log" 
	exit 1
fi






