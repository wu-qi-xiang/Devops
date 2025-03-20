# Linux基础知识

## 1. Linux的文件系统

根文件系统(rootfs)使用ext4（CentOS 6）或xfs（CentOS 7）文件系统。主要目录结构：

- `/boot`：引导文件存放目录，包含内核文件(vmlinuz)和引导加载器(bootloader)
- `/bin`：基本命令目录，系统启动程序
- `/sbin`：管理类基本命令，系统启动程序
- `/lib`：基本共享库文件，以及内核模块文件(`/lib/modules`)
- `/lib64`：64位系统上的辅助共享文件存放位置
- `/etc`：配置文件目录(纯文本文件)
- `/home/username`：普通用户家目录
- `/root`：管理员的家目录
- `/media`：便携式移动设备挂载点
- `/mnt`：临时文件的挂载点
- `/dev`：设备文件及特殊文件的存储位置（b:块文件，c:字符文件）
- `/opt`：第三方应用程序的安装位置
- `/srv`：系统上运行的服务用到的数据
- `/tmp`：临时文件存放位置
- `/usr`：独立的文件系统
- `/var`：variable data files
- `/proc`：用于输出内核与进程信息相关的虚拟文件系统

## 2. Linux的文件类型

- `-`(f)：普通文件
- `d`：目录文件
- `c`：字符设备
- `l`：链接文件
- `p`：管道文件
- `s`：套接字文件

### 常用快捷键

- `Ctrl + L`：清屏
- `Ctrl + A`：跳转到命令开始处
- `Ctrl + E`：跳转到命令结尾处
- `Ctrl + U`：删除命令行首部至光标处的所有内容
- `Ctrl + K`：删除光标至行尾部的所有内容

## 3. 标准输入输出

- 标准输入：keyboard (0)
- 标准输出：monitor (1)
- 标准错误输出：monitor (2)

### I/O重定向

#### 输出重定向
```bash
# 覆盖重定向
1> 或 > 
2>  # 错误输出流覆盖重定向

# 追加重定向
>> 
2>>  # 错误输出流追加重定向

# 组合重定向
echo "content" &> file.txt  # 等同于 echo "content" 1>file.txt 2>&1
```

注：使用`set -C`可禁止将内容覆盖至已有文件中，使用`set +C`开启覆盖功能。

#### 输入重定向
```bash
< 或 0<  # 输入重定向
<<       # here documentation
```

## 4. 管道

使用格式：`command1 | command2 | command3`

`tee`命令：一次输入，两次输出（界面和文件）

## 5. 用户和组配置

### 配置文件

- `/etc/passwd`：用户及其基础信息（名称，UID，组ID）
- `/etc/group`：组及其基本信息
- `/etc/shadow`：用户密码及其基本属性（使用单向加密：md5sum，sha512sum）
- `/etc/gshadow`：组密码及其基本属性

加密算法：
- MD5：message digest，128bits
- SHA1：secure hash algorithm，160bits
- 其他：sha224，sha256，sha348，sha512

### 用户和组管理命令

#### 用户创建
```bash
useradd -u UID  # UID范围定义在/etc/login.defs
useradd -g GID  # 指定用户组名
```

#### 组创建
```bash
groupadd -g GID  # 指定组ID
groupadd -r      # 创建系统组
```

#### 查看用户信息
```bash
id -u  # 查看UID
id -g  # 查看GID
id -G  # 查看Groups
id -n  # 查看Name
```

#### 切换用户
```bash
su username    # 非登录式切换，不会读取目标用户配置文件
su - username  # 登录式切换，会读取目标用户配置文件
```

## 6. 权限管理

### 基本权限

- 属主(owner)：u
  - r：readable（查看权限）
  - w：writable（修改权限）
  - x：executable（执行权限）
- 属组(group)：g
- 其他(other)：o

注意：
- 目录没有w权限，无法在目录下新增文件
- 目录没有x权限，无法进入目录

### 权限修改命令

```bash
# 修改权限
chmod -R 权限 目录  # -R递归修改目录及其下文件权限

# 修改属主
chown -R root:root 文件名/目录

# 修改属组
chgrp
```

创建文件的默认权限：
- 文件：666-umask
- 目录：777-umask

## 7. Bash配置环境

### Profile类配置

为交互式登录的shell提供配置（通过账号密码登录或使用`su - username`切换的用户）

加载顺序：
```
/etc/profile -> /etc/profile.d/*.sh -> ~/.bashrc -> /etc/bashrc
```

- 全局配置：
  - `/etc/profile`
  - `/etc/profile.d/*.sh`
- 个人配置：
  - `~/.bash_profile`

主要功能：
1. 定义环境变量
2. 运行脚本或命令

### Bashrc类配置

为非交互式登录的shell提供配置（使用su切换用户、图形界面终端、执行脚本）

加载顺序：
```
~/.bashrc -> /etc/bashrc -> /etc/profile.d/*.sh
```

