# Jenkins JAR包回滚脚本

## 功能说明

这是一个用于回滚Jenkins部署的JAR包的Shell脚本，主要功能包括：
- 还原上一个版本的JAR包
- 停止当前运行的程序
- 启动回滚后的JAR包

## 使用方法

```bash
./rollback_jar.sh [项目名称] [包名称]
```

## 参数说明
- `PRJ_NAME`: 项目名称
- `PACKAAGE_NAME`: 包名称

## 脚本内容

```bash
#!/bin/sh
#auther  wuxiang
#环境变量
#set -e
source /etc/profile
#防止jenkins干掉刚起的程序
BUILD_ID=DONTKILLME  

#定义变量
#-----------------------------------------
PRJ_NAME=$1
PACKAAGE_NAME=$2
#-----------------------------------------
if  [ $# -ne  2 ];then
	echo "请输入2个参数，不能多不能少"
	exit   2
fi
#还原上次的版本安装包
if [ -e /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar-bak ];then
	mv  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar-bak  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar 
fi
#停止之前的程序
echo "===== app stopping"
stop_app(){
oldpid=`ps -ef|grep $PRJ_NAME |grep java|grep -v "grep" |grep -v "deploy_jar"|grep -v "tail"|grep -v "\.sh"|awk '{print $2}'`
echo "old version pid: $oldpid"
if [ ! -n "$oldpid" ]
then  
  echo "app not running"  
else  
  echo "kill old version"
  kill  -9 $oldpid
fi    
}

#判断old程序的进程是否还在
isAppRunning(){
	ps -ef | grep $PRJ_NAME | grep java |grep -v grep | grep -v "deploy_jar" | grep -v tail|grep -v "\.sh" 
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
    echo "wait times: $COUNTER"
    isAppRunning
    VAR_RUNNING=$?  	#$?获取上一个方法执行的返回值
    sleep 1
    if [ $VAR_RUNNING -eq 0 ]
    then
	echo "old程序已经干掉，可以启动新的程序包"
        break
    else
	stop_app
    fi
done

#启动新的程序包
if [ $VAR_RUNNING -eq 0 ]
then
	#服务已停止,开始重新启动
	echo "===== app stopped,will start new app"
	cd /home/jenkins/deploy/$PRJ_NAME/
	#nohup java -jar -Xms1024m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=128m $PRJ_NAME.jar &>$PRJ_NAME-nohup.log &
	nohup java -jar  $PRJ_NAME.jar &> /dev/null &
	echo "==== wait 5s..."
	sleep 5
	isAppRunning
	if [ $? -eq 1 ]
    then
		echo "===== success to start  new  app"
	else
		echo "===== new  app   start  failed"
    fi
#timeout 30s tail -f  $PRJ_NAME-nohup.log 
sleep 1 && cat /home/jenkins/scripts/wx.txt 
#sleep 30s
#tail -500 $PRJ_NAME-nohup.log
else
	#老服务停止失败
	echo "===== failed to stop older version of app"
	exit -1
fi
```

## 注意事项

1. 确保Jenkins用户对相关目录有读写权限
2. 脚本会自动备份当前版本为`.jar-bak`文件
3. 脚本包含进程检查机制，最多尝试10次确保旧进程被正确停止
4. 启动新程序后会等待5秒检查进程状态
5. 如果停止旧版本失败，脚本会退出并返回错误码-1