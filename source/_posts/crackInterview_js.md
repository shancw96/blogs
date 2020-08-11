---
title: js 常见问题汇总
categories: [interview]
tags: [js]
toc: true
date: 2020/8/10
---

# 01 请简单说一下 `['1', '2', '3', '4', '5'].map(parseInt)`的结果

## 结果

```js
parseInt("1", 0); // 1
parseInt("2", 1); // 二进制不能解析3
parseInt("3", 2); // 二进制不能解析3
parseInt("10", 3); // 1*3^1 + 0*3^0 = 3
parseInt("10", 4); // 1*4^1 + 0*3^0 = 4
```

## parseInt 语法

```js
parseInt(string, radix); // 将radix进制的string 转换为10进制Int
```

如果第一个字符不能转换为 radix 对应的数字，parseInt 会返回 NaN

### parameter

- string 要解析的字符串，如果参数不是字符串，则调用 toString 将其转换为字符串
- radix（可选）从 2 - 36 指定字符串的进制

## 特殊处理

### radix 不在指定范围内

- radix 是 undefined， 0 或者未指定
  - 如果 string 以 0x 开头，那么 radix 被假定为 16
  - 如果 string 以 0 开头，radix 被假定为 8 进制或 10 进制，**ES5 建议使用 10 进制**，但并不是所有浏览器都支持，所以推荐在使用 parseInt 的时候显示指定 radix
  - 如果输入的 String 以任何其他的值开头，radix 是 10 进制

# 02 请实现一下防抖和节流

## 防抖函数

防抖函数借助 closure 来保存 timeout。这也是为什么 debounce 要写成 `myDebounce: debounce(...)`这种格式。

> myDebounce 在初始化的时候执行 function debounce 返回一个匿名函数，匿名函数的作用域链携带了 timeout

这个匿名函数的作用域链如下

```js
------global
...
    ------ debounce
	  timeout
	  ....
	  --------- 返回的匿名函数
```

### 代码实现

```js
function debounce(func, wait) {
  let timeout = null;
  return function () {
      const args = arguments;
      clearTimeout(timeout)
      timeout = setTimeout(() => {
	// 为了确保上下文环境为当前的this，不能直接用fn。
        func.apply(this, args)
      }, wait);
  }
}
export default {
...
  methods: {
    debounce: debounce(function() {
      this.count += 1;
    }, 500),
  },
};
```

## 节流函数

原理与 防抖函数相同，通过存储时间戳来记录上次调用函数的时间

### 代码实现

```js
// 只有当上一次调用的时间 与 现在时间的差值 超过了设定的时间 才会再次调用
function throttle(func, interval) {
  let lastTimeStamp = 0;
  return function () {
    let curDate = Date.now();
    const diff = curDate - lastTimeStamp;
    if (diff > interval) {
      func.apply(this, arguments);
      lastTimeStamp = curDate;
    }
  };
}
```
