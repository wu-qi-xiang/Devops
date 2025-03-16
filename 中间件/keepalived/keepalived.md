# Keepalived 技术概述

## VRRP协议简介

**VRRP**（Virtual Router Redundancy Protocol）是虚拟路由冗余协议。该协议的工作机制如下：

- 将多台功能相同的路由器组成一个小组
- 分为一个**master**和多个**backup**节点
- master以组播方式向backup发送VRRP协议数据包
- 当backup未接收到master的数据包时，判定master宕机
- 根据backup的优先级选出新的master

## Keepalived简介

Keepalived采用的就是**VRRP协议**实现高可用。

### 核心模块组成

Keepalived包含三个主要模块：

1. **Core模块**：keepalived的核心模块
   - 作为keepalived的主进程
   - 负责配置文件的加载和解析

2. **Check模块**：
   - 负责健康检查功能
   - 监控服务状态

3. **VRRP模块**：
   - 负责实现VRRP协议
   - 处理节点间的故障转移