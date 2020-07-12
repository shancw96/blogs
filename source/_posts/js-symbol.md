---
title: js-symbol的简单使用
categories: [js]
tags: [js类型]
toc: true
date: 2020/7/12
---

- Symbol 能够生成全局唯一的标识
- 能够作为对象的 key，并且不会被 `for...in` `Object.keys`访问到，但是可以通过`Object.getOwnPropertySymbols`访问到

* Symbol.for 能够全局注册并访问同一个 Symbol

  ```js
  const s1 = Symbol.for("key"); // 1.没有查询到key对应的Symbol 2. 创建一个名为key的Symbol
  const s2 = Symbol.for("key"); // 1. 查询到key对应的Symbol，将其返回

  console.log(s1 === s2); // -> true
  ```

- Symobol.keyFor 通过 Symbol 对象获取其值
  ```js
  let name1 = Symbol.for("name");
  let name2 = Symbol.for("name");
  console.log(Symbol.keyFor(name1)); // 'name'
  console.log(Symbol.keyFor(name2)); // 'name'
  ```
