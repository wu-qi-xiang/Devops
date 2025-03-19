
# Nginx基础知识

## 安装准备

安装以下依赖包：

```bash
# 安装ssl功能相关包
yum -y install openssl openssl-devel

# 安装编译所需的gcc
yum -y install gcc

# 安装rewrite功能相关包
yum -y install pcre pcre-devel

# 一键安装所有依赖
yum -y install openssl openssl-devel gcc pcre pcre-devel
```

## 编译安装

```bash
# 配置安装选项
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module

# 编译安装
make && make install
```

## 基本操作

1. 配置文件路径：`/usr/local/nginx/conf/nginx.conf`
2. 重新加载配置文件：`/usr/local/nginx/sbin/nginx -s reload`
   - 使用 `-t` 参数可以确认配置文件语法是否正确
3. 启动nginx：`/usr/local/nginx/sbin/nginx`

## 核心配置

Nginx的配置文件主要分成4个部分：

- **main**：全局配置
- **upstream**：上游服务器设置，用于反向代理和负载均衡
- **server**：虚拟主机配置
- **location**：URL匹配特定位置的设置

### 虚拟主机配置

虚拟主机可以绑定一个或多个域名。当访问的域名没有与任何虚拟主机绑定时，会使用默认虚拟主机进行解析。

```nginx
server {
    listen 8080 default_server;    # default_server表示这个是默认的虚拟主机
    server_name www.magedu.com;
    root /vhost/webs;
}
```

### Location配置

Location用于匹配用户请求的URL，并执行对应的指令。匹配优先级从高到低：

1. `=`：精确匹配
2. `^~`：非正则严格匹配
3. `~`：正则表达式匹配（区分大小写）
4. `~*`：正则表达式匹配（不区分大小写）
5. `/`：普通匹配

示例：
```nginx
# 404错误页面重定向到百度
error_page 404 = @fallback;
location @fallback {
    proxy_pass http://www.baidu.com;
}
```

### Rewrite规则

Rewrite用于实现URL重写，需要pcre支持。主要用于实现伪静态。

#### 结尾标识符

- `last`：继续匹配后面的规则
- `break`：不再匹配后面的规则
- `redirect`：临时重定向（302）
- `permanent`：永久重定向（301）

#### 示例

```nginx
rewrite ^/shop_(\d+)/goods-(\d+)\.html /shop.php?_a=detail&_c=goods&id=$2&shop_id=$1 last;
```

### 其他常用功能

#### Gzip压缩

启用gzip压缩可以节约带宽，但会增加CPU消耗。

#### Expires缓存

在location和if语句中使用expires指令可以设置浏览器缓存：

```nginx
expires 1d;    # 设置浏览器缓存时间为1天
```

#### 访问控制

1. 基于IP的访问控制：
```nginx
location /admin/ {
    allow 192.168.1.0/24;
    deny all;
}
```

2. 基于用户认证的访问控制：
```nginx
location /private/ {
    auth_basic "请输入密码";
    auth_basic_user_file /usr/local/nginx/conf/htpasswd;
}
```

#### 配置热更新

不重启服务更新配置：
```bash
/bin/kill -HUP `cat $nginx_pid`
```

















