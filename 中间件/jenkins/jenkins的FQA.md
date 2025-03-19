# Jenkins常见问题解答（FAQ）

1. **SSH插件无法传输文件失败**
   - 需要在系统配置里面增加主机
   - Over SSH传输文件注意事项：
     - 原路径只能用相对路径，在workspace之后的路径
     - 目的路径也是相对路径，登陆用户的家目录之后的路径  
   ![SSH配置示例](image/image.png)

2. **Jenkins下载代码超时问题**
   - 问题：`.jenkins`大坑，网络慢，gitlab的代码大，导致默认的`timeout=10`超时，下载代码失败
   - 解决：如图在git插件下面增加这个插件：
   ![Git超时配置](image/image-1.png)

3. **脚本发布进程被终止问题**
   - 问题：脚本发布的时候会将新启动进程干掉
   - 解决：在脚本中添加以下配置：
   ```bash
   BUILD_ID=DONTKILLME    #脚本需要加，否则会kill刚刚起的进程
   ```

4. **Git拉取代码失败**
   - 问题：git版本太低
   - 解决：
     1. 全局工具配置 -> Git -> Path to Git executable填写：
        ```bash
        /home/dsm/soft/git/bin/git
        ```
     2. 重新安装新版本的git

5. **Jenkins运行成功但显示失败**
   - 解决：在脚本的最上头增加：
     ```bash
     #!/bin/sh
     ```
   - 原因说明：
     默认情况下，Jenkins采取`/bin/sh -xe`这种方式，`-x`将打印每一个命令。另一个选项`-e`，当任何命令以非零值（当任何命令失败时）退出代码时，这会导致shell立即停止运行脚本。通过添加`#!/bin/sh`将让你执行没有这些选项。

6. **环境变量不对**
   - 解决：在脚本中增加：
     ```bash
     . /etc/profile    #重载配置文件
     ```

7. **SSH插件超时问题**
   - 错误信息：`Exception when publishing, exception message [Exec timed out or was interrupted after 200,002 ms]`
   - 原因：在timeout时间之内，没有完成脚本的操作，导致jenkins连接服务器的伪终端timeout
   - 解决：延长ssh的timeout时间

8. **Jenkins界面空白问题**
   - 问题：jenkins安装完成之后，浏览器打开界面为空白，显示普通用户没有权限
   - 解决：
     1. 访问：`http:192.168.1.246:8088/pluginManager/advanced`
     2. 修改升级站点的地址，将https改为http
     3. 重启jenkins服务
