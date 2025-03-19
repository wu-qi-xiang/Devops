# Nginx面试题总结

## 1. 访问统计分析
### 如何获取访问Nginx最多的10个IP？
```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr -k1 | head -10
```

## 2. 日志管理
### Nginx日志按日期切割方案
按月分目录存储，并删除3个月前的日志：

```bash
#!/bin/bash
# nginx的日志路径/usr/local/nginx/logs
d=`date +%Y%m%d -d -1day`
logdir=/usr/local/nginx/logs
nginx_pid=/usr/local/nginx/logs/nginx.pid

cd $logdir
for n in `ls *.log`
do
    mv $n $n-$d
done

# 需要更新配置，但是不启停服务
/bin/kill -HUP `cat $nginx_pid`   # 重新加载配置文件
```

定时任务配置：
```bash
0 0 * * * sh /usr/local/nginx/logs/nginxlog.sh > /dev/null 2>&1 &
```

## 3. 访问异常排查步骤
1. 使用 `ping ip` 排除网络链路问题
2. 使用 `telnet ip 端口` 排除防火墙问题
3. 使用 `wget ip` 或 `curl -I ip` 模拟用户访问

## 4. 正向代理与反向代理的区别

### 正向代理
- 代理客户端
- 客户端知道目标服务器的地址
- 目标服务器不知道真实客户端的地址
- 典型应用场景：VPN和科学上网

### 反向代理
- 代理服务器，为服务器服务
- 客户端不知道真实服务器的地址
- 服务器不知道真实客户端的地址
- 典型应用场景：负载均衡和CDN

### 主要区别
从用途上看，正向代理主要用于访问控制和突破访问限制，而反向代理主要用于负载均衡、安全防护和缓存加速。

## 5. Nginx的Location匹配优先级
Nginx的location匹配优先级从高到低依次为：

1. `=` 精确匹配：完全匹配指定的URL
2. `^~` 非正则严格匹配：匹配以指定字符串开头的URL
3. `~` 正则表达式匹配（区分大小写）
4. `~*` 正则表达式匹配（不区分大小写）
5. `/` 普通匹配：匹配任何请求

**注意**：当多个location规则可以匹配同一个URL时，Nginx会优先使用优先级高的规则。如果同一优先级有多个匹配，则使用最长的匹配。