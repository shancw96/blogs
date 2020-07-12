---
title: throw new Error 与 throw someObj 的区别在哪？
categories: [js]
tags: [js类型]
toc: true
date: 2020/7/12
---

[stackoverflow: throw obj 与 throw new Error 区别](https://stackoverflow.com/questions/9156176/what-is-the-difference-between-throw-new-error-and-throw-someobject)

## Error Object

Error 对象有两个属性：name, message

- name: Error 的构造函数名称
- message: 错误信息

### Error 的构造函数列表

| name           | description         |
| -------------- | ------------------- |
| EvalError      | eval()方法执行出错  |
| RangeError     | number 超出有效范围 |
| ReferenceError | 引用错误            |
| SyntaxError    | 语法错误            |
| TypeError      | 类型错误            |
| URIError       | url 转换错误        |

## 总结

- throw someObj/someStr 属于自定义错误，比较灵活，
- throw new `[[constructor]]`则会返回上面列举的对应错误类型，更加规范
