---
title: js-symbol的简单使用
categories: [js]
tags: [js类型]
toc: true
date: 2020/7/12
---

- Symbol 能够生成全局唯一的标识
- 能够作为对象的 key，并且不会被 `for...in` `Object.keys`访问到，但是可以通过`Object.getOwnPropertySymbols`访问到

* Symbol.for：以传入的字符串作为 key，首先搜索有没有以该字符串为 key 的 Symbol 如果有则直接返回，如果没有则创建一个并全局注册

  ```js
  const s1 = Symbol.for("key"); // 1.没有查询到key对应的Symbol 2. 创建一个名为key的Symbol
  const s2 = Symbol.for("key"); // 1. 查询到key对应的Symbol，将其返回

  console.log(s1 === s2); // -> true
  ```

- Symobol.keyFor 返回一个已登记的 Symbol 类型值的 key

  ```js
  let s1 = Symbol.for("foo");
  Symbol.keyFor(s1); // "foo"

  // 如果没有全局注册，则返回undefined
  let s2 = Symbol("foo");
  Symbol.keyFor(s2); // undefined
  ```
