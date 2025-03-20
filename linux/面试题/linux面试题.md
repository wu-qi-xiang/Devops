# Linux面试题总结

## 推荐面试网站
- https://www.cuiliangblog.cn/blog/show-125/
- www.i4t.com
- https://abcops.cn/

## Shell编程
### 基础示例
```bash
# 循环写入数字到文件
for i in `seq 100`; do echo $i >> 1.txt; sleep 1; done

# seq=sequence序列，seq -s 指定分隔符
```

## 常见面试题
### 1. 文件操作
#### 1.1 取文件1.txt中的20到30行显示出来
```bash
# 方法1：使用head和tail组合
head -30 1.txt | tail -11

# 方法2：使用sed
sed -n '20,30p' 1.txt

# 方法3：使用awk
awk 'NR>19 && NR<31' 1.txt  # NR表示行号

# 方法4：使用grep
grep 20 -A 10 1.txt  # -A(after)：显示匹配行及后10行
grep 25 -C 5 1.txt   # -C(center)：显示匹配行及前后5行
grep 30 -B 10 1.txt  # -B(before)：显示匹配行及前10行
```

#### 1.2 替换/usr目录下的.sh结尾的所有文件内容
```bash
# 方法1：使用find和xargs
find /usr/ -type f -name "*.sh" | xargs sed -i 's#原字符#新替换的字符#g'

# 方法2：使用find和命令替换
sed -i 's#原字符#新替换的字符#g' `find /usr/ -type f -name "*.sh"`
```

#### 1.3 显示文件的行号
```bash
cat -n 文件        # 显示所有行号
nl 文件           # 不显示空行的行号
grep -n . 文件    # 显示所有行号
awk '{print NR,$0}' # 显示行号和内容
sed = 文件 | sed 'N;s/\n//' # 显示行号
less -N          # 显示行号
```

### 2. 系统管理
#### 2.1 设置3级别开机自启动
```bash
# 方法1：使用chkconfig
chkconfig --list
chkconfig --level 3 服务名 on
chkconfig --levels 345 服务名 on

# 方法2：编辑rc.local文件
# 开机会自动加载/etc/rc.local文件

# 方法3：使用软链接
/etc/init.d/服务名
/etc/rc.d/rc3.d/软链接

# 批量设置开机启动
chkconfig --list | awk '{print "chkconfig " $1 " on"}' | bash

# 注意：启动脚本不支持chkconfig时，需添加：
# chkconfig: 2345 64 36
```

#### 2.2 软硬链接的区别
- **硬链接**：
  - 2个文件名指向同一个索引节点(inode)
  - 不能链接文件夹

- **软链接**：
  - 命令：`ln -s myfile soft`
  - myfile的存储保存着soft文件的绝对路径
  - 链接关系：myfile --> soft --> 存储

#### 2.3 登录时出现-bash-4.2$
- **原因**：用户家目录的.bash*隐藏文件被删除
- **解决方案**：
  ```bash
  # 将/etc/skel/下的.bash*文件拷贝到用户家目录
  cp /etc/skel/.bash* .
  ```

### 3. 用户管理
#### 3.1 批量创建用户脚本
```bash
#!/bin/bash
for n in `seq 20`
do
    user="user$n"
    passwd=`echo $RANDOM|md5sum|cut -c 1-5`
    useradd $user
    echo "$user$passwd" | passwd --stdin $user
    echo "$user--$passwd" >> userinfo.txt
done
```

### 4. 系统配置
#### 4.1 开机自启动配置
- 将程序启动命令放入以下文件：
  - `/etc/rc.local`
  - `/etc/profile`
- 使用系统命令：
  - `chkconfig 服务名 on`
  - `systemctl enable 服务名`
- 指定用户开机自启动：
  ```bash
  su username -c "启动脚本"
  ```

#### 4.2 AWK高级用法
```bash
# 定义passwd中第5个冒号为分隔符
sed "s/:/@#%/5" /etc/passwd | awk -F '@#%' '{print $2}'
```

### 5. 故障排查
#### 5.1 MySQL root密码丢失处理
1. 停止mysql服务
2. 使用跳过权限表启动：
   ```bash
   /usr/local/mysql/bin/mysqld --skip-grant-tables
   ```
3. 无密码登录：`mysql -u root`
4. 修改密码并刷新权限：`flush privileges`
5. 重启mysql服务

