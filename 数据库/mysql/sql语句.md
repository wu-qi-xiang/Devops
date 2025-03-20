# MySQL SQL语句指南

## 一、DDL（数据定义语言）Data Definition Language

1. 创建表：
```sql
CREATE TABLE table_name (字段 数据类型 [是否为空]);
```

2. 修改表：
```sql
-- 添加字段
ALTER TABLE table_name ADD 字段;
-- 删除字段
ALTER TABLE table_name DROP 字段;
-- 修改字段
ALTER TABLE table_name CHANGE 原字段 新字段 数据类型;
ALTER TABLE table_name MODIFY 字段名 修改的类型;
-- 增加主键约束
ALTER TABLE table_name ADD CONSTRAINT ppp PRIMARY KEY (字段id);
```

3. 其他DDL操作：
```sql
-- 删除表
DROP TABLE table_name;
-- 清空表
TRUNCATE TABLE table_name;
-- 注释表
COMMENT ON TABLE table_name IS "注释内容";
-- 重命名表
RENAME TABLE stdent TO student;
```

## 二、DML（数据操作语言）Data Manipulation Language

1. 查询数据：
```sql
SELECT * FROM table_name;
```

2. 插入数据：
```sql
INSERT INTO table_name (字段1, 字段2, ...) VALUES (值1, 值2, ...);
INSERT INTO student VALUES (1, 2, '武汉'), (1, 2, '金力');
```

3. 更新和删除：
```sql
-- 更新数据
UPDATE table_name SET 字段=值1 WHERE 条件;
-- 删除数据
DELETE FROM table_name WHERE 条件;
```

4. 高级查询：
```sql
-- 分组查询
SELECT bill, COUNT(*) FROM table_name GROUP BY bill HAVING COUNT(*) > 2;
-- 排序
SELECT * FROM table_name ORDER BY bill ASC|DESC;
```

## 三、DCL（数据控制语言）Data Control Language

```sql
-- 授予权限
GRANT 权限 ON dbname.* TO user@"%" IDENTIFIED BY 'passwd';
-- 授权示例：授予用户对数据库的所有权限
GRANT ALL ON dbname.* TO user@"%" IDENTIFIED BY 'passwd';
-- 收回权限
REVOKE 权限 FROM user;
```

## 四、循环语句

1. 基本循环：
```sql
LOOP
    -- 语句
    EXIT WHEN 条件;  -- 无exit将无限循环
END LOOP;
```

2. FOR循环：
```sql
FOR index IN 1,2,3,4,5
LOOP
    -- 语句
END LOOP;
```

## 五、SQL中的约束（Constraints）

1. 主键约束：
```sql
ALTER TABLE table_name ADD CONSTRAINT ppp PRIMARY KEY (字段id);
```

2. CHECK约束：
```sql
ALTER TABLE table_name ADD CONSTRAINT ppp CHECK (字段age < 60);
```

3. UNIQUE约束：
```sql
ALTER TABLE table_name ADD CONSTRAINT app UNIQUE(字段name);
```

4. DEFAULT约束：
```sql
ALTER TABLE table_name ADD CONSTRAINT app DEFAULT 1000 FOR (字段money);
```

5. 外键约束：
```sql
ALTER TABLE table_name ADD CONSTRAINT ppp FOREIGN KEY(字段name)
REFERENCES teacher (字段name);
```

## 六、索引

```sql
-- 创建索引
CREATE INDEX index_name ON table_name (字段id);

-- 在创建表时指定索引
CREATE TABLE table_name {
    ...
    INDEX index_name (字段名row_name)
};

-- 添加索引
ALTER TABLE table_name ADD INDEX index_name (字段名row_name);
```

## 七、数据库备份

```bash
# 备份单个数据库
mysqldump -uroot -p database > /data/d.sql

# 备份所有数据库
mysqldump -uroot -p --all-databases > /data1/1.sql
```

## 八、Navicat快捷键

- `Ctrl + Q`: 打开新查询窗口
- `Ctrl + R`: 运行当前窗口内的所有语句
- `Ctrl + W`: 关闭当前窗口
- `F6`: 打开一个MySQL命令行窗口

## 九、MySQL基础知识

### 常见数据类型

- 字符型：`char`，`varchar`
- 数字型：`number`，`float`
- 日期时间：`time`，`timestamp`（显示时间到时分秒）

### SQL语句解析

1. SELECT语句组成部分：
- `SELECT`：查询的动作关键词
- `DISTINCT`：去重数据中的重复记录
- `select_list`：需要查询的字段列表
- `FROM`：表示数据的来源
- `WHERE`：查询条件部分（不能和函数连用）
- `GROUP BY`：分组子句
- `HAVING`：分组后的筛选条件
- `ORDER BY`：排序（ASC正序，DESC倒序，NULLS LAST/FIRST控制空值位置）

2. WHERE子句常用条件：
- `IS NULL`，`IS NOT NULL`
- `LIKE`
- `BETWEEN...AND...`
- `IN`
- `AND`，`OR`，`NOT`

3. 表连接类型：
```sql
-- 内连接
FROM 表名1 [INNER] JOIN 表名2 ON 条件;

-- 自连接
FROM 表名1 [INNER] JOIN 表名1 别名 ON 条件;

-- 左外连接
FROM 表名1 LEFT JOIN 表名2 ON 条件;

-- 右外连接
FROM 表名1 RIGHT JOIN 表名2 ON 条件;

-- 全外连接
FROM 表名1 FULL JOIN 表名2 ON 条件;
```

### 其他常用命令

```sql
-- 查看表结构
DESC tablename;

-- 查看存储引擎
SHOW ENGINES;

-- 刷新权限
FLUSH PRIVILEGES;

-- 合并查询结果
UNION ALL;

-- 使用正则表达式匹配
WHERE column REGEXP 'pattern';
```

### 并行查询示例

```sql
-- Oracle中使用hint启用并行模式
SELECT /*+ parallel(a,10) */ user_id, item_code
FROM table_name a;
```

### 多表查询示例

```sql
SELECT
    a.userid,
    a.username,
    b.rolename
FROM
    t_user a
LEFT JOIN
    t_user_role c ON a.userid = c.userid
LEFT JOIN
    t_role b ON c.roleid = b.roleid;
```