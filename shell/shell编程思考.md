# Shell编程思考

## 1. 数据备份脚本

### 编程思路
1. 系统备份数据按每天日期存放
2. 创建完全备份的方法
3. 创建增量备份的方法
4. 根据星期日判断完全备份或者增量备份
5. 将脚本加入到crontab实现自动备份

## 2. 服务器信息收集脚本

### 编程思路
- 使用`awk`，`grep`，`find`获取服务器的基本信息

## 3. 服务器拒绝恶意ip登录

### 编程思路
1. 登录服务器日志`/var/log/secure`
2. 检查日志中认证失败3次以上的ip并打印
3. 在`iptables`上将该ip服务器访问22端口的请求drop掉
4. 将脚本加入到crontab实现自动禁用ip

## 4. Zabbix客户端的安装、使用

### 编程思路
1. 编写zabbix-agentd的安装方法
2. cp zabbix-agentd的启动进程到`/etc/init.d/zabbix_agented`
3. 配置`zabbix-agentd.conf`文件，指定server IP
4. 启动zabbix-agentd服务，创建zabbix的user

## 5. Docker的发布脚本

### 编程思路
1. 将旧的docker进程停掉，删掉容器和镜像
2. 用Dockerfile+jenkins打好的程序包生成对应的镜像
3. 然后直接运行新的镜像

## 6. K8s的发布脚本

### 编程思路
1. 获取之前的旧本号，新的版本号加0.1
2. 用Dockerfile+jenkins打好的程序包生成对应新的镜像并上传到harbor仓库
3. 使用`set image`更换deployment为新生成的镜像
