#! /bin/bash
prj=$1
allpath=/home/hudson/project/$prj
workspace=$allpath/dtvmx
cd $workspace
chmod -R a+x *
. auto_Ant_Compile_dtvmx_cfg.sh 
. auto_Ant_Compile_dtvmx.sh
svn_version=`head -11 $workspace/.svn/entries | tail -1`
nowtime=`date +%Y%m%d%H%M`	
pubdir=/home/hudson/publisher/$prj/$nowtime\_dtvmx$svn_version
mkdir -p $pubdir
if [ -f $workspace/bin/dtvmxlib.jar ]
then
	echo "compile dtvmx success"
	cp $workspace/bin/dtvmxlib.jar $pubdir/ && exit 0
	
else 
	echo "compile dtvmx failed"
	exit 1
fi
