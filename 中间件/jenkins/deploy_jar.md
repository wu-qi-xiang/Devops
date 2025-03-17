# Jenkins JAR包部署脚本

## 功能说明

这是一个用于Jenkins环境下部署JAR包的Shell脚本，主要功能包括：
- 版本管理：自动生成版本号并保留历史版本
- 目录管理：自动创建和维护release和deploy目录
- 进程控制：停止旧版本进程并启动新版本
- 备份管理：保留最近的版本用于回滚

## 使用方法

```bash
./deploy_jar.sh <项目名称> <包名称>
```

### 参数说明
- `PRJ_NAME`：项目名称
- `PACKAAGE_NAME`：部署包名称

## 脚本内容

```bash
#!/bin/sh
#auther  wuxiang
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
#-----------------------------------------
#生成版本号
var_release_version=`date +%Y%m%d%H%M%S`
echo "版本号: $var_release_version"
#判断release项目目录是否存在
if [ ! -d /home/jenkins/release/$PRJ_NAME ]
then
   mkdir -p /home/jenkins/release/$PRJ_NAME
fi
#判断depoly项目目录是否存在
if [ ! -d /home/jenkins/deploy/$PRJ_NAME ]
then
    mkdir -p /home/jenkins/deploy/$PRJ_NAME
fi
#复制部署包
echo "==== copy app package to release directory"
cp /home/jenkins/release-temp/$PACKAAGE_NAME.jar -d /home/jenkins/release/$PRJ_NAME/$PRJ_NAME-$var_release_version.jar && rm -f /home/jenkins/release-temp/$PACKAAGE_NAME.jar
sleep 1

#删除多余历史版本，保留2个版本
cd /home/jenkins/release/$PRJ_NAME 
max=`ls -l |grep $PRJ_NAME |wc -l`
min=3
if [ $max -gt $min ]
then
   num=`expr $max - $min`
   rm -rf `ls -t|grep $PRJ_NAME |tail -n $num`
else
   echo ==== no version delete
fi

#更改当前版本链接，保留旧版本原来回滚
echo "更改包的链接地址"
if [ ! -d /home/jenkins/deploy/$PRJ_NAME/bak ];then
	mkdir  /home/jenkins/deploy/$PRJ_NAME/bak
else
	cd /home/jenkins/deploy/$PRJ_NAME/bak  && rm -rf  *
fi

 mv  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar-bak   /home/jenkins/deploy/$PRJ_NAME/bak/
[ -e /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar ] &&   mv  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar-bak
[ ! -e /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar ] &&  ln -sf /home/jenkins/release/$PRJ_NAME/$PRJ_NAME-$var_release_version.jar  /home/jenkins/deploy/$PRJ_NAME/$PRJ_NAME.jar

#停止之前的程序
stop_app(){
	echo "app进程将要被kill"
	oldpid=`ps -ef|grep $PRJ_NAME |grep java|grep -v "grep" |grep -v "deploy_jar"|grep -v "tail"|grep -v "\.sh" |awk '{print $2}'`
	echo "old version pid: $oldpid"
	if [ ! -n "$oldpid" ]
	then  
	  echo "app没有运行"  
	else  
	  echo "kill -9 杀死进程"
	  kill -9 $oldpid
	fi    
}

#判断old程序的进程是否还在
isAppRunning(){
        echo "判断app进程是否存在"
	ps -ef | grep $PRJ_NAME | grep java |grep -v grep | grep -v "deploy_jar" | grep -v tail|grep -v "\.sh" 
	if [ $? -ne 0 ]
	then
	echo '进程不存在'
	return 0
	else
	echo '进程存在'
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
	echo "old app已经干掉，可以启动新的程序包"
        break
    else
	stop_app
    fi
done

#启动新的程序包
if [ $VAR_RUNNING -eq 0 ]
then
	#服务已停止,开始重新启动
	echo "app进程已杀死或者没启动，将启动新的app程序"
	cd /home/jenkins/deploy/$PRJ_NAME/
	#nohup java -jar -Xms1024m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=128m $PRJ_NAME.jar &>$PRJ_NAME-nohup.log &
	nohup java -jar  $PRJ_NAME.jar &> /dev/null  &
	echo "==== wait 5s..."
	sleep 5
	isAppRunning
	if [ $? -eq 1 ]
    then
		echo "新的app启动成功"
	else
		echo "新的app启动失败，请查看日志"
    fi
sleep 1 && cat /home/jenkins/scripts/wx.txt 
else
	#老服务停止失败
	echo "old app进程停止失败，app部署失败，请进入服务器查看原因"
	exit  -1
fi
```

## 主要功能说明

1. **版本管理**
   - 使用时间戳生成版本号
   - 保留最近2个版本，自动清理旧版本

2. **备份管理**
   - 部署前自动备份当前版本
   - 维护备份目录结构

3. **进程控制**
   - 自动检测并停止旧版本进程
   - 最多尝试10次停止进程
   - 启动新版本并验证启动状态

## 注意事项

1. 脚本需要两个参数：项目名称和包名称
2. 确保Jenkins用户对相关目录有读写权限
3. 部署失败时会自动退出并返回错误码