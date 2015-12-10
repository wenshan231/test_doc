
#! /bin/bash
# This script is auto make mmcp  incream
# @author: QiaoTing (on 2010/02/10)
# modify @author: xieyue (on 2010/06/01) 

prj=$1
dir=$2
plat_list=$3
productname=$4

shellbash=$(pwd)/makecbb.sh
shellbash_guizhou=$(pwd)/publish_guizhou_hi3716m.sh
shellbash_jilin=$(pwd)/publish_jilin.sh
shellbash_jiangsu=$(pwd)/publish_jiangsu.sh

allpath=/hudson16/$prj
workpath=$allpath/$dir
log_file_detail=$allpath/logs/make_$prj\_detail.log
log_file=$allpath/logs/make_$prj.log
log_failedinfo=$allpath/logs/infotxt.log


mdli=0
flag=0
flagall=1
flagmmcpnomake=1
flag3rdnomake=0
mdli=0
flagdebug=0
libtype=ew510
copyall=1
#cppcheckflag=0

lastmmcpverlog=/cc/conf/lastver\_$prj\_mmcp.log

cd $allpath/logs
if [ $? -eq 0 ]
then
        rm -f *
fi
cd   $allpath/output/ && \
if [ $? -eq 0 ]
then
rm -fr *
fi

nowmmcpver=`head -11 $workpath/.svn/entries | tail -1`
### taiwan make every time
if [ "$prj" =  "mmcp_delivery_hi3716m_taiwan" ]
then
	lastmmcpver=0
else
	lastmmcpver=`cat /cc/conf/lastver\_$prj\_mmcp.log`
fi
echo -e "====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================" >> $log_file
echo ====================== mmcp:lastversion:$lastmmcpver, nowversion:$nowmmcpver =====================

last3rdver=0
now3rdver=0

### if there is 3rd we need to get the 3rd ver
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	last3rdver=0
	now3rdver=`head -11 $workpath/integration/product/$productname/.svn/entries | tail -1`
	echo -e "===================== project version:$now3rdver ==================" >> $log_file
	echo ====================== project version:$now3rdver =====================
	if [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ] || [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ] || [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ]
	then
		cd $workpath/integration/product/guizhou_jiulian_hi3716M
		if [ -d release/4.tools/2.burn/fastboot ]
		then
			rm release/4.tools/2.burn/fastboot -rf
		fi
	fi
fi


okmsg="[CC]Result of $prj make success revision $nowmmcpver"
errormsg="[CC]Result of $prj make failed revision $nowmmcpver"

echo -e "<infoxml>" > $log_failedinfo



if [ "$lastmmcpver" -eq 0 ]
then 
	flagall=0
