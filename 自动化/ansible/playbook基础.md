# Ansible Playbook基础

## 1. YAML基本语法

YAML语法规则：
- 大小写敏感
- 使用缩进表示层级关系
- 缩进时不允许使用Tab键，只允许使用空格
- 缩进的空格数目不重要，只要相同层级的元素左侧对齐即可
- `#` 表示注释，从这个字符一直到行尾，都会被解析器忽略

### 1.1 列表
每一个列表成员前面都要有一个短横线和一个空格

示例1：
```yaml
fruits:
  - Apple
  - Orange
  - Strawberry
  - Mango
```

示例2：
```yaml
fruits: ['Apple', 'Orange', 'Strawberry', 'Mango']
```

### 1.2 键值对
每一个成员由键值对组成，注意冒号后面要有空格

示例1：
```yaml
martin:
  name: Martin D'vloper
  job: Developer
  skill: Elite
```

示例2：
```yaml
martin: {name: Martin D'vloper, job: Developer, skill: Elite}
```

## 2. Playbook基础组件

1. `Hosts`：运行执行任务（task）的目标主机
2. `remote_user`：在远程主机上执行任务的用户
3. `tasks`：任务列表
   - `name`：任务显示名称
   - `action`：定义执行的动作
   - `module`：参数（以键值对的形式出现）
   - `copy`：复制本地文件到远程主机
   - `template`：复制本地文件到远程主机，可以引用本地变量
   - `service`：定义服务状态

示例：
```yaml
- name: install httpd
  yum: name=httpd state=present
```

4. `handlers`：任务，与tasks不同的是只有在接受到通知时才会被触发
5. `templates`：使用模板语言的文本文件，使用Jinja2语法
6. `variables`：变量，变量替换格式 `{{ variable_name }}`
7. 可以在ansible中调用其他模块：`copy`、`command`、`shell`
8. `when`：条件判断
9. `with_dict`：循环
10. `ignore_error`：错误忽略
11. `tags`：标签，`--skip-tags` 跳过标签，`-t` 指定标签
12. `include_tasks`：包含执行的task
13. `role`模式

## 3. 变量管理
- `--extra-vars`：运行时变量赋值
- 文件中定义
- `register`
- 默认变量

## 4. Playbook调用方式
```bash
ansible-playbook <filename.yml> ... [options]
```
