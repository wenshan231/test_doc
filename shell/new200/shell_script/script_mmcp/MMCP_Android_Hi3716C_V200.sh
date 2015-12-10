#!/bin/bash     
workspacse=/home/hudson/MMCP_Android_Hi3716C_V200        
binder_src=/home/hudson/mmcp510.merge.bindermanager/bindermanager/output      
binder_des1=$workspacse/linkLibrary/binder/Android_Hi3716C_V200
cp $binder_src/libBinderManager_TF_intermediates/libBinderManager_TF.a $binder_des1/ -f
cp $binder_src/libBinderManager_TF_client_intermediates/libBinderManager_TF_client.a $binder_des1/ -f
cp $binder_src/libBinderManager_IRDETO3_intermediates/libBinderManager_IRDETO3.a $binder_des1/ -f
cp $binder_src/libBinderManager_IRDETO3_client_intermediates/libBinderManager_IRDETO3_client.a $binder_des1/ -f
cp $binder_src/libBinderManager_Suma_intermediates/libBinderManager_Suma.a $binder_des1/ -f
cp $binder_src/libBinderManager_Suma_client_intermediates/libBinderManager_Suma_client.a $binder_des1/ -f
cp $binder_src/libBinderManager_UDRM_intermediates/libBinderManager_UDRM.a $binder_des1/ -f
cp $binder_src/libBinderManager_UDRM_client_intermediates/libBinderManager_UDRM_client.a $binder_des1/ -f
###
. bin/setupenv --ia bin/envfile_fortrunk/setenv_Android_Hi3716C_V200_debug
make mmcp_dll
###
make -C cfg/taiwan_hi3716C_V200
make -C cfg/ottdvb_hi3716C_V200
##
cd $workspacse/integration/product/taiwan_android_merge
. setupenv --ia setenv_Android_Hi3716C_V200_debug coship
make
cd $workspacse/integration/product/OTT_DVB
. setupenv --ia setenv_Android_Hi3716C_V200_debug coship
make
##
mkdir -p $workspacse/out/Android_Hi3716C_V200/debug/small_lib
cp $workspacse/lib/Android_Hi3716C_V200/debug/*.a  $workspacse/out/Android_Hi3716C_V200/debug/small_lib
