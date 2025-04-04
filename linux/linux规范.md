# Linux系统规范

## 一、系统安装规范

### 1. 系统hostname命名规范
- 生产环境：按照`系统--地区--业务--用途`来规范命名
- 其他环境：按照`系统--环境--用途`来规范命名

### 2. 用户设置规范
- 锁定部分系统默认账号，不允许登录
- 生产系统的主备机的用户和组ID要一致，相同用户的环境变量要一样

### 3. 密码设置规范
- 密码应大于8位，复杂度较高
- 设置密码之后立即更新到密码管理系统

### 4. 主要配置文件备份
- 修改重要配置文件时，需要先根据日期备份，然后再修改

### 5. 关闭不必要的服务和端口
- 使用`netstat -altp`命令查看并关闭不需要的服务和端口

## 二、问题处理规范

### 问题类型
1. 硬件问题：主要由硬件资源引起，比如内存和磁盘故障
2. 系统问题：由于系统参数设置不正确，默认安装程序问题
3. 应用问题：比如应用的内存泄漏，程序存在的BUG等

### 日志查看
当系统出现问题，首先通过查看日志来定位问题：

| 日志文件 | 说明 |
|----------|------|
| `/var/log/message` | 系统的核心日志文件 |
| `/var/log/dmesg` | 记录系统引导时硬件设备和内核模块的初始化信息 |
| `/var/log/boot.log` | 记录系统启动过程中系统服务的初始化信息 |
| `/var/log/secure` | 安全认证信息，用户登录记录 |
| `/var/log/lastlog` | 记录系统所有账户最后一次登录的相关信息（使用`lastlog`命令查看）|
| `/var/log/yum.log` | 记录软件包的安装时间和信息 |

## 三、生产环境规范检查
通过脚本对生产环境进行全面检查，包括：
- 基础硬件信息
- 系统信息
- 安装信息
- 配置信息
- 安全信息