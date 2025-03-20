# 实时同步备份方案

## 1. inotify + rsync + 脚本方案

### 安装inotify工具
```bash
yum install inotify-tools
```

### inotify工具介绍
inotify-tools包含两个主要工具：
- `inotifywait`：用于监控文件或目录的变化
- `inotifywatch`：用于统计文件系统访问的次数

### inotifywait使用示例
```bash
inotifywait -mrq --format '%T--%w%f---%e' -e close_write,delete,create /wuqixiang/
```

#### 格式参数说明
- `%w`：表示发生事件的目录
- `%f`：表示发生事件的文件
- `%e`：表示发生的事件
- `%Xe`：事件以"X"分隔
- `%T`：使用由--timefmt定义的时间格式

### inotify系统参数
参数位置：`/proc/sys/fs/inotify`
- `max_user_instances`：每个用户能启动的inotify最大实例数
- `max_user_watches`：每个实例最大的监控数（inode数量）
- `max_queued_events`：队列中最大的事件数

## 2. sersync + rsync方案（守护进程同步）

### 安装配置
```bash
# 创建必要目录
mkdir /usr/local/sersync
mkdir /usr/local/sersync/conf
mkdir /usr/local/sersync/logs
mkdir /usr/local/sersync/bin

# 移动文件到指定目录
mv GNU-Linux-x86/sersync2 /usr/local/sersync/bin/
mv GNU-Linux-x86/confxml.xml /usr/local/sersync/conf

# 备份配置文件
cd /usr/local/sersync/conf
cp confxml.xml confxml.xml.bak
```

### 启动服务
```bash
sersync2 -d -r -o /usr/local/sersync/conf/confxml.xml
```

### 测试同步
```bash
cd /data/bakup/
for f in `seq 10`; do touch $f; done
ll /data/bakup/
```

### 配置文件示例
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <!-- 设置本地IP和端口 -->
    <host hostip="localhost" port="8008"></host>
    
    <!-- 开启DEBUG模式 -->
    <debug start="false"/>
    
    <!-- 开启xfs文件系统 -->
    <fileSystem xfs="false"/>
    
    <!-- 同步时忽略推送的文件(正则表达式),默认关闭 -->
    <filter start="false">
        <exclude expression="(.*).svn"></exclude>
        <exclude expression="(.*).gz"></exclude>
        <exclude expression="^info/*"></exclude>
        <exclude expression="^static/*"></exclude>
    </filter>
    
    <!-- 设置要监控的事件 -->
    <inotify>
        <delete start="false"/>
        <createFolder start="true"/>
        <createFile start="false"/>
        <closeWrite start="true"/>
        <moveFrom start="true"/>
        <moveTo start="true"/>
        <attrib start="false"/>
        <modify start="false"/>
    </inotify>
    
    <sersync>
        <!-- 本地监视目录路径 -->
        <localpath watch="/data/bakup/">
            <!-- 定义同步Server ip和模块 -->
            <remote ip="192.168.0.132" name="bakup"/>
            <!--<remote ip="192.168.8.39" name="tongbu"/>-->
            <!--<remote ip="192.168.8.40" name="tongbu"/>-->
        </localpath>
        
        <rsync>
            <!-- rsync指令参数 -->
            <commonParams params="-artuz"/>
            
            <!-- rsync同步认证 -->
            <auth start="true" users="rsync_bakup" passwordfile="/etc/rsyncd.password"/>
            
            <!-- 设置rsync远程服务端口 -->
            <userDefinedPort start="false" port="874"/><!-- port=874 -->
            
            <!-- 设置超时时间 -->
            <timeout start="true" time="100"/><!-- timeout=100 -->
            
            <!-- 设置rsync+ssh加密传输模式 -->
            <ssh start="false"/>
        </rsync>
        
        <!-- sersync传输失败日志配置 -->
        <failLog path="/usr/local/sersync/logs/rsync_fail_log.sh" timeToExecute="60"/>
        
        <!-- 设置rsync定时传输 -->
        <crontab start="false" schedule="600">
            <crontabfilter start="false">
                <exclude expression="*.php"></exclude>
                <exclude expression="info/*"></exclude>
            </crontabfilter>
        </crontab>
        
        <!-- 设置sersync传输后调用插件脚本 -->
        <plugin start="false" name="command"/>
    </sersync>
    
    <!-- 插件配置示例 -->
    <plugin name="command">
        <param prefix="/bin/sh" suffix="" ignoreError="true"/>
        <filter start="false">
            <include expression="(.*).php"/>
            <include expression="(.*).sh"/>
        </filter>
    </plugin>
    
    <plugin name="socket">
        <localpath watch="/opt/tongbu">
            <deshost ip="192.168.138.20" port="8009"/>
        </localpath>
    </plugin>
    
    <plugin name="refreshCDN">
        <localpath watch="/data0/htdocs/cms.xoyo.com/site/">
            <cdninfo domainname="ccms.chinacache.com" port="80" username="xxxx" passwd="xxxx"/>
            <sendurl base="http://pic.xoyo.com/cms"/>
            <regexurl regex="false" match="cms.xoyo.com/site([/a-zA-Z0-9]*).xoyo.com/images"/>
        </localpath>
    </plugin>
</head>
