# LVS的DR模式配置指南

## 服务器配置

### 服务器角色及IP配置

| 角色 | 网卡 | IP配置 |
|------|------|--------|
| 调节器 | eth0 | 192.168.0.8 |
| | eth0:0 (VIP) | 192.168.0.38 |
| Real Server1 | eth0 | 192.168.0.18 |
| | lo:0 (VIP) | 192.168.0.38 |
| Real Server2 | eth0 | 192.168.0.28 |
| | lo:0 (VIP) | 192.168.0.38 |

## 安装配置

### 调节器配置

1. 安装ipvsadm：
```bash
yum install -y ipvsadm
```

2. 在Real Server上安装nginx服务：
```bash
yum install -y nginx
```

### 配置脚本

#### 1. 调节器配置脚本

创建并编辑文件：`/usr/local/sbin/lvs_dr.sh`

```bash
#! /bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ipv=/sbin/ipvsadm
vip=192.168.0.38
rs1=192.168.0.18
rs2=192.168.0.28

ifconfig eth0:0 down
ifconfig eth0:0 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip dev eth0:0

$ipv -C
$ipv -A -t $vip:80 -s wrr 
$ipv -a -t $vip:80 -r $rs1:80 -g -w 3
$ipv -a -t $vip:80 -r $rs2:80 -g -w 1
```

#### 2. Real Server配置脚本

在两台真实服务器上创建并编辑文件：`/usr/local/sbin/lvs_dr_rs.sh`

```bash
#! /bin/bash
vip=192.168.0.38

ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip lo:0

echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
```

### 脚本权限设置与执行

为脚本添加执行权限并运行：
```bash
chmod a+x /usr/local/sbin/lvs_dr.sh
chmod a+x /usr/local/sbin/lvs_dr_rs.sh
/usr/local/sbin/lvs_dr.sh
/usr/local/sbin/lvs_dr_rs.sh
```