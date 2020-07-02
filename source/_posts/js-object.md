---
title: 重学前端-js-对象
categories: [js]
tags: [js对象]
toc: true
date: 2020/6/30
---

# JS 对象分类

- 宿主对象(host Object)：如浏览器等

- 内置对象(Built-in Object)：JS 语言提供

- 固有对象(Intrinsic Object) ：由标准规定，随 JS 运行而自动创建对象实例

| 固有对象 | 基本功能和数据结构 | 错误类型       | 二进制操作        | 带类型的数组      |
| -------- | ------------------ | -------------- | ----------------- | ----------------- |
| Boolean  | Array              | Error          | ArrayBuffer       | Float32Array      |
| Number   | Date               | EvalError      | SharedArrayBuffer | Float64Array      |
| Symbol   | RegExp             | RangeError     | DateView          | Int8Array         |
| Object   | Promise            | ReferenceError |                   | Int16Array        |
|          | Proxy              | SyntaxError    |                   | Int32Array        |
|          | Map                | TypeError      |                   | UInt18Array       |
|          | WeakMap            | URIError       |                   | UInt32Array       |
|          | Set                |                |                   | UInt8ClampedArray |
|          | WeakSet            |                |                   |                   |
|          | Function           |                |                   |                   |

通过这些构造器，通过 new 能够生成对应的对象

- Array(8) 与 new Array(8)
  > stackoverflow: [When Array is called as a function rather than as a constructor, it creates and initialises a new Array object. Thus the function call Array(…) is equivalent to the object creation expression new Array(…) with the same arguments.](https://stackoverflow.com/questions/8205691/array-vs-new-array)
- new Date() 与 Date()
  MDN:[创建一个新 Date 对象的唯一方法是通过 new 操作符，例如：let now = new Date();若将它作为常规函数调用（即不加 new 操作符），将返回一个字符串，而非 Date 对象。 ](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Date)
- Function 与 =>
  在 ES6 之后 => 语法创建的函数仅仅是函数，它们无法被当作构造器使用，见以下代码：
  ```js
  new ((a) => 0)(); // error
  ```

### **原生对象(Native Object)**：可以由用户通过 Array、RegExp 等内置构造器或者特殊语法创建的对象。

## 普通对象(Ordinary Object)：用户自己定义