else
	cd $workpath
	if [ "$productname" == "" ]
	then
		echo ================ there is no project need to make ================ >> $log_file
		if [ "$prj" = "mmcp_delivery_st71xxlinux" ]
		then
			echo ================ current project is mmcp_delivery_st71xxlinux ================ >> $log_file
			model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/cfg//g' | sed 's/porting//g'`
	        elif [ "$prj" = "mmcp_yangzhou_hi3716m" ]
                then
			model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tongfang3/g' | sed 's/cfg//g' | sed 's/pvr//g' | sed 's/porting//g'`	
               else
			model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/pvr//g' | sed 's/porting//g'`
		fi

	### third product 
	elif [ "$prj" = "mmcp_jiangsu_hi3716m" ]
        then
                echo ================ current project is jiangsu ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/msc/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'`

        elif [ "$prj" = "mmcp_yixing_hi3716m" ]
        then
                echo ================ current project is yixing ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/msc thirdparty\/amep/g' | sed 's/cfg/cfg\/yixing_coship_hi3716M/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'`

        elif [ "$prj" = "mmcp_jiangsu_android_6A801" ]
        then
                echo ================ current project is jiangsu_android_6A801 ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/msc/g' | sed 's/cfg/cfg\/jiangsu_coship_Android6A801/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'`

        elif [ "$prj" = "mmcp_jiangsu_android_6A801_client" ]
        then
                echo ================ current project is jiangsu_android_6A801_client ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/jvm//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/msc/g' | sed 's/cfg/cfg\/jiangsu_coship_Android6A801_Client/g' | sed 's/pvr//g' | sed 's/porting//g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'`

        elif [ "$prj" = "mmcp_jiangsu_android_6A801_3rd" ]
        then
                echo ================ current project is jiangsu_android_6A801_3rd ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis_tv thirdparty\/unionPay thirdparty\/ca\/tfcdcasa/g' | sed 's/cfg/cfg\/jiangsu_skyworth_Android6A801/g' | sed 's/pvr//g' | sed 's/porting/porting\/share\/udi2\/lcsp_udi1 porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udiplus porting\/share\/udi2_osg_mstar6a801/g' | sed 's/protocol/protocol protocol\/DLNA protocol\/xmpp/g'`

        elif [ "$prj" = "mmcp_jiangsu_hi3716m_cloudmedia" ]
        then
                echo ================ current project is mmcp_jiangsu_hi3716m_cloudmedia ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/cfg/cfg\/jiangsu_coship_hi3716M/g' | sed 's/pvr//g' | sed 's/porting//g'`

        elif [ "$prj" = "mmcp_yangzhou_hi3716m" ]
        then
                echo ================ current project is mmcp_yangzhou_hi3716m ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/thirdparty/thirdparty\/tts thirdparty\/unionPay thirdparty\/ca\/tfcdcasa_security/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus porting\/share\/udi2\/ipstack/g'`

	elif [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ]|| [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ]
	then
		echo ================ current project is guizhou_hisi3716m ================ >> $log_file
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib//g' | sed 's/cfg/cfg\/guizhou_3rd_hd cfg\/zunyi_3rd_hd/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdcasa/g' | sed 's/porting/porting\/share\/udi2\/lcsp_udi1 porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udiplus/g'`

        elif [ "$prj" = "mmcp_guizhou_android_hi3716c" ]
        then
                echo ================ current project is guizhou_android_hi3716c ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib/kernel/g' | sed 's/cfg//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/porting//g'`

        elif [ "$prj" = "mmcp_tianjin_tcb_bcm7405" ] || [ "$prj" = "mmcp_tianjin_yinhe_st7105" ] || [ "$prj" = "mmcp_tianjin_changhong_hi3716h" ]
        then
		echo ================ current project is tianjin hd ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus porting\/share\/udi2\/ipstack/g'`
		echo $model_list_all | grep "cfg"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg"
                fi
	
        elif [ "$prj" = "mmcp_tianjin_tcb_hi3716h" ] || [ "$prj" = "mmcp_tianjin_coship_hi3716m" ] || [ "$prj" = "mmcp_tianjin_hi3716m_v300" ]
        then
                echo ================ current project is tianjin hd ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/shumashixun-tianjin/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus porting\/share\/udi2\/ipstack/g'`
		echo $model_list_all | grep "cfg"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg"
                fi

        elif [ "$prj" = "mmcp_wuhan_hi3716m" ] 
        then
                echo ================ current project is wuhan hi3716m ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/shumashixun-tianjin/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus porting\/share\/udi2\/ipstack/g'`
                echo $model_list_all | grep "cfg"
                if [ $? -eq 0 ]
                then
                        echo cfg exits~~~~~~~~
                else
                        model_list_all="$model_list_all cfg"
                fi
	elif [ "$prj" = "mmcp_tianjin_daxiang_st5197" ]
        then
                echo ================ current project is tianjin_st5197 ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/cfg//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/shumashixun-tianjin/g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udi2\/lcsp_udi1 porting\/share\/udiplus porting\/share\/udi2\/ipstack/g'`

        elif [ "$prj" = "mmcp_jilin_hi3716m" ]
        then
                echo ================ current project is jilin ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udiplus porting\/share\/udi2\/ipstack porting\/share\/udi2\/lcsp_udi1/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/dvn thirdparty\/ca\/irdeto3 thirdparty\/bankcar/g'`

		echo $model_list_all | grep "cfg"
		if [ $? -eq 0 ]
		then
			echo cfg exits~~~~~~~~
		else
			model_list_all="$model_list_all cfg"
		fi

        elif [ "$prj" = "mmcp_jilin_android_hi3716c" ]
        then
                echo ================ current project is jilin:$prj ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/cfg//g' | sed 's/porting/porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udiplus porting\/share\/udi2\/lcsp_udi1/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/dvn thirdparty\/ca\/irdeto3/g'`

        elif [ "$prj" = "mmcp_zhuhai_hi3110e" ]
        then
                echo ================ current project is zhuhai_hi3110e ================ >> $log_file
                libtype=ew210
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/jvm//g' | sed 's/dtvmx//g' | sed 's/cfg/cfg\/guangdong_hi3110E/g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdca/g' | sed 's/porting/porting\/share\/udi2\/lcsp_udi1 porting\/share\/udi2\/hdicommon\/udi2_caadapter porting\/share\/udiplus/g'`

        elif [ "$prj" = "mmcp_jiangxi_3rd_hi3716m" ]
        then
                echo ================ current project is jiangxi_3rd_hi3716M_hisiv200 ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay/g' | sed 's/cfg//g' | sed 's/pvr//g' | sed 's/porting//g'`


        elif [ "$prj" = "mmcp_topway_hi3716h" ]
        then
                echo ================ current project is jiangxi_3rd_hi3716M_hisiv200 ================ >> $log_file
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/otherprocess\/webserver/g' | sed 's/cfg/cfg\/topway_N9101_udrm/g' | sed 's/pvr//g' | sed 's/porting//g'`

        elif [ "$prj" = "mmcp_guangdong_android_6A801" ] || [ "$prj" = "mmcp_guangdong_android_6A801_client" ] || [ "$prj" = "mmcp_guangdong_android_hi3716c" ] || [ "$prj" = "mmcp_guangdong_android_hi3716c_client" ]
        then
                model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/integration//g' | sed 's/tplib//g' | sed 's/jvm//g' | sed 's/thirdparty/thirdparty\/ca\/tfcdcasa/g'`

	elif [ "$prj" = "mmcp_guangdong_hi3110e" ]
	then
		model_list_all=`svn diff  --summarize --username xieyue --password 04303309 -r $lastmmcpver:$nowmmcpver | awk {'print $2'} |  sed 's%/.*$%%' | uniq | grep -v "autoMake" | sed 's/porting/porting\/share\/udi2\/ipstack porting\/share\/udi2\/lcsp_udi1 porting\/share\/udi2\/hdicommon\/udi2_cadapter/g' | sed 's/test//g' | sed 's/pvr//g' | sed 's/cfg/cfg\/guangdong_hi3110E/g' | sed 's/integration//g' | sed 's/cute//g' | sed 's/thirdparty/thirdparty\/tts thirdparty\/mis thirdparty\/unionPay thirdparty\/ca\/tfcdca/g'`
	fi
	
	echo -e "==================== modified models compared to last version:"$model_list_all" ==================" >> $log_file
	if [ "$prj" = "mmcp_jiangsu_hi3716m" ]
	then 
		echo -------------20140424 jiangsu proect-------------------------
		model_list_all="$model_list_all cfg/jiangsu_coship_hi3716M_wifi_V300"
	fi
	if [ "$model_list_all" = "" ]
	then
		echo "only noncbb modules change and not build" >> $log_file
		flagmmcpnomake=0
	else
		
		echo $model_list_all | grep -E "include|bin|build" 
		if [ $? -eq 0 ]
		then
			flagall=0
		else
			echo $model_list_all | grep "dtvmx"
			if [ $? -eq 0 ]
			then 
				if [ "$prj" != "mmcp_guangdong_android_6A801" ] && [ "$prj" != "mmcp_guangdong_android_6A801_client" ] && [ "$prj" != "mmcp_jiangsu_android_6A801_client" ] && [ "$prj" != "mmcp_guizhou_android_6a801_client" ] && [ "$prj" != "mmcp_guangdong_android_hi3716c" ] && [ "$prj" != "mmcp_guangdong_android_hi3716c_client" ] 
				then	
					model_list=`echo  $model_list_all | sed 's/jvm//g' | sed 's/dtvmx/dtvmx jvm/g'`
				else
					model_list=$model_list_all
				fi
				echo $model_list
			else
				model_list=$model_list_all
			fi
		fi 
	fi
