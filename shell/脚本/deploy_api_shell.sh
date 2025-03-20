# API服务部署脚本

## 脚本信息
- 作者：wuxiang
- 创建时间：2018-05-23

## 功能说明
该脚本用于部署API服务，主要功能包括：
- WAR包部署和备份
- Tomcat服务管理
- Nginx配置切换
- 端口管理和进程控制

## 环境要求
- WAR包路径：`/app/maintain/tmp_war`
- 备份路径：`/app/maintain/backup/`

## 使用方法
```bash
#!/bin/bash

read -p "服务名：（如:ppy_web,ppy_api,css,pay_core,statistics,supplier,support_center）"   SERVER
read -p "版本号:(如1234)"  VERSION
date=`date +%Y%m%d`
cd /app/maintain/tmp_war/ && filename=`find . -name *api*.war |awk -F '/' '{print $2}'`
if [ -z "$filename" ];then
	echo "目录/app/maintain/tmp_war/无以web.war命名的包"
	exit 1
fi

# 备份原ROOT.war文件
cp $filename   /app/maintain/backup/$SERVER/$SERVER.$date-$VERSION.war && echo "备份文件ROOT.war.$date到目录/app/maintain/backup/$SERVER/"
```

## PPY_WEB服务部署流程
```bash
if  [ $SERVER = "ppy_web" ]
then
	echo "ppy_web环境部署"
	pid1=`ps -ef |grep -v grep|grep "api-7101"|awk '{print $2}'`
	pid2=`ps -ef |grep -v grep|grep "api-7001"|awk '{print $2}'`
	if [ -n "$pid1" -a -z "$pid2" ];then 	
		# 删除原webapps目录的ROOT和ROOT.war文件	
		cd /app/apps/tomcat-ppy_api-7001/webapps/ 
		rm -r ROOT
		rm  ROOT.war   
		# 将war包放到webapps目录	
		mv  /app/maintain/tmp_war/$filename  /app/apps/tomcat-ppy_api-7001/webapps/
		mv  $filename	ROOT.war   
		# 启动tomcat  
		/app/apps/tomcat-ppy_api-7001/bin/startup.sh&&echo "启动7001的tomcat" 
		# 测试升级是否正常
		sleep 40s 
		message=`curl -I http://localhost:7001|grep 200`
		if [ -n "$message" ];then	
			echo "tomcat启动成功"
			# 切换nginx端口
			SERVER1=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7001|awk '{print $1}'`
			SERVER2=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7101|awk '{print $1}'`
			if [ $SERVER1 = "server" ];then
				sed -i /7001/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7001/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			if [ $SERVER2 = "server" ];then
				sed -i /7101/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7101/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			sudo /usr/local/nginx/sbin/nginx  -s  reload  && echo "nginx端口从7101切换到7001"  
            # 关闭原端口
            if [ $? -eq 0  ];then                                
				/app/apps/tomcat-ppy_web-7101/bin/shutdown.sh
                sleep 3s
                pid3=`ps -ef |grep -v grep|grep "api-7101"|awk '{print $2}'`
                if [ -n $pid3 ];then
					kill -9 $pid3 && echo "关闭了端口为7101的tomcat"
				fi
			fi
		else
			echo "7001tomcat启动失败，请查看日志"
			exit -1
		fi
	elif [ -z "$pid1" -a -n "$pid2" ];then	
		# 删除原webapps目录的ROOT和ROOT.war文件
		cd /app/apps/tomcat-ppy_api-7101/webapps/ 
		rm -r ROOT
		rm  ROOT.war
		# 将war包放到webapps目录
		mv  /app/maintain/tmp_war/$filename  /app/apps/tomcat-ppy_api-7101/webapps/
		mv  $filename	ROOT.war
		# 启动tomcat 
		/app/apps/tomcat-ppy_api-7101/bin/startup.sh && echo "启动7101的tomcat"    
		# 测试升级是否正常
		sleep 40s 
		message=`curl -I http://localhost:7101|grep 200`
		if [ -n "$message" ];then	
			echo "tomcat启动成功"
			# 切换nginx端口
			SERVER1=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7001|awk '{print $1}'`
			SERVER2=`cat /usr/local/nginx/conf/nginx.conf|grep -w 7101|awk '{print $1}'`
			if [ $SERVER1 = "server" ];then
				sed -i /7001/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7001/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			if [ $SERVER2 = "server" ];then
				sed -i /7101/s/server/#server/ /usr/local/nginx/conf/nginx.conf
			else 
				sed -i /7101/s/#server/server/ /usr/local/nginx/conf/nginx.conf
			fi
			sudo /usr/local/nginx/sbin/nginx  -s  reload && echo "nginx端口从7001切换到7101" 
			# 关闭原端口
			if [ $? -eq 0  ];then                                
				/app/apps/tomcat-ppy_web-7001/bin/shutdown.sh
                sleep 3s
                pid3=`ps -ef |grep -v grep|grep "api-7001"|awk '{print $2}'`
				if [ -n $pid3 ];then
					kill -9 $pid3 && echo "关闭了端口为7001的tomcat"
				fi
			fi
		else
			echo "7015tomcat启动失败，请查看日志"
			exit -1
		fi
	else
		echo "7001和7101tomcat都启动了"
		exit 2
	fi
fi
```