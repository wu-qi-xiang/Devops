# Jenkins WAR包部署脚本

## 脚本信息
- 作者：wuxiang
- 功能：Jenkins打包发布脚本

## 环境变量
```bash
#TOMCAT_PATH=/app/apps/tomcat7005-PPY_WEB
#WAR_PATH=$PWD/pingogo-web/target/
#bak_dir=/app/maintain/backup/
```

## 功能说明
1. WAR包检查和备份
2. Tomcat服务管理（停止/启动）
3. WAR包部署和文件管理
4. 服务状态检查

## 脚本内容
```bash
#!/bin/bash

date=`date +%Y%m%d`
cd  $WAR_PATH && filename=`find . -name *.war |awk -F '/' '{print $2}'`	
if [ -z "$filename" ];then
	echo "打包失败，未生成war包"
	exit 1
fi

if [ -d /app/maintain/backup/$SERVER/ ];then
		cp  $filename  /app/maintain/backup/$SERVER/web.$date.war  && echo "备份文件到目录/app/maintain/backup/$SERVER/"  
else
	 	mkdir -p  /app/maintain/backup/$SERVER/ 	  	
		cp  $filename  /app/maintain/backup/$SERVER/web.$date.war  && echo "备份文件到目录/app/maintain/backup/$SERVER/"   
fi

#停止tomcat
function  kill_tomcat(){
tid=`ps -ef |grep "tomcat7005"|grep -v "grep"|grep -v "catalina.out"|awk '{print $2}'`
if [ -z "$tid" ]
then
echo "tomcat没有启动"
else
kill -9 $tid
fi
}
kill_tomcat

#备份原war文件，删除原解压文件。拷贝war包到tomcat目录并修改包名
cp  $filename    $TOMCAT_PATH/webapps/
cd  $TOMCAT_PATH/webapps/ && rm  -rf   ROOT  	ROOT.war 	
mv  $filename   ROOT.war && echo "tomcat的war已经替换"

#启动tomcat
cd $TOMCAT_PATH && ./bin/startup.sh
function start_tomcat(){
ID=`ps -ef |grep "tomcat7005"|grep -v "grep"|grep -v "catalina.out"|awk '{print $2}'`
if [ -z "$ID" ];then
	cd $TOMCAT_PATH && ./bin/startup.sh
fi
}
start_tomcat
sleep 30s
message=`curl -I http://localhost:7005|grep 200`
if [ -n  message ];then
		echo "升级正常，请访问网页进行测试"
else
		echo "升级不正常，请检查tomcat日志，打包参数。"
		tail -500  $TOMCAT_PATH/logs/*out
fi 
```