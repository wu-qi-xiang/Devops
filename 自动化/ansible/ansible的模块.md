# Ansible模块使用指南

## 1. Ad-hoc命令
常用参数：
- `-f`：并发线程
- `-l`：指定运行的主机
- `-T`：超时时间
- `-B`：后台执行
- `-P`：任务进度

### 基本语法
```bash
ansible <host-pattern> [-m module_name] [-a args] [options]
```
示例：
```bash
# 使用command模块（默认）
ansible all -m command -a ls
# 指定多个主机组
ansible ip:ip:ip(组:组:组) -a "ls"    # 相当于或，&,!
# 后台运行
ansible all -B time -a "ls"
```

## 2. 常用模块介绍

### 2.1 ping模块
用于测试连通性
```bash
# 测试连通性
ansible all -m ping
# 查看帮助文档
ansible-doc -v ping
```

### 2.2 command模块（默认模块）
用于执行简单命令，不支持 `>` `<` `|` `&` 等特殊字符

参数说明：
- `chdir`：切换目录
- `creates`：判断文件是否存在，不存在则执行命令
- `removes`：判断文件是否存在，存在则执行命令

示例：
```bash
# 切换目录并执行命令
ansible web -m command -a "chdir=/tmp pwd"
# 使用creates参数
ansible web -m command -a "creates=/etc/hosts date"
# 使用removes参数
ansible web -m command -a "removes=/etc/hosts date"
```

### 2.3 shell模块
用于执行shell命令，支持特殊字符
```bash
# 执行shell脚本
ansible web -m shell -a "/bin/sh /server/scripts/ssh-key.sh"
# 修改权限
ansible wx -m shell -a "chmod 755 /home/zyw"
```

### 2.4 script模块
在远程主机上执行本地脚本
```bash
ansible all -m script -a "/server/scripts/free.sh"
```
注：使用script模块不需要将脚本传输到远程节点，也不需要授权。

### 2.5 copy模块
用于文件传输，`src`和`content`参数不能同时使用
```bash
# 传输文件并设置权限
ansible web -m copy -a "src=/etc/hosts dest=/tmp/ mode=0600 owner=root group=root"
# 复制远端文件
ansible web -m copy -a "src=/server/scripts/ssh-key.sh dest=/tmp/ remote_src=true"
# 创建文件并写入内容
ansible web -m copy -a "content=okay686.cn dest=/tmp/okay686.txt"
```

### 2.6 file模块
用于设置文件属性
```bash
# 创建目录
ansible web -m file -a "dest=/tmp/okay686_dir state=directory"
# 创建文件
ansible web -m file -a "dest=/tmp/okay686_file state=touch"
# 创建软链接
ansible web -m file -a "src=/tmp/okay686_file dest=/tmp/okay686_file_link state=link"
# 删除文件
ansible web -m file -a "dest=/tmp/okay686_dir state=absent"
```

### 2.7 cron模块
管理定时任务，`disabled=yes|no`用于注释或取消注释
```bash
# 添加定时任务
ansible web -m cron -a "minute=0 hour=0 job='/bin/sh /server/scripts/hostname.sh &>/dev/null' name=okay686"
# 删除定时任务
ansible web -m cron -a "name=okay686 state=absent"
```

### 2.8 yum模块
包管理
```bash
# 安装软件包
ansible web -m yum -a "name=nmap state=installed"
```

### 2.9 service模块
服务管理
```bash
# 重启服务
ansible web -m service -a "name=crond state=restarted"
```

## 3. 其他常用模块
- `get_url`：相当于wget命令
- `selinux`：SELinux管理
- `hostname`：修改主机名
- `setup`：收集系统信息
```bash
# 收集系统信息
ansible test -m setup
# 后台执行命令
ansible test -B 3600 -a "ls"
```