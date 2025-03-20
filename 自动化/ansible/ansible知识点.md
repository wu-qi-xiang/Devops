# Ansible知识点总结

## 1. 管理节点要求

### Linux/Unix
- Python 2.7 或 3.6+

### Windows
- Powershell 3.0+
- .NET 4.0+
- WinRM

## 2. 基础概念

### 2.1 默认参数
```bash
# localhost默认主机
ansible -i inventory --list-hosts localhost
```
- `ungrouped`：未分配主机组的主机
- `all`：所有的主机

### 2.2 配置文件优先级
```
./ansible.cfg > ~/.ansible.cfg > /etc/ansible/ansible.cfg
```
注：在当前目录使用 `ansible --version` 查看配置文件位置

### 2.3 查找模块使用方法
```bash
# 查看模块的帮助信息
ansible-doc ping
```

## 3. Playbook详解

### 3.1 基本组成
每个playbook包含一个或多个play，每个play必须包含：
- `hosts`：受管主机（从inventory获取）
- `tasks`：具体任务（由一个或多个module实现）

### 3.2 语法检查
```bash
# 语法结构检查
ansible-playbook --syntax-check playbook.yml
# 空跑测试
ansible-playbook -C playbook.yml
```

## 4. 变量管理

### 4.1 变量范围
1. 全局范围：命令行或Ansible配置文件中定义
2. Play范围：在play的name之后，tasks之前
3. 主机范围：
   - inventory清单
   - ansible_facts事实
   - register注册变量

### 4.2 变量定义和引用
```yaml
# 定义变量
vars:
  var: http

# 引入变量文件
vars_files:
  - vars.yml

# 引用变量
"{{ var }}"
```

### 4.3 注册变量示例
```yaml
---
- name: Install and Configure WWW Web Server
  hosts: webservers
  tasks:
    - name: Ensure httpd service is running and enabled
      service:
        name: httpd
        enabled: yes
        state: restarted
      register: echo_result

    - name: Print info
      debug:
        msg: "HTTPD Service is restartd"
      when: echo_result.state == "started"
```

## 5. 高级特性

### 5.1 循环和条件判断
```yaml
- name: Install Packages
  hosts: webservers
  tasks:
    - name: Install web package
      yum:
        name: "{{ item }}"
        state: absent
      loop:
        - httpd
        - httpd-tools
        - httpd-manual
      register: install_result
      when:
        - ansible_facts['hostname'] == "servera"
        - ansible_facts['distribution_version'] == "8.1"
```

### 5.2 Handlers和Notify
```yaml
---
- name: Deploy HTTPD Web Server
  hosts: servera.lab.example.com
  tasks:
    - name: copy new vhost.conf to managed
      copy:
        src: files/vhost.conf
        dest: /etc/httpd/conf.d/vhost.conf
      notify: restart httpd service
 
  handlers:
    - name: restart httpd service
      service:
        name: httpd
        state: restarted
```

### 5.3 错误处理
- `ignore_errors: yes`：忽略报错继续执行
- `failed_when: command_result.rc == 0`：指定失败任务的条件
- `changed_when: false`：指定任务状态为CHANGED时的处理

### 5.4 块处理
- `block`：正常流程执行的任务
- `rescue`：回滚任务
- `always`：无论如何都要执行的任务

## 6. 模板和文件处理

### 6.1 Jinja2模板
用于传输带有目标主机相关的配置文件

### 6.2 循环和条件语句
```jinja2
{% for variable in list %}
  {{ variable }}
{% endfor %}

{% if finish %}
  {{ result }}
{% endif %}
```

## 7. 角色（Roles）

### 7.1 角色目录结构
```
roles/example/
├── defaults/
│   └── main.yml    # 变量默认值
├── files/          # 存放文件
├── handlers/
│   └── main.yml    # 触发任务
├── meta/
│   └── main.yml    # 元数据
├── tasks/
│   └── main.yml    # 执行任务
├── templates/      # Jinja2模板
├── tests/          # 测试文件
└── vars/
    └── main.yml    # 变量定义
```

### 7.2 角色管理
```bash
# 列出角色
ansible-galaxy list
# 创建角色结构
ansible-galaxy init rolepath/rolename
# 删除远程仓库角色
ansible-galaxy delete
# 删除本地角色
ansible-galaxy remove
```

## 8. 调试技巧

### 8.1 日志配置
在ansible.cfg中添加：
```ini
log_path = ansible.log
```

### 8.2 执行选项
```bash
# 语法检查
ansible-playbook --syntax-check
# 空运行
ansible-playbook -C
# 详细输出
ansible-playbook -vvvv
# 逐步执行
--step
# 从指定任务开始
--start-at-task
```