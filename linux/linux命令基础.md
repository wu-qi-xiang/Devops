# Linux命令基础

## 文件操作命令

1. `file`：查看文件类型
   - `stat 文件`：查询文件的属性

2. `last`/`lastb`：查看用户的登录信息
   - `lastlog`：显示最近登录信息
   - 日志文件路径：`/var/log/lastlog`

3. PATH环境变量
   - 命令放到PATH变量路径，即可直接使用
   - path会自动寻找命令

4. 文件删除机制
   - 删除源文件的硬链接并且没有进程占用文件之后，文件的内存才会被其他文件覆盖

5. 文件重命名
   ```bash
   rename from to file  # 重命名
   rename "123" "456" file  # 把file文件名中的123换成456
   ```

6. 路径操作
   ```bash
   dirname 路径  # 显示文件所在目录路径
   basename 路径  # 显示路径最后的文件或者目录
   ```

7. 日期时间操作
   ```bash
   date +%F  # 等同于 date +%Y-%m-%d，显示年月日
   date +%Y-%m-%d-%H:%M:%S  # 等同于 date +%F-%T，显示年月日时分秒周
   date +%Y%m%d -d -1day  # 显示昨天的日期
   date --h  # 查询更多选项
   ```

8. 文件链接
   - 硬链接：
     ```bash
     ln 文件名 链接文件名
     ```
     1. 多个文件名指向一个索引节点
     2. 不能链接目录
     3. 索引节点一样的文件互为硬链接文件，不增加内存
     4. 不能跨分区

   - 软链接：
     ```bash
     ln -s 文件名 链接文件名  # 原地址必须为绝对路径
     ```
     1. 类似windows的快捷方式
     2. 软链接文件新建之后便会生成链接文件
     3. 软链接文件是不同的inode指向原文件

## 用户管理命令

1. 用户ID查询
   ```bash
   id  # 查询用户id信息
   ```
   - UID：用户的ID（相当于身份证）
   - GID：用户组的ID
   - root的uid和gid均为0

2. 用户创建配置
   - 相关配置文件：
     - `/etc/login.defs`
     - `/etc/default/useradd`
   ```bash
   useradd -s /sbin/nologin 用户  # 创建用户并不登录
   chage  # 修改用户密码的有效期
   usermod  # 修改用户属性
   ```

3. sudo权限配置
   ```bash
   visudo  # 修改/etc/sudoers文件，配置sudo授权权限
   ```
   格式：
   ```
   用户    机器=(角色)    NOPASSWD:命令
   ```
   - User Aliases：用户别名
   - Command Aliases：命令别名

## 系统管理命令

1. crontab定时任务
   ```
   *    *    *    *    *
   分钟 小时  日    月   星期
   ```
   常用命令：
   ```bash
   crontab -l  # 列出定时任务
   crontab -u  # 指定用户
   crontab -e  # 编辑定时任务
   crontab -r  # 删除定时任务
   ```
   - 配置文件：`/etc/cron.daily`
   - 用户配置文件：`/var/spool/cron/用户`

2. dd命令（数据复制）
   ```bash
   dd if=/dev/zero of=swapfree bs=32k count=65515
   ```
   参数说明：
   - `if=文件名`：输入文件名，缺省为标准输入
   - `of=文件名`：输出文件名，缺省为标准输出
   - `ibs=bytes`：一次读入bytes个字节
   - `obs=bytes`：一次输出bytes个字节
   - `bs=bytes`：同时设置读入/输出的块大小
   - `cbs=bytes`：指定转换缓冲区大小

3. 文件比较
   ```bash
   diff  # 比较2个文件或目录的差异
   # 参数：a(and), c(change), d(delete)
   
   vimdiff  # 比较2个文件的差异并用vim显示
   ```

4. 系统限制命令
   ```bash
   ulimit -n  # 最大文件描述符打开数
   ulimit -u  # 设置用户可以使用的最大进程数
   ulimit -a  # 显示所有限制
   ```

5. 其他实用命令
   ```bash
   tee -a filename  # 追加到文件末尾
   watch -n 秒数  # 周期性执行程序，默认2s
   ```

## 数据处理命令

1. xargs和exec命令
   - 从标准输入获取数据并转化为命令行
   ```bash
   xargs -n 4  # 分为4组
   xargs -i  # 每个参数命令都会被执行一次
   xargs -d  # 自定义定界符
   
   # 批量改名示例
   ls *.txt | xargs -n1 -i{} mv {} {}_bak
   find ./*txt -exec mv {} {}_bak \;
   
   # 复制文件示例
   find -name wuxiang.txt | xargs cp --target-directory=/data/
   ```

2. 环境变量命令
   ```bash
   env  # 查询少数系统变量
   set  # 查询所有系统变量
   source 配置文件  # 使配置文件生效
   ```

## 数据备份命令

1. rsync同步工具
   ```bash
   rsync 参数 src dest  # 本地同步，参数-avL
   rsync 参数 src [user@]host:dest  # 本地到远程
   rsync 参数 [user@]host:src dest  # 远程到本地
   ```

2. FTP文件传输
   ```bash
   ftp ip  # 登录FTP服务器
   get  # 下载文件
   put  # 上传文件
   lcd  # 修改本地路径
   ```