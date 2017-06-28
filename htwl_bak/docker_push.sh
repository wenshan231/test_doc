if ( docker ps -a |grep registry )
then
	docker rm -f registry
fi
docker run -d -p 5000:5000 --restart=always --name registry -v /data/registry:/var/lib/registry 



docker run -d -e TZ="Asia/Shanghai" -p 9603:9603 -P --name htwl_wljk_video-catch-image -h consul-server htwl_wljk_video-catch-image
docker run -d -e TZ="Asia/Shanghai" -P --name ${JOB_NAME} -h consul-server ${JOB_NAME}