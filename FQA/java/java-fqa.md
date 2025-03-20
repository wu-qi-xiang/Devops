# Java 常见问题排查指南

## 1. Zabbix数据库监控问题
### 问题描述
zabbix+odbc连接数据库监控时，zabbix_server会自动重启

### 解决方案
- 检查ODBC版本兼容性问题

## 2. Java GC性能问题
### 问题描述
- **现象**：java程序占用大量CPU，导致系统负载升高
- **原因**：java程序默认内存不足，导致频繁触发垃圾回收占用大部分CPU

### 解决方案
1. 添加GC日志分析参数：
   ```bash
   -XX:+PrintGCDetails -XX:+PrintGCDateStamps
   ```
2. 使用gceasy.io网站分析GC日志
3. 优化措施：
   - 切换为G1垃圾回收器
   - 调整新生代内存大小

![GC分析图](images/image.png)

## 3. Tomcat线程死锁问题
### 问题描述
- **现象**：
  - tomcat端口无法访问
  - tomcat停止写日志
- **原因**：tomcat默认最大连接数(线程数)为200，超过限制后出现假死

### 监控工具
- 使用`jconsole`进行Java应用监控

### 解决方案
1. 增加默认连接数至400
2. 调整服务器TCP连接timeout时间

## 4. Tomcat文件句柄问题
### 问题描述
出现`too many open file descriptors`错误

### 参考资料
- [Tomcat故障诊断文档](https://cwiki.apache.org/confluence/display/TOMCAT/Troubleshooting+and+Diagnostics)
- [文件泄漏检测工具](http://file-leak-detector.kohsuke.org/)

### 诊断命令
```bash
java -jar file-leak-detector.jar 32219 error=error.log;http=19999;threshold=Y;trace=trace.log
```

## 5. Java OOM问题分析
### 内存转储和分析
```bash
jmap -dump:format=b,file=dump.gprof <pid>
```
使用jvisualvm分析dump文件

### 问题诊断步骤
1. 使用`jps`查看Java进程
2. 使用`jinfo`查看进程信息：
   - heap大小
   - eden区
   - survivor区
   - old区
   - GC收集器
3. 使用`jstat`查看GC信息
4. 使用`jstack`分析Java线程信息
5. 使用`jmap`查看实例数量及内存占用

### Java内存模型
![Java内存模型](images/image-1png)