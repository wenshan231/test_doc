#!/bin/bash
path_system=$1
path_porting=$2
path_510apk=$3
path_dtvmxjar=$4
MMCP510DIR_client=$5
MMCP510DIR_server=$6
path_csmsi=$7
workspace=$8

######################### copy system ##########################################
cd $path_system
pakage_version=`ls *_Hi3716CV200_release2integration*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "system package not exist" >> $workspace/log_version_rom.txt
else 
	echo "copy system package: $pakage_version" >> $workspace/log_version_rom.txt
	
	#delete old first
  #rm $workspace/platform/ROM/*_Hi3716CV200_release2integration*.tar.gz
  #rm $workspace/platform/ROM/emmc.zip
  
  #then copy
	cp -f $pakage_version $workspace/platform/ROM && echo "copy $pakage_version ok"  >> $workspace/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/log_version_rom.txt
	cp -rf platform $workspace/platform/ROM && echo "copy emmc ok"  >> $workspace/log_version_rom.txt || echo "copy emmc error"  >> $workspace/log_version_rom.txt
	cd $workspace/platform/ROM
	zip -r emmc.zip ./platform
        rm -rf platform
fi
######################### copy porting ##########################################
cd $path_porting
cp -f $path_porting/* $workspace/platform/ROM/porting && echo "copy porting ok"  >> $workspace/log_version_rom.txt || echo "copy porting error"  >> $workspace/log_version_rom.txt

######################### copy 510apk ##########################################
cd $path_510apk
pakage_version=`ls com.coship.mmcp510.merge*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "510apk package not exist " >> $workspace/log_version_rom.txt
else
	echo "copy 510apk: $pakage_version" >> $workspace/log_version_rom.txt
	cp -f $pakage_version $workspace/platform/ROM/mmcp && echo "copy $pakage_version ok"  >> $workspace/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/log_version_rom.txt

fi
######################### copy dtvmxjar ##########################################
cd $path_dtvmxjar
pakage_version=`ls dtvmxlib.jar`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "dtvmxjar not exist " >> $workspace/log_version_rom.txt
else
	echo "copy dtvmxjar: $pakage_version" >> $workspace/log_version_rom.txt
	cp -f ./* $workspace/platform/ROM/mmcp && echo "copy $pakage_version ok"  >> $workspace/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/log_version_rom.txt

fi

######################### copy MMCP510DIR_client ##########################################
cd $MMCP510DIR_client
cp -f ./* $workspace/platform/ROM/mmcp && echo "copy MMCP510DIR_client ok"  >> $workspace/log_version_rom.txt || echo "copy MMCP510DIR_client error"  >> $workspace/log_version_rom.txt

######################### copy MMCP510DIR_server ##########################################
cd $MMCP510DIR_server
cp -f ./* $workspace/platform/ROM/mmcp && echo "copy MMCP510DIR_server ok"  >> $workspace/log_version_rom.txt || echo "copy MMCP510DIR_server error"  >> $workspace/log_version_rom.txt

######################### copy csmsi ##########################################
cd $path_csmsi
pakage_version=`ls hisi-csmsi*.tar.gz`
echo $pakage_version
if [ "$pakage_version" == "" ]
then
	echo "csmsi not exist" >> $workspace/log_version_rom.txt
else
	echo "copy csmsi: $pakage_version" >> $workspace/log_version_rom.txt
	cp -f $pakage_version $workspace/platform/ROM/csmsi && echo "copy $pakage_version ok"  >> $workspace/log_version_rom.txt || echo "copy $pakage_version error"  >> $workspace/log_version_rom.txt

fi
