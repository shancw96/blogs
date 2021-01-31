---
title: 什么是闭包
categories: [js]
tags: []
toc: true
date: 2021/1/18
---

## 解释：

函数执行后返回一个新的函数，返回的新的函数被一个变量所保存，并且这个函数保存着原有函数的变量的引用，这就是一个常见的闭包。

```js
function foo() {
  const a = 1;
  return function inner() {
    console.log(`The secret number is ${secret}`);
  };
}

const f = foo();
f();
```

## 原理

在 JS 中，如果函数 A 被函数 B 调用，而函数 B 又被函数 C 调用，这就形成了一个作用域链。

```js
function C() {
  const c = "c";
  return function B() {
    const b = "b";
    console.log("B in", c);
    return function A() {
      console.log("A in", b);
    };
  };
}
const b = C(); // B -> C
const a = b(); // A -> B -> C
```

此时 b 的作用域链为 B->C, a 的作用域链在 b 的基础上增加了 A，所以是 A->B->C。由于作用域链被外部保存，因此 C()和 b()执行完后依旧会存在。
所以，闭包可以理解持久保存作用域链方法的一种方式。

## 使用

### curry

```js
function curry(fn) {
  let accArgs = [];
  return function curried(...args) {
    accArgs = [...accArgs, ...args];
    if (fn.length === accArgs.length) return fn(...accArgs);
    else return curried;
  };
}
```

### 模块化

```js
let namespace = {}(
  (function foo(n) {
    let numbers = [];
    function format(n) {
      return Math.trunc(n);
    }
    function tick() {
      numbers.push(Math.random() * 100);
    }
    function toString() {
      return numbers.map(format);
    }
    n.counter = {
      tick,
      toString,
    };
  })(namespace)
);

const counter = namespace.counter;
counter.tick();
counter.tick();
console.log(counter.toString());
```
