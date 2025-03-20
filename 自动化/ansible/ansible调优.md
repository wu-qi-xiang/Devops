# Ansible调优指南

> 参考博客：https://www.cnblogs.com/legenidongma/p/10759412.html

## 1. SSH配置优化

### 1.1 关闭SSH密钥检测
```bash
# 编辑配置文件
vim /etc/ansible/ansible.cfg

# 添加配置
host_key_checking = False
```

### 1.2 关闭SSH的UseDNS
```bash
# 编辑配置文件
vim /etc/ssh/sshd_config

# 添加配置
UseDNS no
GSSAPIAuthentication no

# 重启服务
/etc/init.d/sshd restart
```

### 1.3 启用SSH Pipeline加速
> 注意：此优化不适用于sudo场景

```bash
# 编辑配置文件
vim /etc/ansible/ansible.cfg

# 修改配置
pipelining = False
```

## 2. Playbook优化

### 2.1 关闭Facts收集
在YAML文件中添加以下配置：
```yaml
gather_facts: no
```

## 3. SSH连接持久化优化

### 3.1 配置ControlPersist
```bash
# 编辑配置文件
vim /root/.ssh/config

# 添加配置
Host *
  Compression yes
  ServerAliveInterval 60
  ServerAliveCountMax 5
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 4h
```