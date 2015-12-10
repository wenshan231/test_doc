#!/bin/bash

#####prj=com.coship.adjustthevolume
#####workspace=/home/hudson/11/$prj
#####buildspaceprop=AndroidManifest.xml

workspace=$1  
prj=$2
####buildspaceprop=$2
cp $workspace/AndroidManifest.xml  $workspace/AndroidManifest.txt

cd $workspace/output
ls -ct >tt.txt

i=1
for lines in `cat tt.txt`
do  
 var[$i]=$lines
 i=$[ $i + 1 ]  
done
######echo $i
######echo ${var[1]} 
######echo ${var[2]}
rm -rf tt.txt
eval $(awk -F"=" '/android:versionName/ {

print $2>2.txt 
}' $workspace/AndroidManifest.txt)

eval $(awk -F"\"" '{
print $1$2>1.txt 

}' $workspace/output/2)

version=`cat 1`
echo $version

for((k=1;k<$i;k++));
do 
oldversion=${var[$k]}

######## totalstr length 

totalstrlength=`expr ${#oldversion}` 
echo $totalstrlength

if [ ${oldversion:0:7} = "package" ]
then
######## str length 
	str=package_$prj\_
	echo $str
	expr ${#str} 
	
	strlength=`expr ${#str}`  
	echo $strlength
	length=`expr $totalstrlength - $strlength`
	echo $length

	oldversionend=${oldversion:$strlength:$length}
	echo $oldversionend
	cd  $workspace/output
	newversion=package\_$prj\_V$version\_$oldversionend
	echo $newversion
	mv $oldversion    $newversion
else
	str=$prj\_
	expr ${#str}
	strlength=`expr ${#str}`  
	echo $strlength
	length=`expr $totalstrlength - $strlength`
	oldversionend=${oldversion:$strlength:$length}
	cd  $workspace/output
	newversion=$prj\_V$version\_$oldversionend
	echo $newversion
	mv $oldversion    $newversion
fi
########echo  $newversion
rm -rf  1
rm -rf  2
done

