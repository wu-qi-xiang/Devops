# Keepalived + Nginx 高可用配置指南

## 环境配置

### 服务器配置

| 角色 | IP地址 | 安装组件 |
|------|--------|----------|
| master | 192.168.1.250 | keepalived + nginx |
| backup | 192.168.1.251 | keepalived + nginx |
| VIP | 192.168.1.253 | - |

> VIP（Virtual IP）是由keepalived分配给服务器网卡的虚拟IP地址。当master节点宕机时，VIP会自动迁移到backup节点上，确保服务的持续可用性。

## 配置文件

### Keepalived配置

在`/etc/keepalived/keepalived.conf`中添加以下配置：

```bash
vrrp_script chk_nginx {
    script "/usr/local/nginx/check_nginx.sh"    # nginx监控脚本
    interval 3                                # 每3秒执行一次脚本
}

state MASTER                                  # master主机角色为MASTER，backup主机角色为BACKUP
priority 100                                  # 权重，master要比backup大

virtual_ipaddress {
    192.168.1.253                            # 定义VIP
}

track_script {
    chk_nginx                                # 定义监控脚本，与上面的vrrp_script保持一致
}
```

### Nginx监控脚本

在`/usr/local/nginx/check_nginx.sh`中添加以下脚本：

```bash
#!/bin/bash

d=`date +%F-%T`
n=`ps -C nginx --no-heading|wc -l`   # 查看服务进程状态，去掉头取数

if [ $n -eq 0 ]
then
    /usr/local/nginx/sbin/nginx
    n2=`ps -C nginx --no-heading|wc -l`
    if [ $n2 -eq 0 ]
    then
        echo "$d，nginx down, keepalived will down" >> /usr/local/nginx/chech_nginx.log
        systemctl stop keepalived
    fi
fi
```

## 工作原理

1. keepalived会定期执行监控脚本（每3秒一次）检查nginx的运行状态
2. 如果检测到nginx进程不存在，脚本会尝试重启nginx
3. 如果重启失败，则停止keepalived服务，触发VIP迁移
4. backup节点检测到master节点的keepalived服务停止后，会接管VIP，继续提供服务
