######################################################
#############     web 应用机发布脚本		 #############
######################################################
#!/bin/sh
#重载环境
source  /etc/profile
#定义变量
#-----------------------------------------
port1=$1     #7005
port2=$2		 #7105	
PRJ_NAME=$3   #ppy_web		
PRJ_RELEASE_PACKAGE=$4   #pingogo-web-1.0-SNAPSHOT.war   
SERVICE_PATTERN_port1=tomcat-$PRJ_NAME-$port1    #tomcat-ppy_web-7005
SERVICE_PATTERN_port2=tomcat-$PRJ_NAME-$port2		 #tomcat-ppy_web-7105

#-----------------------------------------
#查找启动的tomcat是哪个
pid1=`ps -ef |grep -v grep|grep "$SERVICE_PATTERN_port1"|awk '{print $2}'`
pid2=`ps -ef |grep -v grep|grep "$SERVICE_PATTERN_port2"|awk '{print $2}'`
if [ -n "$pid1" -a -z "$pid2" ];then 
	#删除旧的tomcat中的文件
	cd  /app/apps/$SERVICE_PATTERN_port2/webapps/  &&  rm -rf  *   && echo "删除旧的war" 
	mv  /app/release/$PRJ_NAME/$PRJ_RELEASE_PACKAGE  /app/apps/$SERVICE_PATTERN_port2/webapps/$PRJ_RELEASE_PACKAGE   
	mv  /app/apps/$SERVICE_PATTERN_port2/webapps/$PRJ_RELEASE_PACKAGE  /app/apps/$SERVICE_PATTERN_port2/webapps/ROOT.war
	#启动tomcat
	echo "启动tomcat-$2"
        /app/apps/$SERVICE_PATTERN_port2/bin/startup.sh && echo "启动tomcat-$2的tomcat" 
	#测试升级是否正常
	sleep 40s 
	tail -500 /app/apps/$SERVICE_PATTERN_port2/logs/catalina.out
	message=`curl -I http://localhost:$2|grep 200`
	if [ -n "$message" ];then	
			echo "tomcat启动成功"
			#切换nginx端口
			SERVER1=`cat /usr/local/nginx/conf/nginx.conf|grep -w $1|awk '{print $1}'`
			SERVER2=`cat /usr/local/nginx/conf/nginx.conf|grep -w $2|awk '{print $1}'`
			if [ $SERVER1 = "server" ];then
				sed -i "/$1/s/server/#server/" /usr/local/nginx/conf/nginx.conf
			else 
				sed -i "/$1/s/#server/server/" /usr/local/nginx/conf/nginx.conf
			fi
			if [ $SERVER2 = "server" ];then
				sed -i "/$2/s/server/#server/" /usr/local/nginx/conf/nginx.conf
			else 
				sed -i "/$2/s/#server/server/" /usr/local/nginx/conf/nginx.conf
			fi
			/usr/local/nginx/sbin/nginx -s reload && echo "nginx端口从 $1 切换到 $2" 
			if [ $? -eq 0 ];then
				sleep 5s
				kill -9 $pid1 && echo "关闭了端口为 $1 的tomcat"
			else	
				echo "nginx的重加载为成功，但是tomcat-$2 停止失败，请手动执行并停掉之前 $1 的tomcat"
			fi
	else
			echo "tomcat-$1 启动失败，请查看日志"
			exit -1	
	fi						
elif [ -z "$pid1" -a -n "$pid2" ];then
	#删除旧的tomcat中的文件
	cd  /app/apps/$SERVICE_PATTERN_port1/webapps/  &&  rm -rf  * && echo "删除旧的war"
	mv  /app/release/$PRJ_NAME/$PRJ_RELEASE_PACKAGE  /app/apps/$SERVICE_PATTERN_port1/webapps/$PRJ_RELEASE_PACKAGE
	mv  /app/apps/$SERVICE_PATTERN_port1/webapps/$PRJ_RELEASE_PACKAGE  /app/apps/$SERVICE_PATTERN_port1/webapps/ROOT.war
	#启动tomcat
	/app/apps/$SERVICE_PATTERN_port1/bin/startup.sh && echo "启动 $1 的tomcat" 
	#测试升级是否正常
	sleep 40s
	tail -500 /app/apps/$SERVICE_PATTERN_port1/logs/catalina.out  
	message=`curl -I http://localhost:$1|grep 200`
	if [ -n "$message" ];then	
			echo "tomcat启动成功"
			#切换nginx端口
			SERVER1=`cat /usr/local/nginx/conf/nginx.conf|grep -w $1|awk '{print $1}'`
			SERVER2=`cat /usr/local/nginx/conf/nginx.conf|grep -w $2|awk '{print $1}'`
			if [ $SERVER1 = "server" ];then
				sed -i "/$1/s/server/#server/" /usr/local/nginx/conf/nginx.conf
			else 
				sed -i "/$1/s/#server/server/" /usr/local/nginx/conf/nginx.conf
			fi
			if [ $SERVER2 = "server" ];then
				sed -i "/$2/s/server/#server/" /usr/local/nginx/conf/nginx.conf
			else 
				sed -i "/$2/s/#server/server/" /usr/local/nginx/conf/nginx.conf
			fi
			/usr/local/nginx/sbin/nginx -s reload && echo "nginx端口从 $2 切换到 $1" 
			if [ $? -eq 0 ];then
				sleep 5s
				kill -9 $pid2 && echo "关闭了端口为 $2 的tomcat"
			else	
				echo "nginx重载失败，请手动重载nginx。tomcat-$2停止失败，请手动执行并停掉之前的$2的tomcat"
			fi
	else
			echo "tomcat-$1 启动失败，请查看日志"
			exit -1
	fi
else 
		echo "2个tomcat都在启动，请查看"
fi
sh shm.sh
