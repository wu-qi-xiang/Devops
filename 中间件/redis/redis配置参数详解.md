# Redis配置参数详解

1. **守护进程模式**
   ```conf
   daemonize no
   ```
   Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程

2. **PID文件路径**
   ```conf
   pidfile /var/run/redis.pid
   ```
   当Redis以守护进程方式运行时，Redis默认会把pid写入/var/run/redis.pid文件，可以通过pidfile指定

3. **监听端口**
   ```conf
   port 6379
   ```
   指定Redis监听端口，默认端口为6379，作者在自己的一篇博文中解释了为什么选用6379作为默认端口，因为6379在手机按键上MERZ对应的号码，而MERZ取自意大利歌女Alessia Merz的名字

4. **绑定地址**
   ```conf
   bind 127.0.0.1
   ```
   绑定的主机地址

5. **客户端超时**
   ```conf
   timeout 300
   ```
   当客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能

6. **日志级别**
   ```conf
   loglevel verbose
   ```
   指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose

7. **日志输出位置**
   ```conf
   logfile stdout
   ```
   日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null

8. **数据库数量**
   ```conf
   databases 16
   ```
   设置数据库的数量，默认数据库为0，可以使用`SELECT <dbid>`命令在连接上指定数据库id

9. **数据同步策略**
   ```conf
   save <seconds> <changes>
   save 900 1
   save 300 10
   save 60 10000
   ```
   指定在多长时间内，有多少次更新操作，就将数据同步到数据文件。Redis默认配置文件中提供了三个条件：
   - 900秒（15分钟）内有1个更改
   - 300秒（5分钟）内有10个更改
   - 60秒内有10000个更改

10. **数据压缩**
    ```conf
    rdbcompression yes
    ```
    指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大

11. **数据库文件名**
    ```conf
    dbfilename dump.rdb
    ```
    指定本地数据库文件名，默认值为dump.rdb

12. **数据库存放路径**
    ```conf
    dir ./
    ```
    指定本地数据库存放目录

13. **主从服务设置**
    ```conf
    slaveof <masterip> <masterport>
    ```
    设置当本机为slave服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步

14. **主服务器密码**
    ```conf
    masterauth <master-password>
    ```
    当master服务设置了密码保护时，slave服务连接master的密码

15. **访问密码**
    ```conf
    requirepass foobared
    ```
    设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过`AUTH <password>`命令提供密码，默认关闭

16. **最大客户端连接数**
    ```conf
    maxclients 128
    ```
    设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置`maxclients 0`，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息

17. **最大内存限制**
    ```conf
    maxmemory <bytes>
    ```
    指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作

18. **日志记录方式**
    ```conf
    appendonly no
    ```
    指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失

19. **更新日志文件名**
    ```conf
    appendfilename appendonly.aof
    ```
    指定更新日志文件名，默认为appendonly.aof

20. **更新日志条件**
    ```conf
    appendfsync everysec
    ```
    指定更新日志条件，共有3个可选值：
    - `no`：表示等操作系统进行数据缓存同步到磁盘（快）
    - `always`：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全）
    - `everysec`：表示每秒同步一次（折衷，默认值）

21. **虚拟内存机制**
    ```conf
    vm-enabled no
    ```
    指定是否启用虚拟内存机制，默认值为no

22. **虚拟内存文件路径**
    ```conf
    vm-swap-file /tmp/redis.swap
    ```
    虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享

23. **虚拟内存使用**
    ```conf
    vm-max-memory 0
    ```
    将所有大于vm-max-memory的数据存入虚拟内存，无论vm-max-memory设置多小，所有索引数据都是内存存储的（Redis的索引数据就是keys），也就是说，当vm-max-memory设置为0的时候，其实是所有value都存在于磁盘。默认值为0

24. **虚拟内存页大小**
    ```conf
    vm-page-size 32
    ```
    Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多个对象共享。vm-page-size是要根据存储的数据大小来设定的，作者建议如果存储很多小对象，page大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page

25. **虚拟内存页数量**
    ```conf
    vm-pages 134217728
    ```
    设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的，在磁盘上每8个pages将消耗1byte的内存

26. **虚拟内存访问线程数**
    ```conf
    vm-max-threads 4
    ```
    设置访问swap文件的线程数，最好不要超过机器的核数，如果设置为0，那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4

27. **数据包合并**
    ```conf
    glueoutputbuf yes
    ```
    设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启

28. **哈希表参数**
    ```conf
    hash-max-zipmap-entries 64
    hash-max-zipmap-value 512
    ```
    指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法

29. **重置哈希**
    ```conf
    activerehashing yes
    ```
    指定是否激活重置哈希，默认为开启

30. **包含配置**
    ```conf
    include /path/to/local.conf
    ```
    指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件