- 全局配置：`/etc/bashrc`
- 个人配置：`~/.bashrc`

主要功能：
1. 定义命令别名
2. 定义本地变量

## 8. 测试命令

### test命令
- `-n`：字符串长度不为0
- `-z`：字符串长度为0

### 数值测试
- `-gt`：大于
- `-ge`：大于等于
- `-ne`：不等于
- `-lt`：小于
- `-le`：小于等于
- `-eq`：等于

### 字符串测试
- `==`：等于
- `>=`：大于等于
- `!=`：不等于
- `<=`：小于等于
- `-z`：长度为零
- `-n`：长度不为零

### 算术运算
- `let`
- `$[]`
- `$(())`
- `expr`

## 9. Vim编辑器使用

### 基本操作

打开文件并定位：
```bash
vim +/PATTERN /path/to/somefile  # 打开文件后定位到第一次匹配PATTERN的行
```

#### 翻屏操作
- `Ctrl + f`：向下翻一屏
- `Ctrl + b`：向上翻一屏
- `Ctrl + d`：向下翻半屏
- `Ctrl + u`：向上翻半屏

#### 编辑模式切换
- `i`：在光标处插入
- `a`：在光标后插入
- `o`：在当前行下方新开一行
- `O`：在当前行上方新开一行

#### 光标移动
- `^`或`Shift + 6`：移动到行首
- `$`或`Shift + 4`：移动到行尾
- `w/W`：移动到下个单词开头
- `b/B`：反向移动到单词开头
- `e/E`：移动到下个单词结尾

#### 查找和替换
- `/PATTERN`：向后查找
- `?PATTERN`：向前查找
- `n`：下一个匹配
- `N`：上一个匹配
- `:%s/old/new/g`：全文替换

#### 复制粘贴
- `yy`：复制当前行
- `dd`：删除当前行
- `p`：粘贴

#### 多文件操作
```bash
vim -o file1 file2  # 水平分割
vim -O file1 file2  # 垂直分割
```

窗口切换：`Ctrl + w + 方向键`

### Vim配置

配置文件位置：
- 全局：`/etc/vimrc`
- 个人：`~/.vimrc`

常用配置：
```vim
set number      " 显示行号
set sm          " 括号匹配
set ai          " 自动缩进
syntax on       " 语法高亮
set hlsearch    " 高亮搜索
```

## 10. 文件查找

### 命令查找
- `which`：查询二进制文件
- `whereis -b`：等同于which

### 文件查找方式

#### locate命令（非实时查找）
- 查询数据库，速度快
- 支持模糊查询
- 需要定期更新数据库：`updatedb`

#### find命令（实时查找）

基本语法：`find [查找路径] [查询条件] [动作处理]`

##### 查找条件
1. 按文件名：
   - `-name filename`
   - `-iname filename`（不区分大小写）

2. 按属主/属组：
   - `-user username`
   - `-group groupname`

3. 按文件类型：`-type [f|d|l|s|b|c|p]`

4. 组合条件：
   - 与：`-a`
   - 或：`-o`
   - 非：`-not`或`!`

5. 按文件大小：`-size [+|-]单位`
   - 单位：k、M、G
   - `+`：大于
   - `-`：小于

6. 按时间查找：
   - 以天为单位：`-mtime [+|-]`
   - 以分钟为单位：`-amin [+|-]`

7. 按权限查找：`-perm [+|-]`

##### 处理动作
- `-print`：显示到屏幕（默认）
- `-ls`：对查找的文件执行`ls -l`命令
- `-delete`：删除查找到的文件
- `-fls /path/to/somefile`：将查找结果保存到指定文件

## 11. Shell编程基础

### 引号使用
- 单引号：所有字符原样输出
- 双引号：对`$`、反引号和`\`保留特殊含义
- 反引号：执行系统命令并返回结果

### 脚本调试
```bash
sh -xv 文件名  # 调试脚本
sh -n 文件名   # 检查语法问题
```

## 12. 系统服务管理

### systemctl命令（CentOS 7+）
```bash
# 服务控制
systemctl start/stop/restart name.service

# 服务状态查看
systemctl is-active name.service
systemctl list-units --type service
systemctl list-units --type service --all

# 开机自启动设置
systemctl enable name.service
systemctl disable name.service

# 查看服务自启动状态
systemctl list-unit-files --type service
```

### service命令（CentOS 6）
```bash
service name start/status/stop
/etc/init.d/服务名 start/status/stop
```

## 13. 网络配置

### 网卡配置

#### 网卡控制命令
```bash
ifup ethN    # 启动网卡
ifdown ethN  # 停止网卡
/etc/init.d/network start  # 启动网络服务
```

#### 网卡配置文件
位置：`/etc/sysconfig/network-scripts/ifcfg-ethN`

主要参数：
```bash
DEVICE=ethN               # 物理设备名
IPADDR=192.168.1.106      # IP