fi


if [ "$flagmmcpnomake" -eq 0 ]
then
	echo "no mmcp cbb need to make ~~~~~~~~~~~~~~~~~~~~~"
else
	echo "some mmcp cbb has been modified, need to make ~~~~~~~~~~~~~~~~~~~~~~~~"

	model_list_dbg="jvm"
	model_list_dbg_author="huhuatao"
	if [ $flagall -eq 0 ]
	then
		rm -fr $workpath/lib/*
                model_list_author="yanghuiyuan huhuatao fushouwei caorui longshirong zhaodemin caozhenliang fushouwei zhuokeqiao zhengfen zhangminrui lianxijian caorui caorui zhuokeqiao fanyong fanyong"

		if [ "$productname" == "" ]
		then
			if [ "$prj" = "mmcp_delivery_st71xxlinux" ]
                	then
				echo ================ current project is st71xxlinux ================ >> $log_file
                        	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm pvr thirdparty/tts thirdparty/mis thirdparty/unionPay"
			elif [ "$prj" = "mmcp_wuhan_hi3716m" ]
                        then
				model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg thirdparty/tts thirdparty/mis thirdparty/unionPay"
			elif [ "$prj" = "mmcp_delivery_hi3716m" ]
                        then
                                model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg thirdparty/tts thirdparty/mis thirdparty/unionPay"
			elif [ "$prj" = "mmcp_delivery_hi3716m_taiwan" ]
                        then
                                model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/taiwan_hi3716M thirdparty/tts thirdparty/mis thirdparty/unionPay"
			elif [ "$prj" = "mmcp_yangzhou_hi3716m" ]
                        then
                                model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/mis thirdparty/ca/tongfang3 thirdparty/unionPay"
			else
				echo ================ current project is not specified ================ >> $log_file
				model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay"		
			fi

		elif [ "$prj" = "mmcp_jiangsu_hi3716m" ] || [ "$prj" = "mmcp_android_hi3716c" ]
                then
			echo ================ current project is jiangsu_hi3716m ================ >> $log_file
			model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool jvm cfg/jiangsu_coship_hi3716M cfg/jiangsu_coship_hi3716M_wifi cfg thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc"

                elif [ "$prj" = "mmcp_yixing_hi3716m" ]
                then
                        echo ================ current project is yixing_hi3716m ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool jvm cfg/yixing_coship_hi3716M thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc thirdparty/amep"

                elif [ "$prj" = "mmcp_jiangsu_android_6A801" ]
                then
                        echo ================ current project is jiangsu_android_6A801 ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool jvm cfg/jiangsu_coship_Android6A801 thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc"

                elif [ "$prj" = "mmcp_jiangsu_android_6A801_client" ]
                then
                        echo ================ current project is jiangsu_android_6A801_client ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool cfg/jiangsu_coship_Android6A801_Client thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/msc"

                elif [ "$prj" = "mmcp_jiangsu_android_6A801_3rd" ]
                then
                        echo ================ current project is jiangsu_android_6A801_3rd ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jvm jsext kernel mediaplayer midp protocol protocol/DLNA protocol/xmpp guitool cfg/jiangsu_skyworth_Android6A801 thirdparty/tts thirdparty/mis_tv thirdparty/unionPay thirdparty/ca/tfcdcasa porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udiplus porting/share/udi2_osg_mstar6a801"
	
                elif [ "$prj" = "mmcp_jiangsu_hi3716m_cloudmedia" ]
                then
			echo ================ current project is mmcp_jiangsu_hi3716m_cloudmedia ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay cfg/jiangsu_coship_hi3716M"

                elif [ "$prj" = "mmcp_yangzhou_hi3716m" ]
                then
                        echo ================ current project is mmcp_yangzhou_hi3716m ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/unionPay thirdparty/ca/tfcdcasa_security porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udiplus porting/share/udi2/ipstack"

                elif [ "$prj" = "mmcp_tianjin_tcb_bcm7405" ] || [ "$prj" = "mmcp_tianjin_yinhe_st7105" ] || [ "$prj" = "mmcp_tianjin_changhong_hi3716h" ]
                then
			echo ================ current project is tianjin hd ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg thirdparty/tts thirdparty/mis thirdparty/unionPay porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/ipstack porting/share/udi2/lcsp_udi1"
			echo $model_list_all | grep "cfg"
                	if [ $? -eq 0 ]
                	then
                        	echo cfg exits~~~~~~~~
                	else
                        	model_list_all="$model_list_all cfg"
                	fi

                elif [ "$prj" = "mmcp_tianjin_tcb_hi3716h" ] || [ "$prj" = "mmcp_tianjin_coship_hi3716m" ] || [ "$prj" = "mmcp_tianjin_hi3716m_v300" ]
                then
                        echo ================ current project is tianjin hd ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/shumashixun-tianjin porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/ipstack porting/share/udi2/lcsp_udi1"
			echo $model_list_all | grep "cfg"
                	if [ $? -eq 0 ]
                	then
                        	echo cfg exits~~~~~~~~
                	else
                        	model_list_all="$model_list_all cfg"
                	fi
		elif [ "$prj" = "mmcp_wuhan_hi3716m" ]
                        then
                                model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg thirdparty/tts thirdparty/mis thirdparty/unionPay"
                elif [ "$prj" = "mmcp_tianjin_daxiang_st5197" ]
                then
			echo ================ current project is tianjin_st5197 ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/shumashixun-tianjin porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/ipstack porting/share/udi2/lcsp_udi1"

		elif [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ]
                then
			echo ================ current project is guizhou_hisi3716m ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdcasa cfg/guizhou_3rd_hd cfg/zunyi_3rd_hd porting/share/udiplus porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/ipstack"
		elif [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ]
                then
                        echo -e =======================guizhou hi3716m dvb test============================================
                        echo ================ current project is guizhou_hisi3716m_dvb ================
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdcasa cfg/guizhou_3rd_hd cfg/zunyi_3rd_hd porting/share/udiplus porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udi2/ipstack"

        	elif [ "$prj" == "mmcp_guizhou_android_hi3716c" ]
        	then
                	echo ================ current project is guizhou_android_hi3716c ================ >> $log_file
               		model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay"

		elif [ "$prj" = "mmcp_jilin_hi3716m" ]
                then
			echo ================ current project is jilin:$prj ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/dvn thirdparty/ca/irdeto3 thirdparty/bankcard porting/share/udi2/lcsp_udi1 porting/share/udi2/ipstack porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter cfg stock"

                elif [ "$prj" = "mmcp_jilin_android_hi3716c" ]
                then
                        echo ================ current project is jilin:$prj ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/dvn thirdparty/ca/irdeto3 porting/share/udi2/lcsp_udi1 porting/share/udiplus porting/share/udi2/hdicommon/udi2_caadapter stock"

                elif [ "$prj" = "mmcp_zhuhai_hi3110e" ]
                then
                        libtype=ew210
                        echo ================ current project is zhuhai_hi3110e ================ >> $log_file
                        model_list="shell codec dtv graph jsext kernel mediaplayer midp protocol guitool cfg/guangdong_hi3110E thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdca porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udiplus"

                elif [ "$prj" = "mmcp_jiangxi_3rd_hi3716m" ]
                then
			echo ================ current project is jiangxi_hi3716m ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay"

                elif [ "$prj" = "mmcp_topway_hi3716h" ]
                then
                        echo ================ current project is topway_hi3716h ================ >> $log_file
                        model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/otherprocess/webserver cfg/topway_N9101_udrm"

                elif [ "$prj" = "mmcp_guangdong_android_6A801" ] || [ "$prj" = "mmcp_guangdong_android_6A801_client" ] || [ "$prj" = "mmcp_guangdong_android_hi3716c" ] || [ "$prj" = "mmcp_guangdong_android_hi3716c_client" ]
                then
                        echo ================ current project is guangdong_android ================ >> $log_file
                        model_list="codec dtv dtvmx jsext kernel mediaplayer ngb protocol shell cfg thirdparty/ca/tfcdcasa"

		elif [ "$prj" = "mmcp_guangdong_hi3110e" ]
        	then
			echo ================ current project is guangdong_hi3110e ================ >> $log_file
                	model_list="dtvmx shell codec dtv graph jsext kernel mediaplayer midp protocol guitool jvm cfg/guangdong_hi3110E thirdparty/tts thirdparty/mis thirdparty/unionPay thirdparty/ca/tfcdca porting/share/udi2/ipstack porting/share/udi2/lcsp_udi1 porting/share/udi2/hdicommon/udi2_caadapter porting/share/udiplus"
		
		fi

	else
		for mdl in $model_list
		do
		  case "$mdl" in
   			dtvmx)
                                model_list_author="$model_list_author yanghuiyuan"
                        ;;
                        shell)
                                model_list_author="$model_list_author huhuatao"
                        ;;
                        codec)
                                model_list_author="$model_list_author fushouwei"
                        ;;
                        dtv)
                                model_list_author="$model_list_author caorui"
                        ;;
                        graph)
                                model_list_author="$model_list_author jiangfeng"
                        ;;
                        jsext)
                                model_list_author="$model_list_author zhaodemin"
                        ;;
                        kernel)
                                model_list_author="$model_list_author caozhenliang"
                        ;;
                        mediaplayer)
                                model_list_author="$model_list_author fushouwei"
                        ;;
                        midp)
                                model_list_author="$model_list_author zhuokeqiao"
                        ;;
                        protocol)
                                model_list_author="$model_list_author zhengfen"
                        ;;
                        guitool)
                                model_list_author="$model_list_author zhangminrui"
                        ;;
                        jvm)
                                model_list_author="$model_list_author lianxijian"
                        ;;
                        pvr)
                                model_list_author="$model_list_author huhuatao"
                        ;;
                        thirdparty/tts)
                                model_list_author="$model_list_author liuchao"
                        ;;
                        thirdparty/mis)
                                model_list_author="$model_list_author liuchao"
                        ;;
			thirdparty/unionPay)
                                model_list_author="$model_list_author zhuokeqiao"
                        ;;

			esac
		done
			
	fi
	
	echo $model_list_all | grep "dtvmx" 
	if [ $? -eq 0 ]
	then
		cd $workpath/lib
		rm -fr dtvmxjar*
		rm -fr dtvmx.javadoc
	fi

	echo -e "================ all need to make models:"$model_list" ==============" >> $log_file
	echo -e "================ all need to make models:"$model_listi_all" =============="
	for plat in $plat_list
		do
			case "$plat" in
                        hi3110E)
				if [ "$prj" = "mmcp_guangdong_hi3110e" ]
                                then
					sh $shellbash release_jieyang $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				elif [ "$prj" = "mmcp_zhuhai_hi3110e" ]
                                then
                                        sh $shellbash release_zhuhai $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
					sh $shellbash debug_zhuhai $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				elif [ "$prj" = "mmcp_fuzhou_hi3110e" ]
                                then
                                        sh $shellbash release_UDI1.0 $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir

				else
                               		sh $shellbash release_UDI2.0 $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                                	sh $shellbash debug_UDI2.0 $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
					flagdebug=1
				fi
                        ;;   

                        hi3110E_std)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        ali_m3701c)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        Android_Hi3716C)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;; 		

                        Android_Hi3716C_V200)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                                sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        Android_Hi3716C_V200_Client)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                                sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;


                        Android_6A801)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        Android_6A801_Client)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                                sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                       	 Android_6A801_thirdparty)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                                sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        hi3110E_nosfp)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;

                        st5105)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
                        ;;	

			skyworth_yinhe_st5197)
				if [ "$prj" = "mmcp_tianjin_daxiang_st5197" ]
				then
                                	sh $shellbash release_tianjin $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				else
					sh $shellbash release $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
					sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author"  $mdli $plat $prj $dir
				fi
                        ;;

			MSD7C51L)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

                        hi3716M_hisiv200)
				echo ---------this plat is:hi3716M_hisiv200,this prj is :$prj--------------------------------------
				if [ "$prj" = "mmcp_jilin_hi3716m" ] || [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ] || [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ]
				then
					echo -e "================ 3rd_hi3716m product ==============" >> $log_file
                                       echo -e "================ 3rd_hi3716m product ==============" 
                                	sh $shellbash release_3rd $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				
				elif [ "$prj" = "mmcp_jiangxi_3rd_hi3716m" ]
                                then
                                        echo -e "================ 3rd_hi3716m product ==============" >> $log_file
                                        sh $shellbash release_3rd $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					sh $shellbash debug_3rd $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir

                                elif [ "$prj" = "mmcp_jiangsu_hi3716m_cloudmedia" ]
                                then
                                        echo -e "================ mmcp_jiangsu_hi3716m_cloudmedia  ==============" >> $log_file
                                        sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir

                                elif [ "$prj" = "mmcp_tianjin_hi3716m_v300" ]
                                then
                                        echo -e "================ mmcg_tianjin_hi3716m_v300  ==============" >> $log_file
                                        sh $shellbash release_tianjin $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir

				elif [ "$prj" = "mmcp_delivery_hi3716m_udi1" ]
                                then
                                        echo -e "================ mmcg_delivery_hi3716m_udi1  ==============" >> $log_file
                                        sh $shellbash release_udi1 $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
			
				elif [ "$prj" = "mmcp_yixing_hi3716m" ]
                                then
                                        echo -e "================ mmcg_yixing_hi3716m  ==============" >> $log_file
                                        sh $shellbash release_yixing $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					sh $shellbash debug_yixing $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir

				else
			
					echo -e "================ coship product ==============" >> $log_file
					sh $shellbash release $nowmmcpver "$model_list_all" "$model_list_author" $mdli $plat $prj $dir
					sh $shellbash debug $nowmmcpver "$model_list_all" "$model_list_author" $mdli $plat $prj $dir
					flagdebug=1
				fi
                        ;;

                        hi3716H)
				if [ "$prj" = "mmcp_tianjin_tcb_hi3716h" ] || [ "$prj" = "mmcp_tianjin_changhong_hi3716h" ]
				then
				sh $shellbash release_tianjin $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir	
				elif [ "$prj" = "mmcp_topway_hi3716h" ]
				then
					echo -e "================ topway mmcp_topway_hi3716h =============="
				sh $shellbash release_topway $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				sh $shellbash topway_debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				else
                                	sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					flagdebug=1
				fi
                        ;;

                        Android_Hi3716C)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir                          
                        ;;
       
                        st71xxlinux)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

                        bcm7309)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				flagdebug=1
                        ;;

                        bcm75xx)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				flagdebug=1
                        ;;

                        bcm740x)
				if [ "$prj" = "mmcp_topway_bcm740x" ]
                                then
                                        sh $shellbash release_topway $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir 
				elif [ "$prj" = "mmcp_tianjin_bcm740x" ]
                                then
                                        sh $shellbash release_tbank $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                                else
                                	sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
					flagdebug=1
				fi
                        ;;


                        cx24501)
                                if [ "$prj" = "mmcp_topway_cx24501" ]
                                then
                                        sh $shellbash release_topway $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir                           
                                else
                                        sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                                        sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                                        flagdebug=1
                                fi
                        ;;

                        yinhe_st7105_linux)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

			tcb_bcm7405)
				sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
			;;

                        changhong_bcm7405)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

                        skyworth_yinhe_st5197)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

                        st5197)
                                sh $shellbash release $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
				sh $shellbash debug $nowmmcpver "$model_list" "$model_list_author" $mdli $plat $prj $dir
                        ;;

		esac
	done
	echo  -e "========================== make mmcp finished!! =========================="
	if [ "$libtype" = "ew510" ] 
	then
		##copy jar package from dtvmx to release dir.
                cd $workpath/dtvmx
		echo  -e "========================== ant compile =========================="
                . auto_Ant_Compile.sh > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                        cp $workpath/dtvmx/tmp/doc/dtvmx.javadoc/ $workpath/lib/dtvmx.javadoc -rf
                        echo -e "javadoc make suceess" >> $log_file
                else
                        echo -e "javadoc make failed" >> $log_file
                fi

		cp $workpath/dtvmx/lib $workpath/lib/dtvmxjar -fr
		cd $workpath/lib/dtvmxjar
		if [ $? -eq 0 ]
		then
			find -name ".svn" | xargs rm -rf
		fi
	fi

fi	
 
### if there is 3rd need to make publish
if [ "$productname" != "" ] && [ "$productname" != "none" ]
then
	if [ "$flagmmcpnomake" -eq 1 ] || [ "$last3rdver" -lt "$now3rdver" ]
	then
		flag3rdnomake=1
		if [ "$prj" = "mmcp_guizhou_3rd_hi3716m" ] || [ "$prj" = "mmcp_guizhou_3rd_hi3716m_dvb" ]
		then				
			sh $shellbash_guizhou $prj $dir
	
		elif [ "$prj" = "mmcp_jilin_hi3716m" ]
		then
			sh $shellbash_jilin $prj $dir		

		elif [ "$prj" = "mmcp_jiangsu_hi3716m" ]
                then
                        echo -------this is jiangsu project,now begin to make product---------------------
                        sh $shellbash_jiangsu $prj $dir
	
		elif [ "$plat_list" = "Android_6A801" ] || [ "$plat_list" = "Android_6A801_Client" ]
		then
			echo -e "============= now, begin to make $plat_list mmcp_publish ============" >> $log_file
			echo -e "============= now, begin to make $plat_list mmcp_publish ============"
			if [ -d $workpath/lib/mmcp_publish ]
			then
				rm $workpath/lib/mmcp_publish -rf
			fi
			
			cd $workpath/integration/product/$productname
			if [ "$plat_list" = "Android_6A801" ]
			then
				if [ "$prj" = "mmcp_guangdong_android_6A801" ]
				then
					. setupenv pf=Android_6A801 manu=coship
				else
					. setupenv --m coship
				fi
			elif [ "$plat_list" = "Android_6A801_Client" ]
			then
				if [ "$prj" = "mmcp_guangdong_android_6A801_client" ]
                                then
					. setupenv pf=Android_6A801_Client manu=coship
				else
					. setupenv_client --m coship
				fi
			fi

			make clean > /dev/null 2>&1
			make >> $log_file_detail  2>&1
			if [ $? -eq 0 ]
                        then
                                echo -e "================ make $productname mmcp_publish success =============="        
                                echo  -e "================ make $productname mmcp_publish success ==============" >> $log_file
                        else
                                echo  -e "================ make $productname mmcp_publish failed ==============" >> $log_file
                                echo -e "================ make $productname mmcp_publish failed =============="
                        fi
			make bin >> $log_file_detail  2>&1
			chmod 777 script/make_publish.sh
			make publish > /dev/null 2>&1

                        ### copy
                        echo -e "================ now, begin to copy mmcp_publish ==============" >> $log_file
                        cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/. -rf

                elif [ "$prj" = "mmcp_jiangsu_android_6A801_3rd" ]
                then
			echo -e "============= now, begin to make jiangsu_android_6A801_3rd mmcp_publish ============" >> $log_file
                        echo -e "============= now, begin to make jiangsu_android_6A801_3rd mmcp_publish ============"
			if [ -d $workpath/lib/mmcp_publish ]
                        then
                                rm $workpath/lib/mmcp_publish -rf
                        fi
                        mkdir $workpath/lib/mmcp_publish -p				

                        cd $workpath/integration/product/$productname
			echo -e "================ now, begin to setupenv for changhong ==============" >> $log_file
                       ### . setupenv --m skyworth
                       . setupenv --m changhong
                        make clean > /dev/null 2>&1
                        make >> $log_file_detail  2>&1
			if [ $? -eq 0 ]
                        then
                                echo -e "================ make $productname mmcp_publish success =============="
                                echo  -e "================ make $productname mmcp_publish success ==============" >> $log_file
                        else                            
                                echo  -e "================ make $productname mmcp_publish failed ==============" >> $log_file
                                echo -e "================ make $productname mmcp_publish failed =============="
                        fi
                        make bin >> $log_file_detail  2>&1
                        make publish > /dev/null 2>&1
			echo "MMCP SVN Version: $nowmmcpver" >> $workpath/integration/product/$productname/mmcp_publish_changhong/ReleaseNotes.txt

                        ### copy
                        echo -e "================ now, begin to copy mmcp_publish for changhong ==============" >> $log_file
                        cp $workpath/integration/product/$productname/mmcp_publish_changhong $workpath/lib/mmcp_publish/. -rf
			
			#echo -e "================ now, begin to setupenv for hisense ==============" >> $log_file
                        #cd $workpath/integration/product/$productname
			#. setupenv --m hisense
                        #make clean > /dev/null 2>&1
                        #make >> $log_file_detail  2>&1
                        #make bin >> $log_file_detail  2>&1
                        #make publish > /dev/null 2>&1
			#echo "MMCP SVN Version: $nowmmcpver" >> mmcp_publish_hisense/ReleaseNotes.txt

                        ### copy
                        #echo -e "================ now, begin to copy mmcp_publish for hisense ==============" >> $log_file
                        #cp $workpath/integration/product/$productname/mmcp_publish_hisense $workpath/lib/mmcp_publish/.  -rf

                elif [ "$prj" = "mmcp_tianjin_hi3716m_v300" ]
                then
			echo -e "============= now, begin to make tianjin_hi3716m_v300 mmcp_publish ============" >> $log_file
                        echo -e "============= now, begin to make tianjin_hi3716m_v300 mmcp_publish ============"
			env_list="hisense yinhe panodic tcb changhong"

                        if [ -d $workpath/lib/mmcp_publish ]
                        then
                                rm $workpath/lib/mmcp_publish -rf
                        fi
                        mkdir $workpath/lib/mmcp_publish -p

                        cd $workpath/integration/product/$productname
                        for envname in $env_list
                        do
                                rm mmcp_publish -rf
                                . setupenv $envname
                                make clean > /dev/null 2>&1
                                make >> $log_file_detail  2>&1
				if [ $? -eq 0 ]
                        	then
                                	echo -e "================ make $productname mmcp_publish success =============="
                                	echo  -e "================ make $productname mmcp_publish success ===========" >> $log_file
                        	else                            
                                	echo  -e "================ make $productname mmcp_publish failed ============" >> $log_file
                                	echo -e "================ make $productname mmcp_publish failed =============="
                        fi
                                make publish > /dev/null 2>&1

                                ### copy
                                echo -e "================ now, begin to copy mmcp_publish for $envname ==============" >> $log_file
                                cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/mmcp_publish/$envname -rf
                        done
	
		elif [ "$prj" = "mmcp_wuhan_hi3716m" ]
                then
                        echo -e "============= now, begin to make wuhan_hi3716m mmcp_publish ============" >> $log_file
                        echo -e "============= now, begin to make wuhan_hi3716m  mmcp_publish ============"
                        env_list="skyworth"

                        if [ -d $workpath/lib/mmcp_publish ]
                        then
                                rm $workpath/lib/mmcp_publish -rf
                        fi
                        mkdir $workpath/lib/mmcp_publish -p

                        cd $workpath/integration/product/$productname
                        for envname in $env_list
                        do
                                rm mmcp_publish -rf
                                . setupenv $envname
                                make clean > /dev/null 2>&1
                                make >> $log_file_detail  2>&1
                                if [ $? -eq 0 ]
                                then
                                        echo -e "================ make $productname mmcp_publish success =============="
                                        echo  -e "================ make $productname mmcp_publish success ===========" >> $log_file
                                else
                                        echo  -e "================ make $productname mmcp_publish failed ============" >> $log_file
                                        echo -e "================ make $productname mmcp_publish failed =============="
                        fi
                                make publish > /dev/null 2>&1

                                ### copy
                                echo -e "================ now, begin to copy mmcp_publish for $envname ==============" >> $log_file
                     done
   
		else	
			if [ "$prj" = "JL" ]
			then
				productname=$productname/st5105
			fi	

			echo -e "============= now, begin to make $prj $productname mmcp_publish ============" >> $log_file
                        echo -e "============= now, begin to make $prj $prductname mmcp_publish ============"
			cd $workpath/integration/product/$productname
                        if [ $? -eq 0 ]
                        then
                                chmod 777 -Rf *
				if [ -d mmcp_publish ]
				then
                                	rm mmcp_publish -rf
				fi

                                . setupenv
                                make clean > /dev/null 2>&1
                                make >> $log_file_detail  2>&1
				if [ $? -eq 0 ]
                        	then
                                	echo -e "================ make $productname mmcp_publish success =============="
                                	echo  -e "============ make $productname mmcp_publish success ==============" >> $log_file
                        	else                            
                                	echo  -e "============== make $productname mmcp_publish failed ==============" >> $log_file
                                	echo -e "================ make $productname mmcp_publish failed =============="
                        	fi
				if [ "$prj" = "mmcp_guangdong_hi3110e" ]
				then
					make bin >> $log_file_detail  2>&1
				fi
                                make publish > /dev/null 2>&1

                                ### copy
                                echo -e "============= now, begin to copy mmcp_publish for $productname ============" >> $log_file

				if [ -d $workpath/lib/mmcp_publish ]
                        	then
                                	rm $workpath/lib/mmcp_publish -rf
                        	fi
                                cp $workpath/integration/product/$productname/mmcp_publish $workpath/lib/mmcp_publish/ -rf
                        fi
		fi
	fi
fi

echo  -e "========================== make finished,begin to copy =========================="
echo ==================flag3rdnomake:$flag3rdnomake,flagmmcpnomake:$flagmmcpnomake,flagdebug:$flagdebug===========================

### make over begin to copy
if [ "$flag3rdnomake" -eq 1 ] || [ "$flagmmcpnomake" -eq 1 ]
then
	if [ "$productname" != "" ] || [ "$copyall" -eq 1 ]
	then
		cp $workpath/lib $allpath/output -fr 
		cp $workpath/include $workpath/include_release -fr
		cd $workpath/include_release && \
		echo  ======================== find .svn with include and remove them ==========================
		find -name ".svn"  -exec rm -fr {} \;
		mv  $workpath/include_release  $allpath/output/

		
		## copy to pub
		creattime=`date +%Y%m%d%H%M`
		mkdir /hudson16/public/$prj/$creattime\_$nowmmcpver/lib -p
		if [ $? -eq 0 ]
		then
                	cp $allpath/output/* /hudson16/public/$prj/$creattime\_$nowmmcpver/lib -fr
                	cp $allpath/logs /hudson16/public/$prj/$creattime\_$nowmmcpver/log -fr
		else
			echo  -e "========================== mkdir public file failed =========================="
		fi

		## end
	else
		if [ "$flagdebug" -eq 1 ]
		then
			mkdir -p $allpath/output/lib/$plat_list/debug
			cp $workpath/lib/$plat_list/debug/libmmcp*.* $workpath/lib/$plat_list/debug/libmis*.* $workpath/lib/$plat_list/debug/libtts*.* $allpath/output/lib/$plat_list/debug -fr
	        	echo -e "mod:debug release" >> $log_file
		fi

		mkdir -p $allpath/output/lib/$plat_list/release
		cp $workpath/lib/$plat_list/release/libmmcp*.* $workpath/lib/$plat_list/release/libmis*.* $workpath/lib/$plat_list/release/libtts*.* $allpath/output/lib/$plat_list/release -fr

		cp $workpath/lib/dtvmxjar $allpath/output/lib -fr
		cp $workpath/include $workpath/include_release -fr
		cd $workpath/include_release && \
		find -name ".svn"  -exec rm -fr {} \;
		mv  $workpath/include_release  $allpath/output/
		
		cd $workpath
		zip -q -r -P 110110 $allpath/output/output_$nowmmcpver.zip lib	
	
		## copy to publisher
		creattime=`date +%Y%m%d%H%M`
                mkdir /hudson16/public/$prj/$creattime\_$nowmmcpver/lib -p
                if [ $? -eq 0 ]
                then
                        cp $allpath/output/* /hudson16/public/$prj/$creattime\_$nowmmcpver/lib -fr
                        cp $allpath/logs /hudson16/public/$prj/$creattime\_$nowmmcpver/log -fr
                else
                        echo  -e "========================== mkdir public file failed =========================="
		fi

	fi
fi

echo ========================== write this version to txt ==========================
echo $nowmmcpver > $lastmmcpverlog

#grep "failed"  $log_file
if [ "$libtype" = "ew210" ] && [ -f $workpath/lib/$plat_list/release/libmmcp_ew210*.* ]
then
	echo -e "======================== ew210 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
        exit 0

elif [ "$libtype" = "ew510" ] && [ -f $workpath/lib/$plat_list/release/libmmcp_ew510*.* ]
then
	echo -e "========================== ew510 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
        exit 0

elif [ "$plat_list" = "Android_6A801_Client" ] && [ -f $workpath/lib/Android_6A801/release/libmmcp_ew510*.a ]
then
        echo -e "========================== ew510 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
        exit 0

elif [ "$prj" = "mmcp_guangdong_android_6A801" ] && [ -f $workpath/lib/$plat_list/release/libmmcp_ew600*.a ]
then        
	echo -e "========================== ew600 make success ==========================" >> $log_file        
	echo -e "Good all make success" >> $log_failedinfo        
	echo -e "</infoxml>" >> $log_failedinfo   
	exit 0

elif [ "$prj" = "mmcp_guangdong_android_6A801_client" ] && [ -f $workpath/lib/Android_6A801_Client/release/libmmcp_ew600*.a ]
then
        echo -e "========================== ew600 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
	exit 0

elif [ "$prj" = "mmcp_guangdong_android_hi3716c" ] && [ -f $workpath/lib/$plat_list/release/libmmcp_ew600*.a ]
then
        echo -e "========================== ew600 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
	exit 0

elif [ "$prj" = "mmcp_guangdong_android_hi3716c_client" ] && [ -f $workpath/lib/$plat_list/release/libmmcp_ew600*.a ]
then
        echo -e "========================== ew600 make success ==========================" >> $log_file
        echo -e "Good all make success" >> $log_failedinfo
        echo -e "</infoxml>" >> $log_failedinfo
	exit 0

else
	echo -e "========================== make failed =========================="
	echo -e "========================== make failed ==========================" >> $log_file
        echo -e "</infoxml>" >> $log_failedinfo
        exit 1
fi







