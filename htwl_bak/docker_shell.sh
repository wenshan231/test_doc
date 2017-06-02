if ( docker ps -a |grep htwl_wljk_video-catch-image )
then
	docker rm -f htwl_wljk_video-catch-image
    docker rmi -f htwl_wljk_video-catch-image 
	mvn clean package docker:removeImage docker:build
elif(docker images |grep htwl_wljk_video-catch-image)
then
      docker rmi -f htwl_wljk_video-catch-image 
      mvn clean package docker:removeImage docker:build
 
else
     mvn clean package docker:removeImage docker:build
fi


docker run -d -e TZ="Asia/Shanghai" -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime  -p 9603:9603 -P --name htwl_wljk_video-catch-image -h consul-server htwl_wljk_video-catch-image