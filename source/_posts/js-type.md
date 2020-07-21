---
title: js-类型
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
- `Number.MIN_SAFE_INTERGER`:最小安全整数 -2^53 - 1

* `Number.POSITIVE_INFINITY:` 对应 Infinity 代表正无穷
* `Number.EPSILON`：是一个极小的值，用于检测带小数的数值计算结果是否在误差范围内
* `Number.NaN`：表示非数字，NaN 与任何值都不相等，包括 NaN 本身
* `Infinity`：表示无穷大，分 正无穷 Infinity 和 负无穷 -Infinity

## 为什么 0.1 + 0.2 !== 0.3 ? 在开发中要怎么去解决

> (十进制的 0.1 为什么不能用二进制很好的表示？)[https://www.cnblogs.com/fandong90/p/5397260.html#undefined]

JavaScript 的 Number 类型为双精度 IEEE 754 64 位浮点类型。
对于 0.1 + 0.2 的计算结果：首先将 0.1, 0.2 分别转换成 2 进制，在进行相加，将得到的二进制结果转成 10 进制

> 由于 **0.1 转换成 2 进制会出现无限循环**，但是尾数最多只能保存 53 位，所以只能近似值，此处就产生了误差。

### 比较浮点数的正确方式:

```js
function floatJudge(num1, num2, target) {
  return Math.abs(num1 - num2) - target < Math.EPSILON;
}
```

### 浮点数计算

[number-precision 小数计算辅助库](https://github.com/nefe/number-precision)
对于运算类操作，如 +-\*/，就不能使用 toPrecision 了。正确的做法是把小数转成整数后再运算。以加法为例：
原理：

```js
/**
 * 精确加法
 */
function add(num1, num2) {
  const num1Digits = (num1.toString().split(".")[1] || "").length;
  const num2Digits = (num2.toString().split(".")[1] || "").length;
  const baseNum = Math.pow(10, Math.max(num1Digits, num2Digits)); // 10 * 小数位数
  return (num1 * baseNum + num2 * baseNum) / baseNum;
}
```

### 浮点数展示

Number.prototype.toPrecision 方法可以对精度进行限制，而不会四舍五入

```js
(1.3333333).toPrecision(1); // -> "1"
(1.3333333).toPrecision(2); // -> "1.3"

// 如果某些组件需要数字类型,则加上parseFloat
parseFloat((1.4000000000000001).toPrecision(12)) === 1.4; // True
```

# 装箱转换 （基本类型 -> 对应的对象)

> `.`运算符提供了装箱操作，它会根据基础类型构造一个临时对象，使得我们能在基础类型上调用对应对象的方法

每一类装箱对象皆有私有的 Class 属性，这些属性可以用 Object.prototype.toString 获取：

```js
const arr = [];
Object.prototype.toString.call(type_data); // [Object Array]
```

## 为什么 Array String Number Boolean RegExp Date 不能直接调用 toString ? `xxx.toString`

上述几种对象对 toString 进行了重写，由于自身原型链上存在 toString 就不会继续向上查找 toString,所以达不到预期效果

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

ES6 可以显式指定 `toPrimitive Symbol` 来覆盖原有的**拆箱**行为

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
