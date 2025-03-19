# Rsync数据同步工具

## 简介
rsync是一个本地或远程数据同步工具，可用于备份和镜像。

## 安装
```bash
yum -y install rsync
```

## 使用方式
### 1. SSH传输方式
需要用户登录远程主机进行传输。

- 本地到远程：
```bash
rsync -aL --progress /usr/local/src/ root@192.168.1.250:/usr/local/src/
```

- 远程到本地：
```bash
rsync -aL --progress root@192.168.1.250:/usr/local/src/ /usr/local/src/
```

### 2. 备份主机模式
备份主机搭建rsync服务端，其他主机可连接下载、上传文件（其他主机不需要安装rsync）

- 下载backup主机文件到本地：
```bash
rsync 参数 [user@]host::src desc
```

- 上传本地文件到backup主机：
```bash
rsync 参数 src [user]@host::desc
```

### 3. 定时备份（crond+rsync）
晚上通过定时脚本把数据备份到备份服务器，需要主机之间配置免密登录。

## 常用参数
- `-a`：归档模式，保持所有属性
- `-r`：传输目录时需要加
- `-v`：打印信息，如文件列表，文件数量
- `-L`：保留软连接
- `--delete`：删除DEST中有，但SRC中没有的文件
- `--exclude=文件`：排除不需要传输的文件，支持通配符
- `--progress`：显示同步过程状态

### 使用示例
```bash
# 复制时带着root目录及以下文件
rsync -a /root /wuxiang/

# 只复制root目录下的文件
rsync -a /root/ /wuxiang/
```

## 服务端配置
### 配置文件
编辑 `/etc/rsyncd.conf`：
```ini
port = 873
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsyncd.lock
address = 192.168.1.250
uid = rsync
gid = rsync
use chroot = no
max connections = 40
timeout = 300

[backup]
path = /backup/
ignore errors
hosts allow = 192.168.1.0/24
auth users = rsync_backup
read only = no
list = false
secrets file = /etc/rsyncd.passwd
```

### 密码配置
```bash
# 创建密码文件
echo "backup:774727549" > /etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd

# 添加虚拟用户
useradd rsync -s /sbin/nologin -M
chown rsync:rsync /usr/local/src/
```

### 启动服务
```bash
rsync --daemon --config=/etc/rsyncd.conf

# 开机自启动
echo "/usr/bin/rsync --daemon --config=/etc/rsyncd.conf" >> /etc/rc.local
```

## 客户端配置
### 免密码配置
```bash
# 创建密码文件
echo "774727549" > /etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd

# 添加虚拟用户
useradd rsync -s /sbin/nologin -M
chown rsync:rsync /usr/local/src/
```

### 使用示例
```bash
rsync -avL --progress /backup/ rsync@192.168.1.250::backup --passwd-file=/etc/rsyncd.passwd
```

## 服务重启
```bash
pkill rsync
rsync --daemon --config=/etc/rsyncd.conf
```