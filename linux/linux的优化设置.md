# Linux系统优化设置

## 网络安全原则
1. 只对外开放所需要的服务，关闭所有不需要的服务。对外提供的服务越少，所面临的外部威胁越小。
2. 将所需的不同服务分布在不同的主机上，这样不仅提高系统的性能，同时便于配置和管理，减小系统的安全风险。

## 系统优化设置

### 1. 关闭SElinux功能
在修改前要先进行备份（这个属于运维守则）：
```bash
cp /etc/selinux/config /etc/selinux/config.oldboy.20150519
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

修改后检查：
```bash
grep =disabled /etc/selinux/config
```

改完后还没生效，永久生效只能重启服务器，也可以临时关闭操作如下：
```bash
getenforce      sestatus           # 检查selinux状态 
setenforce 0  # 临时关闭（permissive）
setenforce 1  # 临时开启（enforcing）
```

SELinux模式说明：
- `enforcing`：强制模式，代表SELinux运作中，且已经正确的开始限制domain/type
- `permissive`：宽容模式：代表SELinux运作中，不过仅会有警告讯息并不会实际限制domain/type的存取。这种模式可以用来作为SELinux的debug之用
- `disabled`：关闭，SELinux并没有实际运作

### 2. 设定系统运行级别为3（文本模式）
```bash
init 3
vim /etc/inittab        # 设置 id 3
```

七种运行级别：
- 运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
- 运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
- 运行级别2：多用户状态(没有网络的NFS)
- 运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
- 运行级别4：系统未使用，保留
- 运行级别5：X11控制台，登陆后进入图形GUI模式
- 运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

### 3. 精简开机系统自启动
使用`chkconfig`命令管理服务，例如：
```bash
chkconfig --level 35 crond on
chkconfig --list|grep -vE "crond|sshd|network|rsyslog|sysstat" |awk '{print "chkconfig "$1" off"}'|bash
```

必要服务说明：
- `sshd`：远程连接linux服务器必须开启
- `rsyslog`：系统日志服务
- `network`：网络服务
- `crond`：计划任务服务
- `sysstat`：系统性能数据收集

### 4. 更改ssh服务器端远程登入配置
```bash
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
vim /etc/ssh/sshd_config
```

重要配置项：
```
Port 2222                    # 修改ssh端口
PermitRootLogin no           # 禁止root登入
PermitEmptyPasswords no      # 禁止空密码登入
UseDNS no                    # 禁用DNS反向解析
GSSAPIAuthentication no      # 加快ssh连接速度
```

SElinux允许的ssh端口配置：
```bash
semanage port -l | grep ssh
semanage port -a -t ssh_port_t -p tcp 2222
semanage port -l | grep ssh    # 确认添加
```

### 5. 通过sudo控制用户权限
```bash
visudo  # 等同于 vi /etc/sudoers
```

配置示例：
```
root    ALL=(ALL)    ALL
alex    ALL=(ALL)    /usr/sbin/useradd,/usr/sbin/userdel  # 用户alex能够使用useradd和userdel命令
```

限制sudo权限组：
```bash
vi /etc/pam.d/su
```
```
auth sufficient /lib/security/pam_rootok.so debug
auth required /lib/security/pam_wheel.so group=isd     # 指定只有属于isd组的才可以使用sudo权限
```

### 6. Linux中文显示设置
```bash
vi /etc/sysconfig/i18n
```

可选配置：
```
LANG="zh_CN.GBK"      # 中文格式的GBK  
LANG="zh_CN.UTF-8"    # utf-8编码（推荐）
LANG="en_US.GBK"      # 英文格式的GBK
LANG="en_US.UTF-8"    # utf-8编码
```

### 7. 历史记录与登入超时设置
```bash
vi /etc/profile
```

添加配置：
```
TIMEOUT=10      # 连接超时时间
HISTSIZE=10     # 命令行的历史记录数
HISTFILESIZE=10 # 历史记录文件的命令数量
```

### 8. 调整系统资源限制
查看当前限制：`ulimit -n`

编辑`/etc/security/limits.conf`：
```
* hard core 0          # 禁止创建core文件
* hard rss 5000        # 除root外，其他用户最多使用5M内存
* hard nproc 20        # 最多进程数限制为20
```

编辑`/etc/pam.d/login`，添加：
```
session required /lib/security/pam_limits.so
```

防止SYN Flood攻击：
```bash
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
```

配置优先级：
`ulimit命令 > /etc/security/*.conf > /etc/sysctl.conf`

### 9. 隐藏Linux版本信息
```bash
cp /etc/issue /etc/issue.bak
echo > /etc/issue  # 清除文件内容
```

### 10. 文件安全策略
```bash
chattr +i /etc/passwd  # 加锁
chattr -i /etc/passwd  # 解锁
lsattr /etc/passwd     # 查看属性
```

### 11. 清除不必要的系统虚拟账号

### 12. 为grub菜单加密
```bash
# 1. 生成md5秘钥
/sbin/grub-md5-crypt

# 2. 修改/etc/grub.conf
# 在splashimage和title之间加入
password --md5 秘钥
```

### 13. 禁止系统被ping
```bash
echo 'net.ipv4.icmp_echo_ignore_all=1' >> /etc/sysctl.conf
```

### 14. 升级关键软件包
```bash
yum -y install openssl openssh bash
```

### 15. 禁止IP源路径路由
```bash
for r in /proc/sys/net/ipv4/conf/*/accept_source_route; do
    echo 0 > $r
done
```

### 16. 防止IP地址欺骗
```bash
vim /etc/host.conf
```
```
order bing, hosts
multi off
nospoof on
```

### 17. 系统补丁安装

### 18. Linux系统安全最小化原则
1. 安装系统最小化，选包最小化，yum安装最小化
2. 开机自启动服务最小化
3. 操作命令最小化，如：使用`rm -f test.txt`而不是`rm -rf test.txt`
4. 登陆用户最小化，尽量不使用root登陆
5. 普通用户授权最小化
6. 系统文件和目录权限设置最小化

### 19. Linux内核优化
- `/proc/sys`目录下面有多数的内核参数
- `/etc/sysctl.conf`文件包含TCP/IP堆栈和虚拟内存系统的高级选项