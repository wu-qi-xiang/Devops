## k8s优化：

1. 设置request，limit（优先级高的pod设置1:1，其他1.5:1），LimitRange（设置pod的限制上限），ResourceQuota(ns的资源限制)
2. 根据业务的重要性设置优先级。调度优先级设置proirityclass绑定pod，设置qos优先级。
3. 设置存活指针，就绪指针，启动探针--用于启动慢的镜像，退出前钩---用于优雅退出业务，用在更新应用的时候。
4. 设置pod亲和性和反亲和性，相同的pod副本设置反亲和性，按需设置节点亲和性。
5. 设置hpa，云服务设置hpa+ca
6. 设置停止前钩子，prestop。

dockerfile的优化：

1. 减少镜像层，尽量将命令放在一个RUN里面
2. 复制文件，优先使用COPY, ADD会自动解压。
3. 指定镜像标签，不用使用lastest
4. dockerfile中将修改层放在最下面，静态层放在上面

## k8s现实问题：

1. 业务更新时,怎么样不中断业务更新服务
   在prestop设置一个休眠时间，保证在删除pod之后，完成业务。
2. 服务未启动，就有业务进来。影响服务中断
   新增就绪指针，等服务启动之后才提供服务。启动很慢的话，设置一个prestart，给服务启动。
3. Pod显示自己的资源状态
   原因：cgroup的资源隔离，没有做到对/proc和/sys文件系统的资源视图隔离
   lxcfs实现方式：1. yaml文件中挂载/var/lib/lxcfs/proc等一系列文件，不推荐
   2. 通过webhook实现，参考https://github.com/hantmac/lxcfs-admission-webhook
4. 热更新configmap文件

   1. 使用configmap-reload sidecar容器，观察configmap的变化，然后进行滚动升级。----业务热更新
5. K8s的DNS不通

   1. 先执行 nslookup kubernetes.default 解析是否正常
   2. 检查是svc地址是否正常
   3. 检查endpoints，查看iptables规则
   4. 检查DNS的模式，是否为dnsPolicy=ClusterFirst

## K8s面试：

1. kube-proxy的作用
   kube-proxy运行在所有节点上，它监听apiserver中service和endpoint的变化情况，创建路由规则以提供服务IP和负载均衡功能。
   简单理解此进程是Service的透明代理兼负载均衡器，其核心功能是将到某个Service的访问请求通过nat转发到后端的多个Pod实例上
   iptables模式原理:
   iptables作为kube-proxy的默认模式，其核心：通过APIServer的Watch接口实时跟踪Service与Endpoint的变更信息，然后更新对应的iptables规则，Client的请求流量则通过iptables的NAT机制“直接路由”到目标Pod。
   ipvs模式的原理:
   ipvs模式，访问k8s的service请求会根据clusterip转发到后端的pod.
   当创建一个service时，kubernetes会在每个节点创建一个虚拟网卡，同时会将clusterip绑上，kube-proxy依然会通过APIServer的Watch接口实时监听service和endpoint的变化，然后通过netlink更新对应的ipvs规则,最后通过ipvs规则到后端的pod上。
2. 简述Kubernetes创建一个Pod的主要流程
   创建流程：

   1. 客户端提交Pod的配置信息到kube-apiserver。
   2. Apiserver收到指令后，通知给controller-manager创建一个资源对象。
   3. Controller-manager通过api-server将Pod的配置信息存储到etcd数据中心。
   4. Kube-scheduler检测到Pod信息会开始调度预选，会先过滤掉不符合Pod资源配置要求的节点，然后开始调度调优，主要是挑选出更适合运行Pod的节点，然后将Pod的资源配置单发送到Node节点上的kubelet组件上。
   5. Kubelet根据scheduler发来的资源配置单运行Pod，运行成功后，将Pod的运行信息返回给scheduler，scheduler将返回的Pod运行状况的信息存储到etcd数据中心。

   删除一个pod的主要流程
   Kube-apiserver会接受到用户的删除指令，默认有30秒时间等待优雅退出，超过30秒会被标记为死亡状态
   删除流程：

   1. 将pod从service的endpoint列表中移除
   2. 如果定义了停止前钩子，会执行优雅的停止容器服务
   3. 进程被发送TERM信号（kill -14）
   4. 当超过优雅退出的时间后，Pod中的所有进程都会被发送SIGKILL信号（kill -9）
3. Kubernetes Pod的LivenessProbe探针的常见方式

   * LivenessProbe探针：
     用于判断容器是否存活（running状态），如果LivenessProbe探针探测到容器不健康，则kubelet将杀掉该容器，并根据容器的重启策略做相应处理。若一个容器不包含LivenessProbe探针，kubelet认为该容器的LivenessProbe探针返回值用于是“Success”。
   * ReadnessProbe探针：
     用于判断容器是否启动完成（ready状态）。如果ReadinessProbe探针探测到失败，则Pod的状态将被修改。Endpoint Controller将从Service的Endpoint中删除包含该容器所在Pod的Eenpoint。
   * startupProbe探针：
     启动检查机制，应用一些启动缓慢的业务，避免业务长时间启动而被上面两类探针kill掉