#### 5.2 系统监控命令
```bash
# 查看系统每个IP的连接数
netstat -n | awk '/^tcp/{print $5}' | awk -F":" '{print $1}' | uniq -c | sort -nr

# 查看nginx访问日志中的IP统计
cat /usr/local/nginx/logs/access.log | awk '{print $1}' | uniq -c | sort -nr
```

#### 5.3 系统管理命令
```bash
# 查看二进制文件
hexdump -C 文件名

# 查看文件权限（数字形式）
stat /etc/inittab | awk -F "[(/]" 'NR==4{print $2}'
stat -c %a /etc/inittab
ll /etc/passwd | cut -c 1-9 | tr rwx- 4210 | awk -F "" '{print $1+$2+$3 $4+$5+$6 $7+$8+$9}'

# 显示3天前的日期
date "+%F" -d "3 day ago"
date "+%F" -d "-3 day"

# 查看系统运行时间
uptime
top
```

#### 5.4 Nginx配置
```bash
# 记录客户端真实IP而非代理IP
proxy_set_header X-Real-IP $remote_addr
```

#### 5.5 磁盘空间问题
当`du -sch`计算空间和`df -h`查看的空间大小相差较大：
- **原因**：文件被删除后，程序未释放文件句柄
- **排查**：
  ```bash
  lsof | grep delete  # 查看被删除文件占用的进程
  ```

#### 5.6 文件校验
```bash
# 确认复制文件的一致性
md5sum file

# 查找进程启动目录
ls -l /proc/<pid>/cwd
ls -l /proc/<pid>/exe
```

#### 5.7 网站访问慢问题排查
1. **网络连通性检查**
   ```bash
   ping 域名
   tracert -d 域名
   ```
   - ping通且丢包：服务宕机或过载
   - ping通不丢包：带宽不稳定
   - ping不通但能ping通百度：服务问题

2. **服务器检查**
   ```bash
   telnet 域名
   nmap 域名
   curl 域名
   wget 域名
   ```
   - 检查防火墙
   - 检查服务器负载（连接数、CPU、IO）

3. **带宽检查**
   ```bash
   sar -n DEV 1 2  # 查看流量监控
   ```

4. **数据库检查**
   ```bash
   show processlist  # 查看慢查询
   show variables like 'long%'
   set long_query_time=1
   show variables like 'slow%'
   set global slow_query_log='ON'
   ```

5. **存储检查**
   - 检查NFS、MFS负载
   - 检查磁盘IO

#### 5.8 Nginx内外网访问问题
```bash
ping ip          # 检查网络连通性
telnet ip+端口    # 检查防火墙
sar -n DEV 1 2   # 检查流量
```

### 6. 网络协议
#### 6.1 TCP连接
1. **长连接与短连接**
   - **TCP长连接**：发包完毕后保持连接（Keepalive）
   - **TCP短连接**：数据包发送完成后断开连接
   - **HTTP1.1**：默认长连接，支持keep-alive

2. **三次握手**
   目的：确认双方收发能力，指定ISN（Init Sequence Number）
   - **第一次握手**：客户端发SYN，服务器确认对方发送正常
   - **第二次握手**：服务器发SYN+ACK，双方确认各自收发正常
   - **第三次握手**：客户端发ACK，完成连接建立

3. **四次挥手**
   目的：关闭双方的发送和接收
   - **第一次挥手**：客户端发FIN（FIN_WAIT1状态）
   - **第二次挥手**：服务端发ACK（CLOSE_WAIT状态）
   - **第三次挥手**：服务端发FIN（LAST_ACK状态）
   - **第四次挥手**：客户端发ACK（TIME_WAIT状态）

### 7. Linux启动流程
#### 7.1 详细启动流程
1. 加载BIOS（硬件信息、自检、启动顺序）
2. 读取MBR（引导扇区）
3. Boot Loader（GRUB引导）
4. 加载kernel
5. 设定inittab运行级别
6. 执行/etc/rc.d/rc.sysinit
   - 设置path
   - 配置网络
   - 挂载swap分区
   - 配置proc
   - 加载系统函数
7. 加载内核模块
8. 启动运行级别
9. 执行/etc/rc.d/rc.local
10. 执行/bin/login

#### 7.2 简化流程
1. BIOS引导
2. 启动GRUB
3. 核心初始化
4. 载入init程序
5. init初始化
6. 读取inittab数据
7. 设定启动级别
8. 系统运行