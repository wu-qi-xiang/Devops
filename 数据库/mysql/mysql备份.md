# MySQL数据库备份与恢复指南

## 数据备份方式

主要包括以下几种备份方式：
- mydumper多线程备份
- xtrabackup备份（适用于大量数据）

### 1. 使用mysqldump进行备份

```bash
# 备份单个数据库
mysqldump -u user -h localhost -p password dbname > bak_file.sql

# 备份多个数据库
mysqldump -u user -h localhost -p password --database dbname1 dbname2 dbname3 > bak_file.sql

# 备份所有数据库
mysqldump -u user -h localhost -p password --all-databases > bak_file.sql
```

### 2. 数据目录备份
直接将MySQL的数据目录进行备份，路径使用用户自定义的data路径。

### 3. 使用mysqlhotcopy工具备份
```bash
mysqlhotcopy -u user -p password dbname /date/bak
```

### 4. 二进制日志备份
1. 在my.cnf文件的mysql模块中启用log-bin二进制日志文件
2. 将日志文件转换为SQL语句：
```bash
# 转换为SQL文件
mysqlbinlog -d database_name mysql-bin.000014 > bin.sql

# 根据节点恢复数据
/usr/local/mysql/bin/mysql -uroot -p123456 -v database_name < bin.sql
```

3. 按时间范围恢复数据：
```bash
# 导出指定时间段的数据为SQL文件
mysqlbinlog --start-datetime="2014-11-07 04:01:00" --stop-datetime="2014-11-07 11:59:00" /data/mysql/data/mysql-bin.000020 > /home/madong/aa.sql

# 恢复数据
mysql> source /home/madong/aa.sql
```

## 数据恢复

### 1. 使用SQL文件恢复
```bash
mysql -u user -p password dbname < bak_file.sql
```

### 2. 直接复制恢复
直接复制到数据库的目录（注意：此方法对InnoDB引擎的表数据不可用）

### 3. 使用mysqlhotcopy快速恢复
如果数据库已存在，需要先删除已存在的数据库再操作：
```bash
# 设置正确的权限
chown -R mysql.mysql /data/dbname

# 复制备份数据
cp /date/bak /data/dbname
```

## 数据库迁移

### 1. 相同版本MySQL之间的迁移
```bash
mysqldump -h localhost1 -uuser -ppassword dbname | mysql -h localhost2 -uuser -ppassword dbname
```

### 2. 不同数据库之间的迁移
使用MySQL官方提供的迁移工具。