4. Kubernetes外部如何访问集群内的服务
   hostport方式：映射Pod到物理机，将Pod端口号映射到宿主机，即在Pod中采用hostPort方式，以使客户端应用能够通过物理机访问容器应用。
   nodport方式：映射Service到物理机，将Service端口号映射到宿主机，即在Service中采用nodePort方式，以使客户端应用能够通过物理机访问容器应用。
   loadbalancer方式：映射Sercie到LoadBalancer，通过设置LoadBalancer映射到云服务商提供的LoadBalancer地址。这种用法仅用于在公有云服务提供商的云平台上设置Service的场景。
   ingress方式：使用了Ingress策略和Ingress Controller，两者结合并实现了一个完整的Ingress负载均衡器
5. 简述Kubernetes Pod的常见调度方式
   NodeSelector：定向调度，当需要手动指定将Pod调度到特定Node上，可以通过Node的标签（Label）和Pod的nodeSelector属性相匹配。
   NodeAffinity亲和性调度：亲和性调度机制极大的扩展了Pod的调度能力，目前有两种节点亲和力表达：
   requiredDuringSchedulingIgnoredDuringExecution：硬规则，必须满足指定的规则，调度器才可以调度Pod至Node上（类似nodeSelector，语法不同）。
   preferredDuringSchedulingIgnoredDuringExecution：软规则，优先调度至满足的Node的节点，但不强求，多个优先级规则还可以设置权重值。
   Taints和Tolerations（污点和容忍）：
   Taint：使Node拒绝特定Pod运行；
   Toleration：为Pod的属性，表示Pod能容忍（运行）标注了Taint的Node。
6. 简述loadbalance
   LoadBalancer：使用外接负载均衡器完成到服务的负载分发，loadBalancer字段指定外部负载均衡器的IP地址，通常在公有云使用。
   Service负载分发的策略有：RoundRobin和SessionAffinity
   RoundRobin：默认为轮询模式，即轮询将请求转发到后端的各个Pod上。
   SessionAffinity：基于客户端IP地址进行会话保持的模式，即第1次将某个客户端发起的请求转发到后端的某个Pod上，之后从相同的客户端发起的请求都将被转发到后端相同的Pod上。
7. Scheduler调度pod的算法
   预选（Predicates）：过滤掉不满足策略的节点，如资源不足
   优选（Priorities）：对预选之后的节点进行打分，然后根据资源，负载对节点进行打分，选择最高分进行调度
8. 简述CNI网络接口模型
   CNI仅关注在创建容器时分配网络资源，和在销毁容器时删除网络资源。在CNI模型中只涉及两个概念：容器和网络.
   CNI Plugin负责为容器配置网络资源，IPAM Plugin负责对容器的IP地址进行分配和管理
9. k8s的网络插件详解
   CNI：实现2个方法
   ADD--把容器添加到CNI网络(绑定veth pair虚拟网卡对，添加路由)
   DEL--从CNI网络里面删除容器
   二层网络：仅仅是通过mac地址即可实现通信
   三层网络：需要通过主机IP路由实现跨网段的通信
10. flannel: 后端实现模式---VXlan(优先), UDP(约束  docker0地址在flannel子网内), host-gw
    flannel会对数据包进行封装和解包操作，完成数据包的跨主机通信，类似于虚拟出了一个隧道通信。

    * UDP模式：
      跨节点流量的网络走向，pod发起请求---(通过veth pair到)docker0网桥---(路由到)flannel0 tun设备---
      (流量通过内核态到用户态，实现流量的封装，修改源目地址)flanneld进程---(流量通过用户态到内核态)宿主机eth0---
      (宿主机路由)对端eth0---(解包)对端flanneld进程---(同之前步骤)对端flannel0---对端docker0---对端pod
    * VXlan模式：
      流量的网络走向同UDP模式，封装流量包使用的是VTEP设备flannel.1，减少了用户态和内核态的转换，提高了效率。
    * host-gw模式：
      流量的网络走向，使用的宿主机网络，主机的路由表自动写入目的pod所在节点的ip，路由信息存在etcd中，Pod发起请求---docker0---(虚拟网卡对veth pair)eth0---(宿主机的路由表的下一跳)对端eth0---对端docker0

   calico: IPIP，BGP
   Calico在每个计算节点都利用Linux Kernel实现了一个高效的vRouter来负责数据转发。每个vRouter都通过BGP协议把在本节点上运行的容器的路由信息向整个Calico网络广播，并自动设置到达其他节点的路由转发规则。
   组件：felix---插入路由规则，bird---分发路由信息，BGP---边界路由，收集所有的路由信息，添加到每个主机的路由表

* IPIP模式：
  Pod发起请求---docker0---(封包)tunl0---eth0---对端eth0---(解包)tunl0---对端docker0，适用于小的集群环境。
  需要封装包，假装是eth0到eth0的数据包，效率低
* BGP模式：
  Pod发起请求---docker0---eth0---BGP路由器1---BGP路由器1----对端eth0---(解包)tunl0---对端docker0
  通过BGP协议，同步主机路由信息同步到本地的路由表中，实现跨自己直接的通信，效率高

11. K8s的CSI模型
    Kubernetes CSI是Kubernetes推出与容器对接的存储接口标准
    CSI包括CSI Controller和CSI Node：
    CSI Controller的主要功能是提供存储服务视角对存储资源和存储卷进行管理和操作，实现存储attach到节点
    CSI Node的主要功能是对主机（Node）上的Volume进行管理和操作，实现存储mount到目录
    存储挂载流程: 后端远程存储---(CSI Controller实现)attach到对应的node节点上---(CSI node实现)mount到节点的对应目录---挂载到容器的目录
12. 控制器：
    功能：让status变成spec
    实现：控制器---通过watch机制---获取spc值，对比spec和status的差异---调用add, update, delete方法---实现status==spec
