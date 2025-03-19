# AWK命令

## 基本语法
```bash
awk -F 'pattern + {action}' file  # pattern：匹配条件（不加{}），action：动作（加{}）
```

## 基本用法
```bash
# 使用分隔符并打印指定字段
awk -F ':' '{print $3 "这里原样输出"}' file    # -F指定分隔符，$0表示整行

# 条件判断和格式化输出
awk -F ':' '{if($3>100) printf "LINE:\n" NR}' password
```

## 重要概念
### 字段（Field）
- `filed`：域，字段
- `FS`（Field Separator）：字段分隔符
- `NF`（Number of Fields）：字段数量
- `$NF`：最后一个字段

### 记录（Record）
- `record`：记录
- `RS`（Record Separator）：记录分隔符
- `NR`（Number of Records）：记录数量
- `$0`：表示当前整行记录

## 内置变量
- `NR`：当前记录号（行号）
- `NF`：当前记录的字段数量
- `$NF`：最后一个字段的值
- `FILENAME`：当前处理的文件名
- `FS`：字段分隔符（对应NF）
- `RS`：记录分隔符（对应NR）

## 高级用法
### 格式化输出和计算
```bash
# 使用自定义分隔符
stat wuxiang.txt | awk -F "[0/]*" 'NR==4 {print $2}'   # [0/]表示用0或/作为分隔符

# 累加计算
awk -F":" '{print $0}{sum+=$3}END{print "总数:",sum}' wuxiang.txt

# 使用printf格式化输出
awk -F":" '{print $0}{sum+=$3}END{printf "总数%s都是:",sum}' wuxiang.txt
```

### 模式匹配
```bash
# 使用正则表达式
awk '/root/' passwd    # 等同于 grep "root" passwd

# 使用复杂匹配
awk '$1 ~ /(root|nginx)/' passwd    # 匹配root或nginx，需要使用小括号
```

### BEGIN和END块
```bash
# 使用BEGIN添加表头，END输出结果
awk -F ':' 'BEGIN{print "line.col.user"} {print NR,NF,$1} END{print FILENAME}'

# 条件统计
awk -F ':' '$3>15{a=a+1;print a}END{print a}' passwd
```

### 调用Shell变量
```bash
# 方法1：使用引号嵌套
var="test"
awk 'BEGIN{print "'$var'"}'

# 方法2：使用-v选项
awk -v var=test '{print var}'
```

## 使用规则
1. 整个awk命令用单引号括起来
2. 动作语句用{}括起来，条件语句用()括起来
3. 字符串需要使用双引号
4. if语句后使用小括号()

## 内置函数
- `gsub(r,s)`：在整个$0中用s替代r
- `gsub(r,s,t)`：在t中用s替代r
- `index(s,t)`：返回s中字符串t的第一个位置
- `length(s)`：返回s的长度
- `match(s,r)`：测试s是否包含匹配r的字符串
- `split(s,a,fs)`：在fs上将s分成序列a
- `sprintf(fmt,exp)`：返回格式化后的字符串
- `sub(r,s)`：用最左边最长的子串代替s
- `substr(s,p)`：返回s中从p开始的后缀部分
- `substr(s,p,n)`：返回s中从p开始长度为n的后缀部分