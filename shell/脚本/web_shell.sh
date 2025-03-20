#!/bin/bash
#auth  wuxiang
#time   2018-05-23
#先将war包指定到路径/app/maintain/tmp_war
#war包备份路径/app/maintain/backup/

read -p "服务名：（如:ppy_web,ppy_api,css,pay_core,statistics,supplier,support_center）"   SERVER
read -p "版本号:(如1234)"  VERSION
date=`date +%Y%m%d`
cd /app/maintain/tmp_war/ && filename=`find . -name *web*.war |awk -F '/' '{print $2}'`
if [ -z "$filename" ];then
	echo "目录/app/maintain/tmp_war/无以web.war命名的包"
	exit 1
fi
#备份原ROOT.war文件到/app/maintain/backup/。
cp $filename   /app/maintain/backup/$SERVER/$SERVER.$date-$VERSION.war && echo "备份文件ROOT.war.$date到目录/app/maintain/backup/$SERVER/"

#PPY_WEB服务
if  [ $SERVER = "ppy_web" ]
then
	echo "ppy_web环境部署"
	pid1=`ps -ef |grep -v "grep"|grep "web-7105"|grep -v "catalina.out"|awk '{print $2}'`
	pid2=`ps -ef |grep -v "grep"|grep "web-7005"|grep -v "catalina.out"|awk '{print $2}'`
	if [ -n "$pid1" -a -z "$pid2" ];then 	
		#删除原webapps目录的ROOT和ROOT.war文件	
		cd /app/apps/tomcat-ppy_web-7005/webapps/ 
		rm -r ROOT
		rm  ROOT.war   
		#将war包放到webapps目录	
		mv  /app/maintain/tmp_war/$filename  /app/apps/tomcat-ppy_web-7005/webapps/
		mv  $filename	ROOT.war   
		#启动tomcat  
		/app/apps/tomcat-ppy_web-7005/bin/startup.sh&&echo "启动7005的tomcat" 
		#测试升级是否正常
		sleep 40s 
		message=`curl -I http://localhost:7005|grep 200`
		if [ -n "$message" ];then	
			echo "tomcat启动成功"
			#切换nginx端口
			SERVER1=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7005|awk '{print $1}'`
			SERVER2=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7105|awk '{print $1}'`
			if [ $SERVER1 = "server" ];then
				sed -i /7005/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7005/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			if [ $SERVER2 = "server" ];then
				sed -i /7105/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7105/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			/usr/local/nginx/sbin/nginx  -s  reload  && echo "nginx端口从7105切换到7005"  
			#测试服务
			kill -9 $pid1 && echo "关闭了端口为7105的tomcat" 
		else
			echo "7005tomcat启动失败，请查看日志"
			exit -1
		fi
	elif [ -z "$pid1" -a -n "$pid2" ];then	
		#删除原webapps目录的ROOT和ROOT.war文件
		cd /app/apps/tomcat-ppy_web-7105/webapps/ 
		rm -r ROOT
		rm  ROOT.war
		#mv  ROOT.war.$date    /app/maintain/backup/$SERVER/
		#将war包放到webapps目录
		mv  /app/maintain/tmp_war/$filename  /app/apps/tomcat-ppy_web-7105/webapps/
		mv  $filename	ROOT.war
		#启动tomcat 
		/app/apps/tomcat-ppy_web-7105/bin/startup.sh && echo "启动7105的tomcat"    
		#测试升级是否正常
		sleep 40s 
		message=`curl -I http://localhost:7105|grep 200`
		if [ -n "$message" ];then	
			echo "tomcat启动成功" 
			#关闭原端口
            kill -9 $pid2 && echo "关闭了端口为7005的tomcat"
		else
			echo "7015tomcat启动失败，请查看日志"
			exit -1
		fi
	else
		echo "7005和7105tomcat都启动了"
		exit 2
	fi
fi