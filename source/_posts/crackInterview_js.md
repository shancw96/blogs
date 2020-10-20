---
title: interview - js
categories: [interview]
toc: true
---

## 01 请简单说一下 `['1', '2', '3', '4', '5'].map(parseInt)`的结果

### 结果

```js
parseInt("1", 0); // 1
parseInt("2", 1); // 二进制不能解析3
parseInt("3", 2); // 二进制不能解析3
parseInt("10", 3); // 1*3^1 + 0*3^0 = 3
parseInt("10", 4); // 1*4^1 + 0*3^0 = 4
```

### parseInt 语法

```js
parseInt(string, radix); // 将radix进制的string 转换为10进制Int
```

如果第一个字符不能转换为 radix 对应的数字，parseInt 会返回 NaN

#### parameter

- string 要解析的字符串，如果参数不是字符串，则调用 toString 将其转换为字符串
- radix（可选）从 2 - 36 指定字符串的进制

### 特殊处理

#### radix 不在指定范围内

- radix 是 undefined， 0 或者未指定
  - 如果 string 以 0x 开头，那么 radix 被假定为 16
  - 如果 string 以 0 开头，radix 被假定为 8 进制或 10 进制，**ES5 建议使用 10 进制**，但并不是所有浏览器都支持，所以推荐在使用 parseInt 的时候显示指定 radix
  - 如果输入的 String 以任何其他的值开头，radix 是 10 进制

## 02 请实现一下防抖和节流

### 防抖函数

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

#### 代码实现

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

### 节流函数

原理与 防抖函数相同，通过存储时间戳来记录上次调用函数的时间

#### 代码实现

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

## 以下 3 个判断数组的方法，请分别介绍它们之间的区别和优劣

### Object.prototype.toString.call()

每一个对象都有 toString 方法，如果该 toString 方法没有被 overwrite，那么返回的值是 [Object type]
Object.prototype.toString.call(String(5)) // -> 使用 Object 原型上的 toString 方法来执行 String(5)避免 overwrite
具体参考这边文章[js-类型 - 为什么 Array String Number Boolean RegExp Date 不能直接调用 toString ? xxx.toString](https://shancw96.github.io/blogs/2020/06/24/js-type/)

### Array.isArray

判断一个对象是否为 array

### instanceof

A instanceof B A 的原型链上是否存在 B 的原型

```js
const instanceof_polyfill = (A, B) =>
  A.__proto__ === B.prototype
    ? true
    : A.__proto__ === null
    ? false
    : instanceof_polyfill(A.__proto__, B);
```

#### 原型链图

<img src="prototype.png" />

### 其他的类型判断

#### typeof

js 在底层存储变量的时候，会在变量的机器码（变量通过编译形成）的低位 1-3 位存储其类型信息

- 000 对象
- 010 浮点型
- 100 字符串
- 110 布尔
- 1 整数

null：所有机器码均为 0 **由于 null 的所有机器码均为 0，因此直接被当做了对象来看待**
undefined: -2^30

typeof 只能 string number boolean function symbol，但是 Array, Object 统一为 object

## 箭头函数与普通函数的区别

### 区别

- 箭头函数没有自己的 this，函数体内部的 this 为定义时所在的作用域中的 this
- 箭头函数没有自己的 prototype

- 由于 new 生成实例需要用到 函数体的 prototype 和本身 this 因此 箭头函数无法作为构造函数进行使用

### new 实现

- 创建一个空的简单 JavaScript 对象（即{}）；
- 链接该对象（设置该对象的 constructor）到另一个对象 ；
- 将步骤 1 新创建的对象作为 this 的上下文 ；
- 如果该函数没有返回对象，则返回 this。

```js
function new_polyfill(father, ...args) {
  let result = {};
  result.__proto__ = father.prototype;
  const result2 = father.apply(result, args);
  if (
    (typeof result2 === "object" || typeof result2 === "function") &&
    result2 !== null
  ) {
    return result2;
  }
  return result;
}
```

## 引用类型作为函数的参数

写出这段代码的打印值

```js
function changeObjProperty(o) {
  o.siteUrl = "http://www.baidu.com";
  o = new Object();
  o.siteUrl = "http://www.google.com";
}
let webSite = new Object();
changeObjProperty(webSite);
console.log(webSite.siteUrl);
```

ans: {siteUrl: 'http://www.baidu.com'}

```js
// 这里把o改成a
// webSite引用地址的值copy给a了
function changeObjProperty(a) {
  // 改变对应地址内的对象属性值
  a.siteUrl = "http://www.baidu.com";
  // 变量a指向新的地址 以后的变动和旧地址无关
  a = new Object();
  a.siteUrl = "http://www.google.com";
  a.name = 456;
}
var webSite = new Object();
webSite.name = "123";
changeObjProperty(webSite);
console.log(webSite); // {name: 123, siteUrl: 'http://www.baidu.com'}
```

> 引用类型在函数中的传递是复制一份地址进行传递，也就是说函数体的参数是原对象的地址 copy

## async await 的实现？（使用 generator 实现）

### generator

```js
function* gen() {
  yield 1;
  yield 2;
  yield 3;
}

let g = gen(); // Generator {}
```

#### methods

- `Generator.prototype.next()`
  返回一个由 yield 表达式生成的值。

- `Generator.prototype.return()`
  返回给定的值并结束生成器。

* `Generator.prototype.throw()`
  向生成器抛出一个错误。

#### example id 生成器

```js
function* idMaker() {
  let index = 1;
  while (true) yield (index += 1);
}
```

### 使用 generator 模拟 async await

场景：下载文件

- 使用 generator 模拟 async await

```js
function asyncAwait_polyfill(genFn) {
  return new Promise((resolve, reject) => {
    const iterator = genFn();
    run();
    function run(value) {
      const tempResult = iterator.next(value); // iterator 内部迭代，每次调用后会进入不同的状态
      if (tempResult.done) {
        resolve(tempResult.value);
      } else {
        tempResult.value.then((res) => {
          run(res);
        });
      }
    }
  });
}

const promise100Start = () =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(1);
    }, 1000);
  });
const promise100 = (val) =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(val + 1);
    }, 1000);
  });

asyncAwait_polyfill(function* gen() {
  const temp1 = yield promise100Start();
  console.log("yield promise100Start", temp1);
  const temp2 = yield promise100(temp1);
  console.log("yield promise100", temp2);
  return temp2;
}).then((res) => {
  console.log("asyncAwait_polyfill", res);
});

/**
 *
 * yield promise100Start 1
 * yield promise100 2
 * asyncAwait_polyfill 2
 * /
```
