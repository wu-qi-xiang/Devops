# Ansible基础

## 1. 安装配置
### 1.1 配置epel源并安装ansible

| 配置文件或指令 | 描述 |
|----------------|------|
| `/etc/ansible/ansible.cfg` | 主配置文件，配置ansible工作特性，官方文档 |
| `/etc/ansible/hosts` | 主机清单 |
| `/etc/ansible/roles/` | 存放角色的目录 |
| `/usr/bin/ansible` | 主程序，临时命令执行工具 |
| `/usr/bin/ansible-doc` | 查看配置文档，模块功能查看工具 |
| `/usr/bin/ansible-galaxy` | 下载/上传优秀代码或Roles模块的官网平台 |
| `/usr/bin/ansible-playbook` | 定制自动化任务，编排剧本工具 |
| `/usr/bin/ansible-pull` | 远程执行命令的工具 |
| `/usr/bin/ansible-vault` | 文件加密工具 |
| `/usr/bin/ansible-console` | 基于Console界面与用户交互的执行工具 |

### 1.2 安装步骤
```bash
# CentOS 6需要先安装epel源
yum install epel-release
# 安装ansible
yum install ansible
```

### 1.3 基础配置
1. 编辑配置文件：
```bash
# 编辑/etc/ansible/ansible.cfg
host_key_checking = False    # 去掉ssh秘钥验证，允许ssh密码管理客户端
```

## 2. SSH免密配置
### 2.1 生成密钥
```bash
ssh-keygen -t rsa
```

### 2.2 配置hosts文件
```bash
# vim /etc/ansible/hosts
193.112.29.19 ansible_user=zyw ansible_ssh_pass="cAVvyfD7YxEeK4kI" ansible_ssh_port=222
```

### 2.3 批量免密配置方法
#### 方法一：
```bash
# 复制公钥到远程主机
ansible all -m copy -a "src=/home/mike/.ssh/id_rsa.pub dest=/tmp/id_rsa.pub" --ask-pass -c paramiko
# 添加公钥到authorized_keys
ansible all -m shell -a "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys" --ask-pass -c paramiko
```

#### 方法二：
```bash
ansible all -m authorized_key -a "user=sbiadmin key='{{ lookup('file', '/home/sbiadmin/.ssh/id_rsa.pub') }}' path=/home/sbiadmin/.ssh/authorized_keys manage_dir=no" --ask-pass -c paramiko
```

### 2.4 设置SSH权限
```bash
# 设置.ssh目录权限
ansible all -m file -a "dest=/home/jenkins/.ssh mode=700"
# 设置authorized_keys文件权限
ansible all -m file -a "dest=/home/jenkins/.ssh/authorized_keys mode=600"
```

## 3. Ansible基本语法
```bash
ansible <host-pattern> [-m module_name] [-a args] [options]
```
示例：
```bash
# 使用command模块（默认）
ansible all -m command -a ls
# 指定多个主机组
ansible ip:ip:ip(组:组:组) -a "ls"    # 相当于或，&,!
```

## 4. 使用Root用户执行
### 4.1 模块方式
```bash
--become-user=root --become-method=sudo -b
```

### 4.2 Playbook方式
```yaml
---
- hosts: APS
  gather_facts: false
  become_user: root
  become: yes
  become_method: sudo
  tasks:
    - name: change zabbix_agentd conf
      template:
        src: /etc/zabbix/zabbix_agentd.conf
        dest: /etc/zabbix/zabbix_agentd.conf
    - name: restart zabbix agent
      service: name=zabbix-agent state=restarted
```