---
title: interview - 浏览器/css
categories: [interview]
toc: true
---

## opacity:none, visibility:hidden, display:none 区别

### 继承

- opacity 和 display:none 是 非继承属性。
- visibility 是继承属性，子元素可以覆写

### 性能

display:none : 修改元素会造成文档回流
visibility, opacity 只会导致重绘
