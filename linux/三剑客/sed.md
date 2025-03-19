# SED命令

## 基本语法
```bash
sed [参数] 'command' file
```

## 常用参数
- `-i`：写入到文件（慎用，修改之前建议备份）
- `-n`：取消默认全部行的输出，只输出指定匹配到的行
- `-e`：多项匹配
- `-a`：指定行增加内容
- `-r`：支持扩展正则表达式

## 常用命令
- `s`：替换
- `g`：全局替换
- `p`：打印匹配行
- `d`：删除
- `w`：将替换后的内容写入文件
- `r`：读取文件内容
- `i`：插入文本
- `=`：显示行号
- `q`：退出

## 常用操作示例

### 打印指定行
```bash
# 打印20-30行
sed -n '20,30p' 1.txt

# 打印匹配到root的行
sed -n '/root/p' passwd

# 打印指定范围内匹配的行
sed -n "4,/root/p" q.txt

# 只打印匹配行的行号
sed -n "/root/=" q.txt
```

### 删除操作
```bash
# 删除匹配到root的所有行
sed -i "/root/d" q.txt
```

### 替换操作
```bash
# 全局替换
sed -i 's#原字符#新替换的字符#g' `find /usr/ -type f -name "*.sh"`

# 替换后写入新文件
sed "s/原字符/替换的新字符/gw 1.txt" 文件名

# 使用Shell变量（需要使用双引号）
sed "s/原字符/替换的新字符/g" 文件名
```

### 文件操作
```bash
# 将指定行写入新文件
sed "1,2 w 1.txt" q_bak.txt

# 在匹配行前插入内容
sed -n "s/sshd/nihao &/p" q_bak.txt
```

### 高级应用
```bash
# 提取IP地址
ifconfig eth0|sed -nr '2p'|sed -r 's\^.*inet\\g'|sed -r 's\net.*$\\g'
# 或者使用更简洁的方式
ifconfig eth0|sed -nr 's#^.*inet (.*) net.*$#\1#gp'

# 在XML配置文件中添加配置
sed -i "/<\/Host>/i\<Context path=\"\" docBase=\"/path/to/app\" reloadable=\"false\"></Context>" server.xml

# 注释配置文件中的特定行
sed -i "/7005/s/server/#server/" nginx.conf
```

## 特殊用法
### 查看文件中的特殊字符
```bash
cat -v 文件名
cat -A 文件名
```

### 读取文件内容到指定位置
```bash
# 将issue文件内容添加到fstab的第二行后面
sed '2r /etc/issue' /etc/fstab
```