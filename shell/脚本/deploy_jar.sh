#!/bin/sh

export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_171
export PATH=$JAVA_HOME/bin:$PATH

#定义变量
#-----------------------------------------
PRJ_NAME=$1
PRJ_RELEASE_PACKAGE=$2
SERVICE_PATTERN=$PRJ_NAME
#-----------------------------------------
if  [ $# -ne  2 ];then
echo "请输入2个参数，不能多不能少"
exit   2
fi
#deploy
#-----------------------------------------
#生成版本号
var_release_version=`date +%Y%m%d%H%M%S`
echo ================== release version: $var_release_version
#判断release项目目录是否存在
if [ ! -d /app/release/$PRJ_NAME ]
then
   mkdir -p /app/release/$PRJ_NAME
fi
#判断depoly项目目录是否存在
if [ ! -d /app/deploy/$PRJ_NAME ]
then
    mkdir -p /app/deploy/$PRJ_NAME
fi
#move部署包
echo ================== move app package to release directory
cp /app/release-temp/$PRJ_RELEASE_PACKAGE -d /app/release/$PRJ_NAME/$PRJ_NAME-$var_release_version.jar
sleep 1

#删除多余历史版本，保留2个版本
cd /app/release/$PRJ_NAME 
max=`ls -l |grep $PRJ_NAME |wc -l`
min=2
if [ $max -gt $min ]
then
   num=`expr $max - $min`
   rm -rf `ls -t|grep $PRJ_NAME |tail -n $num`
else
   echo ================ no version delete
fi

#更改当前版本链接
echo ================== link current version
rm /app/deploy/$PRJ_NAME/$PRJ_NAME.jar
ln -sf /app/release/$PRJ_NAME/$PRJ_NAME-$var_release_version.jar /app/deploy/$PRJ_NAME/$PRJ_NAME.jar

echo ================== app stopping

pidlist=`ps -ef|grep $SERVICE_PATTERN |grep -v "grep" |grep -v "deploy_jar"|grep -v "tail"|awk '{print $2}'`
echo old version pid: $pidlist
if [ ! -n "$pidlist" ]
then  
  echo "app not running"  
else  
  echo "kill old version"
  kill $pidlist
fi    

isAppRunning(){
	ps -ef | grep $SERVICE_PATTERN | grep -v grep | grep -v deploy_jar | grep -v tail
	if [ $? -ne 0 ]
	then
	echo 'not running'
	return 0
	else
	echo 'running'
	return 1
	fi
}


# while 循环10次，检测进程是否存在
VAR_RUNNING=1
COUNTER=0
while [ $COUNTER -lt 10 ]
do
    COUNTER=`expr $COUNTER + 1`
    echo wait times: $COUNTER
    isAppRunning
    VAR_RUNNING=$?  	#$?获取上一个方法执行的返回值
    echo is running: $VAR_RUNNING
    sleep 1
    if [ $VAR_RUNNING -eq 0 ]
    then
	echo break
        break
    fi
done


if [ $VAR_RUNNING -eq 0 ]
then
	#服务已停止,开始重新启动
	echo ================== app stopped
	echo ================== app restarting
	cd /app/deploy/$PRJ_NAME/
	nohup java -jar -Xms1024m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=128m $PRJ_NAME.jar &>$PRJ_NAME-nohup.log &
	echo ================== wait 5s...
	sleep 5
	isAppRunning
	if [ $? -eq 1 ]
    then
		echo ================== success to restart app
	else
		echo ================== pending to restart app
    fi

else
	#服务仍在运行，重启失败
	echo ================== failed to stop older version of app
fi

