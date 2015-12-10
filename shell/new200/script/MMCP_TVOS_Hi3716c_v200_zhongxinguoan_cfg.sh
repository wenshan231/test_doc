#! /bin/sh
:<<!

=======================================注释行，编译方法开发人员：shenglele 配置管理人员：wanghuimin=======================================
编译步奏：
1.下载代码
2.进入根目录MMCP/执行. bin/setupenv --im选择平台52)Android_Hi3716C_V200
   Please select the link mode of dtvmx.jar:
   0)Linked to javavm(Be static linked to libjavavm.a,for release to all hmc project)
   1)No linkage to javavm(Not be linked to libjavavm.a,for easy to debug in local develepment)
    Enter your anwser (default: Linked to javavm) => 选0
    would u like to select memleak  for this compile?
    1) yes 2) no 
     Enter your anwser (default: no) => 选1
     Please select debug mode:
     1)release[release without log] 2)print[O2,release with log] 3)debug[O0, -g with log]
     选2
     Would u like to select filesystem in details? 
     1)no 2)yes
     Enter your anwser (default: no) => 选1
     would u like to select a config file for this compile?
     1) yes 2) no
     Enter your anwser (default: no) => 选1然后选
     34) Android_Hi3716C_V200_tvos.config(这里需要注意序号会变)
3.进入cfg/zhongxinguoan_hi3716c_v200目录
   执行 make clean;make
4.切换到MMCP目录下执行. bin/setupenv --im选择平台53）Android_Hi3716C_V200_Client 
   Please select the link mode of dtvmx.jar:
   0)Linked to javavm(Be static linked to libjavavm.a,for release to all hmc project)
   1)No linkage to javavm(Not be linked to libjavavm.a,for easy to debug in local develepment)
    Enter your anwser (default: Linked to javavm) => 选0
   would u like to select memleak  for this compile?
    1) yes 2) no 
     Enter your anwser (default: no) => 选1
     1)release[release without log] 2)print[O2,release with log] 3)debug[O0, -g with log]
     选2
    Would u like to select filesystem in details? 
     1)no 2)yes
     Enter your anwser (default: no) => 选1
     would u like to select a config file for this compile?
     1) yes 2) no
     Enter your anwser (default: no) => 选1然后选
     35) Android_Hi3716C_V200_tvos_Client.config(这里需要注意序号会变)
5.进入cfg/zhongxinguoan_hi3716c_v200_client目录
   执行 make clean;make
6.在MMCP\lib\Android_Hi3716C_V200\debug目录下（没有则新建）添加小库，取用地址\\10.10.5.161\output_DVBOTT\MMCP_Android_Hi3716C_V200_TVOS_Client\lastSuccessful\archive\out_hubei\Android_Hi3716C_V200\debug\small_lib
  和\\10.10.5.161\output_DVBOTT\MMCP_Android_Hi3716C_V200_TVOS\lastSuccessful\archive\out_hubei\Android_Hi3716C_V200\debug\small_lib
  然后替换binder库 编大库
  更新\MMCP\linkLibrary\binder\Android_Hi3716C_V200目录下的
  libBinderManager_CAM.a
  libBinderManager_CAM_client.a
  取用地址：http://10.10.96.200:8080/hudson-2.2.0/view/hisi3716c_v200/job/bindermanager_git_develop_tvos/
7.编大库：到MMCP目录下执行make clean;make

8.设置工程环境：
  客户端：
  MMCP/integration/product/hubei_tvos_hisi3716c_v200$ . setupenv
  Please Select Manufacturer:
  \33[1m
  1> coship 2>...
  \33[0m
  1
  Please Select:
  \33[1m
  1> 6A801_server  2> 6A801_client 3> hisiV200_tvos_server 4> hisiV200_tvos_client
  \33[0m
  4
  然后执行：
  make clean;make

  服务端：
  MMCP/integration/product/hubei_tvos_hisi3716c_v200$ . setupenv
  Please Select Manufacturer:
  \33[1m
  1> coship 2>...
  \33[0m
  1
  Please Select:
  \33[1m
  1> 6A801_server  2> 6A801_client 3> hisiV200_tvos_server 4> hisiV200_tvos_client
  \33[0m
  4
  然后执行：
  make clean;make
9.打包发布文件，MMCP/out_hubei/Android_Hi3716C_V200/debug目录下的
  libmmcp_custom_product.so 和libmmcp_custom_product_client.so
========================================注释结束====================================================
!









echo =========================================================1=====================================================
WORKSPACE=$1
small_lib_Client=$2
small_lib_server=$3
binder=$4

cd $WORKSPACE
. ./bin/setupenv --ia ./bin/envfile_fortrunk/setenv_Android_Hi3716C_V200_zhongxinguoan_cfg_print
cd $WORKSPACE/cfg/zhongxinguoan_hi3716c_v200
make clean
make

echo =========================================================2=====================================================
cd $WORKSPACE
. $WORKSPACE/bin/setupenv --ia $WORKSPACE/bin/envfile_fortrunk/setenv_Android_Hi3716C_V200_zhongxinguoan_cfg_Client_print

cd $WORKSPACE/cfg/zhongxinguoan_hi3716c_v200_client
make clean&&make


echo ================================3 在MMCP\lib\Android_Hi3716C_V200\debug目录下（没有则新建）添加小库====================



cp $small_lib_Client/*  $WORKSPACE/lib/Android_Hi3716C_V200/debug/

cp $small_lib_server/*  $WORKSPACE/lib/Android_Hi3716C_V200/debug/

echo ============================4  更新linkLibrary\binder\Android_Hi3716C_V200目录下的 libBinderManager_CAM.a  libBinderManager_CAM_client.a====================

cd $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200/
rm -rf libBinderManager_CAM.a  libBinderManager_CAM_client.a &&mkdir tmp

cp $binder/*.tar.gz  $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200/tmp
cd $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200/tmp
tar -xvzf *.tar.gz 
cp $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200/tmp/libBinderManager_CAM_intermediates/libBinderManager_CAM.a $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200

cp $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200/tmp/libBinderManager_CAM_client_intermediates/libBinderManager_CAM_client.a $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200
cd $WORKSPACE/linkLibrary/binder/Android_Hi3716C_V200 && rm -rf tmp && chmod 755 libBinderManager_CAM.a  libBinderManager_CAM_client.a

echo ====================================================5 编大库：到MMCP目录下执行make clean;make====================
cp $WORKSPACE/cfg/zhongxinguoan_hi3716c_v200_client/objs/Android_Hi3716C_V200_Client/debug/libcfg_zhongxinguoan_hi3716c_v200_client.a  $WORKSPACE/lib/Android_Hi3716C_V200/debug/


cp $WORKSPACE/cfg/zhongxinguoan_hi3716c_v200/objs/Android_Hi3716C_V200/debug/libcfg_zhongxinguoan_hi3716c_v200.a   $WORKSPACE/lib/Android_Hi3716C_V200/debug/

cd $WORKSPACE
make clean&&make


echo ====================================================6 设置工程环境：客户端make clean;make====================
cd  $WORKSPACE/integration/product/hubei_tvos_hisi3716c_v200
. setupenv --ia setenv_Android_Hi3716C_V200_tvos_Client_debug coship

make clean&&make
echo ====================================================7 设置工程环境：服务器段端make clean;make====================
cd  $WORKSPACE/integration/product/hubei_tvos_hisi3716c_v200
. setupenv --ia setenv_Android_Hi3716C_V200_tvos_debug coship


make clean&&make
