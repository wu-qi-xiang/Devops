# JavaScript基础知识

## 一、JS在HTML中的引用
1. 在HTML中插入JS：
```html
<script type="text/JavaScript"></script>
```
2. 在HTML中引入JS文件：
```html
<script src="script.js"></script>
```

## 二、基础知识
1. 定义变量：`var variable;`
2. 定义函数：
```javascript
function name() {
    code;
}
```
3. 输出到浏览器：`document.write(str);`
4. 消息对话框（onclick确定按钮）：
   - `alert(str);`
   - `confirm(str);`
   - `prompt(str1, str2);`
5. 打开新的窗口：
   - `window.open([URL], [窗口名称], [参数字符串])`
   - `window.close();`
6. 通过id获取HTML元素：`document.getElementById("id")`
   - 改变HTML样式：`style.(color|background|width)`
7. 调试使用F12，输入`console.log`输出调试
8. `document.getElementById()`：查找HTML中的id

## 三、JS事件
示例：
```html
<button onclick="displayDate()">现在的时间是？</button>
<script>
function displayDate() {
    document.getElementById("time").innerHTML = Date();
}
</script>
```

常用事件：
1. 鼠标单击事件(`onclick`)：`function a() { } ... onclick="a()"`
2. 鼠标经过事件(`onmouseover`)：`function a() { } ... onmouseover="a()"`
3. 鼠标移开事件(`onmouseout`)：`function a() { } ... onmouseout="a()"`
4. 光标聚焦事件(`onfocus`)：`function a() { } ... onfocus="a()"`
5. 失焦事件(`onblur`)：`function a() { } ... onblur="a()"`
6. 内容选中事件(`onselect`)：`function a() { } ... onselect="a()"`
7. 文本框内容改变事件(`onchange`)：`function a() { } ... onchange="a()"`
8. 加载事件(`onload`)：`function a() { } ... onload="a()"`
9. 卸载事件(`onunload`)：`function a() { } ... onunload="a()"`

![事件示例](./images/image.pngs)

button的onclick指定JS的函数调用。

## 四、函数和对象
```javascript
// 函数定义
function name(parameter1, parameter2) {
    // 函数体
}

// 对象定义
var person = {
    height: 18,
    weight: 120,
    name: "hanhan"
};

// 调用对象属性
person.height
```

## 五、字符串方法
1. 查找字符：
   - `indexOf(string, position)`
   - `lastIndexOf()`
   - `search()`
   - `string[index]`
2. 截取字符串：
   - `slice(start, end)`
   - `substring()`
   - `substr()`
3. 替换字符：`replace(/string/ig, "new string")`
4. 大小写转换：
   - `toUpperCase()`
   - `toLowerCase()`
5. 字符串连接：
   - `string.concat(string1, string2)`
   - 使用`+`运算符
6. 根据索引查字符串的值：
   - `charAt(index)`
   - `charCodeAt()`：返回ASCII码

## 六、数组
数组定义：
```javascript
var car = ["宝马", "奔驰", "别克"]
```

数组常用方法：
- 基本属性和方法：
  - `length`：数组长度
  - `sort()`：排序
  - `push()`：添加元素
  - `typeof`：类型检查

- 数组转换：
  - `toString()`：将数组转换为字符串
  - `join()`：结合数组为字符串

- 元素操作：
  - `pop()`：删除最后一个元素
  - `shift()`：删除第一个元素
  - `push()`：在最后添加元素
  - `unshift()`：在开头添加元素
  - `splice(2, 1, 'wiki')`：在index为2处添加新元素wiki，同时删除1个元素

- 数组操作：
  - `concat()`：合并数组
  - `slice(1, 4)`：裁剪数组
  - `sort()`：排序（不适用于数值排序）
  - `sort(function(a, b){return a - b})`：数值排序
  - `reverse()`：反转数组

- 数组遍历和处理：
  - `forEach(value, index, array)`：遍历数组
  - `map(value, index, array)`：处理元素返回新数组
  - `filter(value, index, array)`：过滤元素
  - `reduce(total, value, index, array)`：累积处理
  - `every(value, index, array)`：检查所有元素
  - `some(value, index, array)`：检查某个元素

- 查找方法：
  - `indexOf()`：查找第一个匹配元素
  - `lastIndexOf()`：查找最后一个匹配元素
  - `find(value, index, array)`：返回第一个匹配值
  - `findIndex()`：返回第一个匹配索引

## 七、数学方法
- `Math.round(x)`：四舍五入
- `Math.pow(x, y)`：x的y次幂
- `Math.sqrt(x)`：平方根
- `Math.abs(x)`：绝对值
- `Math.ceil(x)`：向上取整
- `Math.floor(x)`：向下取整
- `Math.min()`和`Math.max()`：最小值和最大值
- `Math.random()`：生成0到1之间的随机数

## 八、数值比较
- `==`：数值相等
- `===`：数值和类型相等

注意：字符串与数字比较时，JavaScript会将字符串转换为数值：
- 空字符串转换为0
- 非数值字符串转换为NaN

## 九、数据类型
- `typeof`：查看数据类型
- `constructor`：返回构造器函数
- 转换方法：`toString()`, `String(Date())`, `Date().toString()`, `Number()`

五种可包含值的数据类型：
- 字符串（string）
- 数字（number）
- 布尔（boolean）
- 对象（object）
- 函数（function）

三种对象类型：
- 对象（Object）
- 日期（Date）
- 数组（Array）

两种不能包含值的数据类型：
- `null`
- `undefined`

## 十、正则表达式
示例：
- 表达式：`[abc]`, `[0-9]`, `(x|y)`
- 修饰符：`i`, `g`, `m`
- 元字符：
  - `\d`：数字
  - `\s`：空白字符
  - `\b`：单词边界

方法：
- `test()`：匹配字符，返回true
- `exec()`：返回匹配到的字符

## 十一、JavaScript的调试
1. `console.log()`：控制台输出
2. 设置断点，代码中可以使用`debugger`



