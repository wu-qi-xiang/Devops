# Prometheus 基础

## 学习资源
[Prometheus 中文文档](https://www.prometheus.wang/alert/prometheus-alert-rule.html)

## PromQL 查询语言

### 基本格式
```
<metric name>{<label name>=<label value>, ...}
```

示例：
```
api_http_requests_total{method="POST", handler="/messages"}
```

### 指标类型
Prometheus 定义了4种不同的指标类型（metric type）：

- **Counter（计数器）**：只增不减的计数器
- **Gauge（仪表盘）**：可增可减的仪表盘
- **Histogram（直方图）**：用于统计和分析样本的分布情况
- **Summary（摘要）**：用于统计和分析样本的分布情况

### 查询时间序列

#### 完全匹配模式
PromQL 支持使用 `=` 和 `!=` 两种完全匹配模式：
- 使用 `label=value` 选择标签满足表达式定义的时间序列
- 使用 `label!=value` 排除标签匹配的时间序列

#### 正则表达式匹配
PromQL 支持使用正则表达式作为匹配条件，多个表达式之间使用 `|` 分隔：
- 使用 `label=~regx` 选择标签符合正则表达式的时间序列
- 使用 `label!~regx` 排除匹配的时间序列

### 范围查询
时间范围通过时间范围选择器 `[]` 进行定义。

示例：
```
http_request_total{}[5m]
```

### 时间位移操作
位移操作使用关键字 `offset`。

示例：
```
http_request_total{} offset 5m
```

### 聚合操作
示例：
```
sum(http_request_total)
```

### 运算符

#### 数学运算符
- `+` (加法)
- `-` (减法)
- `*` (乘法)
- `/` (除法)
- `%` (求余)
- `^` (幂运算)

#### 布尔运算符
- `==` (相等)
- `!=` (不相等)
- `>` (大于)
- `<` (小于)
- `>=` (大于等于)
- `<=` (小于等于)

使用 `bool` 修饰符改变布尔运算符的行为。

示例：
```
http_requests_total > bool 1000  # 大于1000返回true
```

#### 集合运算符
- `and` (并且)
- `or` (或者)
- `unless` (排除)

### 聚合操作函数
- `sum` (求和)
- `min` (最小值)
- `max` (最大值)
- `avg` (平均值)
- `stddev` (标准差)
- `stdvar` (标准差异)
- `count` (计数)
- `count_values` (对value进行计数)
- `bottomk` (后n条时序)
- `topk` (前n条时序)
- `quantile` (分布统计)

语法：
```
<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)]
```

示例：
```
sum(http_requests_total) without (instance)
count_values("count", http_requests_total)
```

注意：只有 `count_values`、`quantile`、`topk`、`bottomk` 支持参数。

### 内置函数
- `increase`：计算增长量
- `rate`：计算增长速率
- 更多函数请参考官方文档

## Prometheus 告警
告警能力在 Prometheus 的架构中被划分成两个独立的部分：
1. 通过在 Prometheus 中定义 AlertRule（告警规则）
2. Prometheus 会周期性地对告警规则进行计算，如果满足告警触发条件就会向 Alertmanager 发送告警信息

## Exporter
Prometheus 提供监控样本数据的程序都可以被称为一个 Exporter，Exporter 的一个实例称为 target。

### Exporter 类型
1. 独立使用的官方提供的 exporter
2. 集成到应用中的 exporter

官方提供了丰富的 exporter 生态系统。
					