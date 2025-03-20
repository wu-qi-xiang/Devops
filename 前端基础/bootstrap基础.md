# Bootstrap 基础

## 基础单位
- `px`：像素
- `em`：继承父元素的字体大小
- `rem`：继承根元素的字体大小

## 排版

### 1. 标题和副标题
- 标题：使用`h1`标签
- 副标题：使用`small`标签

### 2. 文本样式
基本文本标签：
- `p`：段落标签
- `del`：删除线
- `mark`：标记
- `strong`/`b`：加粗
- `i`/`em`：斜体
- `text-center`：居中文本

#### 字体颜色类
- `text-muted`：提示，浅灰色（#999）
- `text-primary`：主要，蓝色（#428bca）
- `text-success`：成功，浅绿色（#3c763d）
- `text-info`：通知信息，浅蓝色（#31708f）
- `text-warning`：警告，黄色（#8a6d3b）
- `text-danger`：危险，褐色（#a94442）

#### 文本对齐
- `text-left`：左对齐
- `text-center`：居中对齐
- `text-right`：右对齐
- `text-justify`：两端对齐

#### 列表样式
1. 无序列表
   - `ul`，`li`：基本无序列表
   - `list-unstyled`：去掉无序列表的点
   - `list-inline`：水平列表

2. 有序列表
   - `ol`，`li`：基本有序列表

3. 定义列表
   - `dl`，`dt`，`dd`：定义列表
   - `dl-horizontal`：水平定义列表（屏幕>768px）

#### 代码显示
- `code`：单行内联代码
- `pre`：多行块代码
  - `pre-scrollable`：高于340px时显示Y轴滚动条
- `kbd`：用户输入代码

## 3. 表格
基础表格使用`table`标签，包含：
- `thead`，`th`：表头
- `tr`：行
- `td`：列

表格样式类：
- `table-bordered`：带边框
- `table-striped`：斑马线样式
- `table-hover`：鼠标悬停高亮
- `table-condensed`：紧凑型
- `table-responsive`：响应式（<768px时显示水平滚动条）

表格状态类：`active`，`success`，`info`，`warning`，`danger`

## 4. 表单
基础表单使用`form`标签（默认垂直显示）

表单样式：
- `form-horizontal`：水平表单
- `form-inline`：内联表单

### 表单控件
1. 输入框
   - `input`：基本输入标签
   - `form-control`：表单样式
   - `placeholder`：提示文本
   - 类型：`email`，`text`，`checkbox`，`radio`

2. 控件大小
   - `input-sm`：小号控件
   - `input-lg`：大号控件

3. 表单状态
   - `has-warning`：警告（黄色）
   - `has-error`：错误（红色）
   - `has-success`：成功（绿色）

4. 其他元素
   - `help-block`：提示信息
   - `form-group`：表单组（防止跨行）
   - `select`：下拉选择框
   - `textarea`：文本域

### 按钮
- 基本：`button`，`btn`
- 颜色：`btn-success`等
- 样式：
  - `btn-block`：块状按钮
  - `btn-group`：按钮组
  - `btn-toolbar`：按钮工具栏

### 图片
- `img-responsive`：响应式图片
- 样式类：
  - `img-rounded`：圆角
  - `img-circle`：圆形
  - `img-thumbnail`：缩略图

图标：[Bootstrap Glyphicons](https://www.runoob.com/try/demo_source/bootstrap-glyph-customization.htm)

## 5. 网格系统
- `container`：容器
- `row`：行（必须在container中）
- `column`：列（默认12列）

响应式类：
- `col-xs-*`：<750px
- `col-sm-*`：≥750px
- `col-md-*`：≥970px
- `col-lg-*`：≥1170px

列偏移：
- `col-md-offset-*`：右移
- `col-md-push-*`：向右偏移
- `col-md-pull-*`：向左偏移

## 6. 下拉菜单
```html
<div class="dropdown">
    <button data-toggle="dropdown">
        菜单 <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
        <li><a href="#">选项1</a></li>
    </ul>
</div>
```

按钮组：
- `btn-group`：基本按钮组
- `btn-group-vertical`：垂直分组
- `btn-group-justified`：等分按钮

## 7. 导航
基本结构：`div > ul > li`

导航样式：
- `nav`，`nav-tabs`，`nav-pills`：基本导航
- `nav-stacked`：垂直导航
- `nav-divider`：分隔线
- `nav-justified`：自适应
- `breadcrumb`：面包屑导航

## 8. 导航条
响应式导航条结构：
```html
<div class="navbar navbar-default">
    <ul class="nav navbar-nav">
        <li><a href="#">链接</a></li>
    </ul>
</div>
```

导航条样式：
- `navbar-fixed-top`：固定顶部（需要body添加padding-top: 70px）
- `navbar-header`，`navbar-brand`：导航条标题
- `navbar-form`，`navbar-left`：导航搜索表单

分页导航：
- `pagination`：分页导航条
- `pager`：上下翻页
  - `previous`：上一页
  - `next`：下一页

其他元素：
- `label`：标签
- `badge`：徽章

## 其他功能
1. 移动端适配
   - meta viewport设置
   - 响应式栅格布局

2. 组件系统
   - 字体
   - 图像
   - 下拉菜单
   - 控件
   - 导航
   - 分页
   - 列表
   - 插件