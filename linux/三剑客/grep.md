# GREP命令

## 基本语法
```bash
grep "1" filename  # 等同于 cat filename | grep "1"
```

## 常用参数
- `-i`：忽略大小写
- `-n`：打印行号
- `-v`：打印不符合要求的行
- `-c`：打印符合要求的行数的次数
- `--color=auto`：匹配到的字符显示颜色
- `-e`：支持多个匹配样式
- `-w`：只匹配完整的单词

## 高级用法

### 指定行范围打印
```bash
grep 20 -A 10 1.txt  # 显示匹配行及其后10行
grep 25 -C 5 1.txt   # 显示匹配行及其前后各5行
grep 30 -B 10 1.txt  # 显示匹配行及其前10行
```
- `-A`(after)：显示匹配行及其后面的行
- `-B`(before)：显示匹配行及其前面的行
- `-C`(center)：显示匹配行及其前后的行

### 多模式匹配
```bash
# 使用grep -e
echo "this is a text line" | grep -e "is" -e "line"

# 使用egrep（等同于grep -E）
echo "this is a text line" | egrep -e "is|line"

# 匹配多个模式
grep -n -e "root" -e "wuqixiang" pass
egrep -e "root|wuqixiang" pass
```

### 重复字符匹配
```bash
# 使用grep（需要转义{}）
cat passwd | grep -e '5\{1,4\}'    # 匹配5出现1-4次的行

# 使用egrep（不需要转义{}）
cat passwd | egrep -e '5{1,4}'       # 匹配5出现1-4次的行
```

### 精确匹配
```bash
grep "\b4\b" 2_bak.txt    # 精确匹配4，不匹配44
grep "^[^root]" pass      # 匹配不以root开头的行
```

## 配合其他命令使用
### xargs命令
- `-n`：对输入的内容进行分组给下一个命令

### seq命令
- `seq`：生成序列（sequence）
- `-s`：指定分隔符