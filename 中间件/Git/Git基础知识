# Git基础知识

## Git工作区概念
- **工作区**：通过`git init`创建的目录就是工作区
- **版本库**：工作区中的`.git`目录是Git的版本库。版本库中最重要的是stage（或称index）暂存区，以及Git自动创建的第一个分支master和指向master的指针HEAD。

## 基本操作
### 1. 安装与初始化
```bash
# 安装Git
yum -y install git

# 初始化Git仓库
git init 目录
```

### 2. 常用命令
```bash
# 文件操作
git add readme.txt                # 把文件添加到暂存区index中
git commit -m "提交说明"          # 把暂存区所有内容提交到当前分支
git push -u origin master        # 推送到GitHub上的仓库

# 状态查看
git status                      # 查询当前仓库的状态
git diff 文件名                  # 查询文件具体修改内容

# 版本控制
git reset --hard HEAD^          # 返回上一版本（HEAD^表示上个版本）
git reflog                      # 查看历史命令，显示版本号
git checkout -- file            # 撤销工作区的修改
git rebase                      # 把git的提交过程整理成串行
```

### 3. 文件删除
```bash
# 删除文件步骤
rm 文件                          # 先在工作区删除文件
git rm 文件                      # Git中删除文件
git commit -m "删除文件"         # 提交删除操作
```

## GitHub连接配置
### 1. SSH密钥配置
```bash
# 生成SSH密钥
ssh-keygen -t rsa -C "774727549@qq.com"    # 创建id_rsa私钥和id_rsa.pub公钥

# 添加公钥到GitHub
# 把id_rsa.pub的内容添加到GitHub设置的SSH页面
```

### 2. 远程仓库操作
```bash
# 推送操作
git push -u origin master                   # 推送到GitHub仓库

# 分支关联
git branch --set-upstream-to=origin/backup backup  # 关联本地和远程backup分支
git checkout -b backup                      # 创建并切换到backup分支

# 其他操作
git pull origin 分支                         # 拉取远程分支到本地
git remote rm origin                        # 删除远程仓库
git remote add origin [url]                 # 添加远程仓库
```

### 3. 克隆远程仓库
```bash
git clone git@github.com:helloworldff/wuxiang.git
# 远程仓库默认名为origin，可通过 git remote -v 查看
```

## 分支管理
> 通常，合并分支时Git会使用Fast forward模式，但这种模式下删除分支后会丢掉分支信息。使用`--no-ff`参数可以保留分支历史信息。

### 1. 分支操作命令
```bash
git checkout -b backup          # 创建并切换到backup分支
git branch backup              # 创建分支
git branch -d backup           # 删除分支
git checkout backup            # 切换到backup分支
git merge backup               # 将backup分支合并到当前分支
git merge --no-ff -m "merge with no-ff" backup  # 禁用Fast forward模式合并
```

### 2. 查看分支信息
```bash
git branch                     # 查看分支列表
git log --graph --pretty=oneline --abbrev-commit  # 查看分支合并情况
```

## 标签管理
```bash
# 标签操作
git tag 版本号                  # 为当前分支添加标签
git tag                        # 查看所有标签
git tag -d 标签名               # 删除本地标签

# 查看提交历史
git log --pretty=oneline --abbrev-commit  # 查看commit id以添加历史标签

# 推送标签
git push origin <tagname>      # 推送指定标签到远程
git push origin --tags         # 推送所有本地标签
git push origin :refs/tags/<tagname>  # 删除远程标签
```

## 其他功能
### 1. 忽略特殊文件
- 在`.gitignore`文件中添加要忽略的文件规则

### 2. 常见提交流程
```bash
git add .
git commit -m "提交说明"
git remote add origin 远端仓库    # 首次连接远程仓库
git push -u origin master
```

### 3. 解决合并冲突
当出现"Your local changes to the following files would be overwritten by merge"时：
```bash
git reset --hard               # 重置工作区
git pull                       # 拉取远程更新
```

