# FTP服务配置指南

## 简介
FTP（文件传输协议）是一种基于C/S模式的协议，通过该协议FTP客户端与服务端可以实现文件共享、上传和下载。

## FTP传输模式
- 主动模式：以20端口传输数据（默认模式）
- 被动模式：以21端口传输数据

## vsftpd服务器
vsftpd是Linux发行版中最主流的FTP服务器程序，支持以下功能：
- 匿名用户的上传和下载
- 账号权限管理
- 虚拟用户的权限管理

## 安装配置
### 安装步骤
```bash
# 检查是否已安装
rpm -qa | grep vsftpd

# 安装软件包
yum -y install vsftpd*

# 查看安装文件
rpm -ql vsftpd | more

# 启动服务
systemctl restart vsftpd
```

### 访问方式
- Windows访问地址：`ftp://192.168.20.235`
- 默认文档路径：`/var/ftp/pub`

注意：写入`/etc/vsftpd/user_list`文件中的用户不能访问FTP服务器，未写入的用户可以访问（默认配置）。

## 配置文件详解
配置文件路径：`/etc/vsftpd/vsftpd.conf`

### 基础配置
```ini
local_root=/home/           # 登录路径
anonymous_enable=NO         # 不允许匿名登录
write_enable=YES            # 表示可写
local_umask=002            # 配mask的值
anon_upload_enable=NO       # 是否允许匿名账号上传文件
anon_mkdir_write_enable=NO  # 是否允许匿名账号可写
```

### 超时设置
```ini
idle_session_timeout=6000   # 客户端空闲超时时间
data_connection_timeout=600 # 数据连接超时时间
connect_timeout=60         # 连接超时时间（1分钟）
```

### 连接限制
```ini
max_clients=10             # 最大并发连接数
max_per_ip=5               # 每个IP最大连接数
local_max_rate=5000        # 本地用户传输率（50K）
```

### 其他设置
```ini
ftpd_banner=welcome to ftp service  # 欢迎信息
accept_timeout=60                   # 建立连接超时时间
passv_min_port=端口号              # 被动模式最小端口
passv_max_port=端口号              # 被动模式最大端口
listen_address=IP地址              # 监听地址
listen_port=21                     # 监听端口号
```