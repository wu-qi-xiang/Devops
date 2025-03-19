# NFS服务配置指南

## 环境说明
- NFS服务器IP：192.168.188.128
- 客户端IP：128.168.188.128

## 安装配置
### 服务端安装
NFS服务需要安装两个包：nfs-utils和rpcbind（安装nfs-utils时会自动安装rpcbind）
```bash
yum -y install nfs-utils
```

### 配置文件
编辑 `/etc/exports` 文件：
```bash
/data/       192.168.188.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000)
```

配置说明：
- `/data/`：共享目录
- `192.168.188.0/24`：允许访问的主机网段
- 参数说明：
  - `rw`：读写权限
  - `ro`：只读权限
  - `sync`：同步模式，数据实时写入磁盘
  - `async`：异步模式，数据定期写入磁盘
  - `all_squash`：将访问用户映射为nfsnobady用户

### 启动服务
```bash
systemctl start rpcbind
systemctl start nfs
systemctl enable rpcbind
systemctl enable nfs
```

## 客户端配置
### 安装NFS客户端
```bash
yum -y install nfs-utils
```

### 查看和挂载
```bash
# 查看NFS服务器共享目录
showmount -e 192.158.188.128

# 挂载NFS共享
mount -t nfs 192.158.188.128:/data/ /mnt/

# 设置开机自动挂载
echo "mount -t nfs 192.158.188.128:/data/ /mnt/" >> /etc/profile
```

## 管理维护
### 共享目录管理
```bash
# 增加NFS共享目录后重新加载配置
exportfs -arv

# 强制卸载挂载点
umount 挂载点 -lf

# 查看NFS参数
cat /proc/mount
```

## 性能优化
### 硬件优化
- 使用SAS/SSD磁盘
- 配置RAID10阵列

### 内核参数优化
```bash
cat >> /etc/sysctl.conf << EOF
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
EOF
```

### 连接测试
```bash
# 测试网络连通性
ping 192.158.188.128

# 测试端口连通性
telnet 192.158.188.128 111
```

