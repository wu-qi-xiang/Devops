# SaltStack 基础

## 架构概述
SaltStack采用C/S模式：
- server端是salt的master
- client端是minion
- minion与master之间通过ZeroMQ消息队列通信

## 通信机制
### Minion和Master的认证
minion上线后先与master端联系，把自己的pub key发过去，这时master端通过`salt-key -L`命令就会看到minion的key，接受该minion-key后，master与minion就建立了互信关系。

### 工作原理
1. Salt stack的Master与Minion之间通过ZeroMq进行消息传递，使用了ZeroMq的发布-订阅模式，连接方式包括tcp，ipc
2. salt命令执行流程：
   - 将`cmd.run ls`命令从`salt.client.LocalClient.cmd_cli`发布到master，获取一个Jodid
   - master接收到命令后，将要执行的命令发送给客户端minion
   - minion从消息总线上接收到要处理的命令，交给`minion._handle_aes`处理
   - `minion._handle_aes`发起一个本地线程调用cmdmod执行ls命令
   - 线程执行完ls后，调用`minion._return_pub`方法，将执行结果通过消息总线返回给master
   - master接收到客户端返回的结果，调用`master._handle_aes`方法，将结果写入文件
   - `salt.client.LocalClient.cmd_cli`通过轮询获取Job执行结果，将结果输出到终端

## 安装配置
### 安装步骤
1. 安装本地yum源和配置epel源：
```bash
rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install epel-release 
yum clean all 
yum makecache
```

2. 安装Salt组件：
```bash
# 安装salt-master端（服务端）
yum -y install salt-master
# 安装salt-minion端（客户端）
yum -y install salt-minion
```

3. 配置minion：
   - 修改配置文件：`vim /etc/salt/minion`
   - 设置参数：
     - `master`：master的IP或者域名
     - `id`：minion的名称（唯一性）

4. 启动服务：
```bash
service salt-master start
service salt-minion start
```

5. 密钥管理（在master端执行）：
```bash
# 查看所有minion_key
salt-key -L
# 接受指定key
salt-key -a 'key-name'
# 接受所有key
salt-key -A
```

### 基本使用
```bash
# 查看在线minion
salt '*' test.ping
# 在所有Minion上安装ftp
salt '*' pkg.install ftp
# 在所有机器上执行uptime命令
salt '*' cmd.run 'uptime'
```

## 常用命令
1. `salt`：执行salt的执行模块，通常在master端运行
2. `salt-run`：执行runner，通常在master端执行
   - 例如：`salt-run manged.up` 查看所有在线minion
3. `salt-key`：密钥管理，通常在master端执行
4. `salt-call`：通常在minion上执行，minion自己执行可执行模块
5. `salt-cp`：分发文件到minion上（不支持目录分发），通常在master运行
   - 例如：`salt-cp '*' testfile.html /tmp`