# Jenkins启动脚本

## 功能说明
这是一个用于管理Jenkins服务的Shell脚本，支持以下功能：
- 启动Jenkins服务
- 停止Jenkins服务
- 重启Jenkins服务
- 查看Jenkins服务状态

## 使用方法
```bash
./jenkins_control.sh [start|status|stop|restart]
```

## 脚本内容
```bash
#!/bin/bash
#auther   wuxiang
set -e
if [ $# -ne 1 ];then
	echo "请输入一个参数"
	exit 1
fi

usage(){
	echo "please input like : $0 [start|start|stop|restart]"  #提示输入参数
}

start_jenkins(){
	nohup java -jar /home/dsm/soft/jenkins/jenkins.war --httpPort=7999 &> jenkins.out &
	if [ $? -eq 0 ];then
		echo "jenkins启动成功"
	else
		echo "jenkins启动失败"
	fi
}

status_jenkins(){
	ps -ef |grep "jenkins"|grep -v "grep"
}

stop_jenkins(){
	pid=`ps -ef |grep jenkins|grep java|grep -v "grep"|grep -v "tail"`
	kill -9 $pid  &> /dev/null
	if [ $? -eq 0 ];then
                echo "jenkins停止成功"
        else
                echo "jenkins停止失败"
	fi	
}

restart_jenkins(){
	pid=`ps -ef |grep jenkins|grep java|grep -v "grep"|grep -v "tail"`
	kill -9 $pid  &> /dev/null
	if [ $? -eq 0 ];then
                echo "jenkins停止成功"
		nohup java -jar /home/dsm/soft/jenkins/jenkins.war --httpPort=7999 &> jenkins.out &
		if [ $? -eq 0 ];then
			echo "jenkins启动成功"
		else
			echo "jenkins启动失败"
		fi
	else
		echo "jenkins停止失败"
	fi
}

main(){
case $1 in
	start)
		start_jenkins;;
	status)	
		status_jenkins;;
	stop)
		stop_jenkins;;
	restart)	
		restart_jenkins;;
	*)
		usage;;
esac
}

main $1
```

## 参数说明
- `start`: 启动Jenkins服务，使用端口`7999`
- `status`: 显示Jenkins进程状态
- `stop`: 停止Jenkins服务
- `restart`: 重启Jenkins服务

## 注意事项
1. 脚本需要有执行权限
2. Jenkins war包路径为：`/home/dsm/soft/jenkins/jenkins.war`
3. Jenkins日志输出到`jenkins.out`文件