#! /bin/bash
prj=$1
workspace=$2

cd $workspace
chmod -R a+x *
. auto_Ant_Compile_dtvmx_cfg.sh 
. auto_Ant_Compile_dtvmx.sh
svn_version=`head -11 $workspace/.svn/entries | tail -1`
log_file=$workspace/bin/svnversion\_$svn_version.log
svn info > $workspace/bin/dtvmxjar.txt
echo -e "====================== dtvmxlib.jar svn version :$svn_version =====================" >> $log_file
#nowtime=`date +%Y%m%d%H%M`	
#pubdir=/home/hudson/publisher/$prj/$nowtime\_dtvmx$svn_version
#mkdir -p $pubdir
if [ -f $workspace/bin/dtvmxlib.jar ]
then
	echo "compile dtvmx success"
	#cp $workspace/bin/dtvmxlib.jar $pubdir/ 
        #cp -r $pubdir $workspace/bin/
        #cd $workspace/bin
        #tar zcvf dtvmx\_svn$svn_version.tar.gz $nowtime\_dtvmx$svn_version
        exit 0
	
else 
	echo "compile dtvmx failed"
	exit 1
fi
