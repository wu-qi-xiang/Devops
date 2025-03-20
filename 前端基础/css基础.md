# CSS3 基础知识

## 基础属性

1. **按钮圆角**
   - 使用 `border-radius` 属性创建圆角

2. **盒阴影**
   ```css
   box-shadow: 10px 10px 5px #888888;
   ```

3. **边界图片**
   - `border-image` 属性允许指定图片作为边框

## 背景相关

4. **背景图片**
   - `background-image` 属性添加背景图片

5. **背景图片大小**
   - `background-size` 指定背景图像的大小

6. **背景图片位置**
   - `background-Origin` 属性指定背景图像的位置区域

## 渐变效果

7. **线性渐变**
   - `background-image: linear-gradient()`

8. **径向渐变**
   - `background-image: radial-gradient()`

## 阴影效果

9. **文本阴影**
   - `text-shadow` 属性适用于文本阴影

10. **盒子阴影**
    - `box-shadow` 属性适用于盒子阴影

## 字体设置

11. **自定义字体**
    - `@font-face` 选择字体

## 2D转换

12. **2D变换方法**
    - `translate()`: 根据X轴和Y轴位置参数移动元素
    - `rotate()`: 顺/逆时针旋转元素
    - `scale()`: 缩放元素大小
    - `transform:skew()`: X轴和Y轴倾斜角度

## 3D转换

13. **3D旋转**
    - `rotateX()`: X轴旋转
    - `rotateY()`: Y轴旋转

## 过渡效果

14. **CSS3过渡**
    ```css
    .first {
        transition: width 2s, height 2s, transform 2s;
        -webkit-transition: width 2s; /* Safari */
    }

    .first:hover {
        width: 300px;
        transform: rotate(360deg);
    }
    ```

## 动画效果

15. **CSS3动画**
    - `@keyframes` 规则创建动画
    - 需指定动画名称和时长

    ```css
    @keyframes myfirst {
        from {background: red;}
        to {background: yellow;}
    }

    .first {
        animation: myfirst 5s;
    }
    ```

## 布局特性

16. **多列布局**
    - `column-count`: 指定列数，用于分页

17. **弹性盒子**
    - `display: flex`

## 响应式设计

18. **多设备兼容性**
    ```css
    @media screen and (min-width: 1001px) {
        /* 样式规则 */
    }
    ```