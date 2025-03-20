# MySQL基础指南

## 安装MySQL

### 二进制安装
二进制MySQL下载地址：
```
http://downloads.mysql.com/archives/mysql-5.6/mysql-5.6.10-linux-glibc2.5-x86_64.tar.gz
```

### 源码编译安装

#### 准备工作
```bash
# 新增用户
useradd mysql -g mysql

# 新建数据库数据文件目录
mkdir -p /data/mysql

# 安装编译源码所需的工具和库(需要联网)
yum -y install wget gcc-c++ ncurses-devel cmake make perl
```

#### 编译安装步骤
```bash
# 进入源码压缩包下载目录
cd /usr/local/src

# 解压缩源码包
tar -zxvf mysql-5.6.11.tar.gz

# 进入解压缩源码目录
mv mysql-5.6.11 /usr/local/mysql
cd /usr/local/mysql
```

#### 配置编译选项
从MySQL 5.5起，源码安装开始使用cmake。执行源码编译配置脚本：

```bash
cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/mysql \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306
```

> 注：具体编译参数参考：http://dev.mysql.com/doc/refman/5.5/en/source-configuration-options.html

#### 编译和安装
```bash
# 编译
make

# 安装
make install

# 清除安装临时文件
make clean

# 修改目录拥有者
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /data/mysql
```

#### 初始化配置
```bash
# 进入安装路径
cd /usr/local/mysql

# 执行初始化配置脚本，创建系统自带的数据库和表
scripts/mysql_install_db --user=mysql --datadir=/data/mysql
```

初始化脚本在 `/usr/local/mysql/my.cnf` 生成了配置文件。需要更改该配置文件的所有者：
```bash
chown -R mysql:mysql /data/mysql
```

> 注意：在启动MySQL服务时，会按照一定次序搜索my.cnf，先在/etc目录下找，找不到则会搜索"$basedir/my.cnf"。在CentOS 6.4版操作系统的最小安装完成后，在/etc目录下会存在一个my.cnf，需要将此文件更名为其他的名字，如：/etc/my.cnf.bak，否则，该文件会干扰源码安装的MySQL的正确配置，造成无法启动。

#### 配置服务
```bash
# 复制服务启动脚本
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld

# 复制配置文件
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

# 启动MySQL服务
service mysqld start

# 设置开机自动启动服务
chkconfig mysqld on
```

## MySQL用户管理

### 修改root密码
有多种方式可以修改root密码：

1. 使用授权命令：
```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

2. 直接更新user表：
```sql
update user set Password = password('123456') where User='root';
flush privileges;
```

### 用户管理命令

#### 创建用户
```sql
-- 创建本地用户
create user username@localhost identified by 'password';

-- 创建用户并授权
grant all on *.* to username@localhost identified by 'password';

-- 授予外网登录权限
grant all privileges on *.* to username@'%' identified by 'password';

-- 授予权限并且可以授权
grant all privileges on *.* to username@'hostname' identified by 'password' with grant option;
```

#### 权限管理
```sql
-- 授予权限
GRANT 权限列表 ON 数据库名.表名 TO 用户名@来源地址 [ IDENTIFIED BY '密码' ]

-- 查看权限
SHOW GRANTS FOR 用户名@域名或IP

-- 撤销权限
REVOKE 权限列表 ON 数据库名.表名 FROM 用户名@域名或IP
```

## 数据库操作

### 基本操作
```sql
-- 显示数据库
SHOW DATABASES;

-- 显示表
SHOW TABLES;

-- 显示表结构
DESCRIBE [数据库名.]表名;

-- 创建数据库
CREATE DATABASE 数据库名;

-- 创建表
CREATE TABLE 表名 (
    字段名 类型 [约束],
    ...
);

-- 修改表名
ALTER TABLE 表名 RENAME TO 新表名;

-- 删除表
DROP TABLE [数据库名.]表名;

-- 删除数据库
DROP DATABASE 数据库名;
```

### 数据操作
```sql
-- 插入数据
INSERT INTO 表名(字段1,字段2,...) VALUES(值1,值2,...);

-- 查询数据
SELECT 字段1,字段2,... FROM 表名 WHERE 条件;

-- 更新数据
UPDATE 表名 SET 字段1=值1,字段2=值2,... WHERE 条件;

-- 删除数据
DELETE FROM 表名 WHERE 条件;
```

## 数据库备份与恢复

### 备份数据库
```bash
# 备份语法
mysqldump -u [用户名] -p [密码] [options] [数据库名] [表名] > /备份路径/备份文件名

# 备份整个数据库
mysqldump -u root -p mydb > mysql-mydb.sql

# 备份指定表
mysqldump -u root -p mysql host user > mysql.host-user.sql

# 备份所有数据库
mysqldump -u root -p --all-databases > mysql-all.sql
```

### 恢复数据库
```bash
mysql -uroot -p密码 [数据库名] < /备份路径/备份文件名
```

### 数据库同步示例
```bash
# 导出数据
mysqldump -h source.host.com -uuser -ppassword --databases db_name > backup.sql

# 处理导出文件
sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' backup.sql > processed.sql
awk '{ if (index($0,"GTID_PURGED")) { getline; while (length($0) > 0) { getline; } } else { print $0 } }' processed.sql | grep -iv 'set @@' > final.sql

# 导入数据
mysql -h target.host.com -uuser -ppassword target_db < final.sql
```