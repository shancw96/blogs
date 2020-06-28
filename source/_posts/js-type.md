---
title: 重学前端-js-类型
categories: [js]
tags: [js类型]
toc: true
date: 2020/6/24
---

# undefined, null

## undefined 的区别

在 js 中 undefined 是变量，因此可以被赋值，从而导致不必要的 bug
在 js 中 null 是关键字，不存在缺陷
因此在开发中，应使用 null 代替 undefined

# Number

## Number 提供的特殊数值：

- `Number.MAX_VALUE`: js 中的最大值
- `Number.MIN_VALUE`: js 中的最小值
- `Number.MAX_SAFE_INTERGER`:最大安全整数 2^53 - 1
- `Number.MIN_SAFE_INTERGER`:最小安全整数

* `Number.POSITIVE_INFINITY:` 对应 Infinity 代表正无穷
* `Number.EPSILON`：是一个极小的值，用于检测计算结果是否在误差范围内
* `Number.NaN`：表示非数字，NaN 与任何值都不相等，包括 NaN 本身
* `Infinity`：表示无穷大，分 正无穷 Infinity 和 负无穷 -Infinity

## 为什么 0.1 + 0.2 !== 0.3 ? 在开发中要怎么去解决

JavaScript 的 Number 类型为双精度 IEEE 754 64 位浮点类型。
对于 0.1 + 0.2 的计算结果：首先将 0.1, 0.2 分别转换成 2 进制，在进行相加，将得到的二进制结果转成 10 进制

> 由于 **0.1 转换成 2 进制会出现无限循环**，但是尾数最多只能保存 53 位，所以只能近似值，此处就产生了误差。

比较浮点数的正确方式:

```js
function floatJudge(num1, num2, target) {
  return Math.abs(num1 - num2) - target < Math.EPSILON;
}
```

## Number 的范围

整数类型范围: -2^53 - 2^53
数字类型范围: 5e-324 - 1.7976931348623157e+308 （可以通过 `Number.MIN_VALUE Number.MAX_VALUE` 获取）

# 装箱转换 （基本类型 -> 对应的对象)

> `.`运算符提供了装箱操作，它会根据基础类型构造一个临时对象，使得我们能在基础类型上调用对应对象的方法

每一类装箱对象皆有私有的 Class 属性，这些属性可以用 Object.prototype.toString 获取：

```js
const arr = [];
Object.prototype.toString.call(type_data); // [Object Array]
```

在 JavaScript 中，没有任何方法可以更改私有的 Class 属性，因此 Object.prototype.toString 是可以准确识别对象对应的基本类型的方法，它比 instanceof 更加准确。

# 拆箱转换（对应的对象 -> 基本类型)

拆箱转换过程: 尝试调用 valueOf 和 toString 方法来获取基本方法。如果 valueOf 和 toStrig 都不存在 则抛出类型错误 TypeError。
例 1 `o*2` ：

```js
const o = {
  valueOf: () => {
    console.log("valueOf");
    return {};
  },
  toString: () => {
    console.log("toString");
    return {};
  },
};

o * 2;

// valueOf
// toString
// TypeofError

String(o);
// toString
// valueOf
// TypeofError
```

ES6 可以显式指定 `toPrimitive Symbol` 来覆盖原有行为

```js
const o = {
  valueOf: () => {
    console.log("valueOf");
    return {};
  },
  toString: () => {
    console.log("toString");
    return {};
  },
};
o[Symbol.toPrimitive] = () => {
  console.log("toPrimitive");
  return "hello";
};

consoel.log(o + "");
// toPrimitive
// hello
```
