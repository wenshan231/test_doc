#!/usr/bin/bash
prjpath=/luntbuild/work/stb
cd $prjpath
parm=`cat colable`
export $parm
echo $pro
cd $pro
export logfile=$prjpath/$pro/logfile.txt
cd $prjpath/$pro/src
mv  AutoMake Automake.bat
mv  Automake Automake.bat
sh Automake.bat >> $logfile 2>&1
cd $prjpath/$pro
chmod -R 777 * 

