# Redis基础知识

## 简介
Redis是一个key-value型缓存数据库，运行在内存中，作为MySQL数据库的缓存。

## 数据类型
Redis支持五种数据类型：
- string（字符串）
- hash（哈希）
- list（列表）
- set（集合）
- zset（sorted set：有序集合）

## 安装配置

### 安装依赖
```bash
yum -y install gcc automake autoconf libtool make
```

### 编译安装
1. 解压安装包，进入目录：
```bash
cd /usr/local/redis/
make
```

2. 编译后在 `./src` 目录生成以下主要程序：
- `redis-server`：Redis服务器的daemon启动程序
- `redis-cli`：Redis命令行操作工具（也可以用telnet根据其纯文本协议来操作）
- `redis-benchmark`：Redis性能测试工具，测试Redis在当前系统配置下的读写性能
- `redis-stat`：Redis状态检测工具，可以检测Redis当前状态参数及延迟状况

### 启动服务
1. Redis的daemon模式配置在 `redis.conf` 中
2. 启动服务：
```bash
cd ./src
./redis-server redis.conf
```

## 客户端操作

### 登录连接
- 本地登录：`redis-cli`
- 远程登录：`redis-cli -h host -p port -a password`

### 基础命令（String类型）
```bash
# 设置键和键值
set 键(属性) 键值(值)

# 获取键值
get 键(属性)

# 删除键
del 键(属性)    # 删除成功返回(integer) 1，失败返回(integer) 0

# 判断键的类型
type 键(属性)
```

## Redis主从配置

### 配置说明
- 启动Redis时需要指定配置文件路径，例如：`./src/redis-server ./redis.conf`
- 可以配置LVS的负载均衡+Redis的双机主备+Keepalive的主备热切

### 主从设置
1. 主节点（master）使用默认配置
2. 从节点（slave）配置文件需添加：
```bash
slaveof master-ip port
```

### 状态监控
```bash
./src/redis-cli -h 127.0.0.1 -p 6379 info
```

## 数据持久化
Redis支持将内存数据持久化到磁盘的两种方式：

### RDB模式（默认）
- **实现过程**：Redis使用fork函数复制一份当前进程（父进程）的副本（子进程），父进程继续接受并处理客户端命令，子进程将内存数据写入硬盘临时文件，写入完成后替换旧的RDB文件
- **缺点**：可能会丢失最后一次快照后更改的所有数据

### AOF模式
- **实现过程**：Redis会逐个执行AOF文件中的命令来将硬盘数据载入内存，速度比RDB慢
- **优点**：不会丢失数据

### 混合持久化
Redis支持同时开启RDB和AOF模式：
- **优点**：兼具备份快速和数据安全的特性


