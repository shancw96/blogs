---
title: cloudExpress 开发 02
categories: [React]
tags: []
toc: true
date: 2020/9/11
---

## useState

```js
// 声明一个叫 “count” 的 state 变量
const [count, setCount] = useState(0);
console.log(count); // -> 0
setCount(count + 1);
console.log(count); // -> 1
```

## useEffect

`useEffect(fn, [dependence, .., dependence ])`

- **useEffect 接收两个参数，第一个为副作用函数，第二个为 hook 的依赖**，只有当依赖发生改变的时候，才会触发执行
- **useEffect 在初始化的时候会执行一次**，如果依赖为空，便不会再次执行，这实现了类似 mounted 的效果

* **useEffect 返回值必须是一个 cleanup 函数**，用于清除 Effect，这意味着下面的代码结构是错误的

  ```js
  useEffect(async () => {
    await fetchSomething();
  });
  ```

  <u>每一个带有 async 标注的函数，都会返回一个 Promise</u>，如果代码结构写成上面的这种将会抛出错误

  ```js
  Warning: useEffect function must return a cleanup function or nothing.
  Promises and useEffect(async () => ...) are not supported,
  but you can call an async function inside an effect
  ```

* 什么是 useEffect 的 cleanup
  cleanUp 设计来 Undo 一些 Effect 如订阅

```js
useEffect(() => {
  ChatAPI.subscribeToFriendStatus(props.id, handleStatusChange);
  return () => {
    ChatAPI.unsubscribeFromFriendStatus(props.id, handleStatusChange);
  };
});
```

- Render 的某一刻的状态是固定的，相当于快照
  **原理**

  ```js
  function sayHi(person) {
    const name = person.name;
    setTimeout(() => {
      alert("Hello, " + name);
    }, 3000);
  }

  let someone = { name: "Dan" };
  sayHi(someone);

  someone = { name: "Yuzhi" };
  sayHi(someone);

  someone = { name: "Dominic" };
  sayHi(someone);
  ```

## [开启 scss：使用 bootstrap 的 utilities](https://getbootstrap.com/docs/4.5/utilities/borders/)

### create-react-app 中开启 scss

```js
1. `yarn add node-sass` 或者 `npm i node-sass --save`
2. **将原有的全局入口css文件 app.css**改为scss文件：此步为了让webpack 调用sass-loader 而不是postcss
```

[✈️ bootstrap utils 仓库](https://github.com/twbs/bootstrap/tree/main/scss)

scss 文件目录结构,我们只需要关注 bootstrap 开头的文件，然后根据自己的需要进行 cv，这里我们要将其 utilities 模块的功能抄过来。

### 首先将 scss 目录 整个复制到我们的项目中

```js
// main/scss 目录
...
bootstrap-grid.scss
bootstrap-reboot.scss
bootstrap-utilities.scss // 我们需要的utilities 入口文件
bootstrap.scss
```

### 根据 utilities 的入口文件引入的文件，剔除对我们无用的 scss 文件

如下入口文件，我们只需要保留对应的文件即可

```scss
// utilities
/*!
 * Bootstrap Utilities v5.0.0-alpha1 (https://getbootstrap.com/)
 * Copyright 2011-2020 The Bootstrap Authors
 * Copyright 2011-2020 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/main/LICENSE)
 */

// Configuration

@import "functions";
@import "variables";
@import "mixins";
@import "utilities";

// Utilities

@import "utilities/api";
```

### 进入到对应的文件下，这些文件也是对应模块的入口文件，重复操作删除无用文件

⚠️ 到这一步文件体积已经减少很多了，如果想要完全剔除干净可以去对应的入口文件再次进行剔除，但是对 bootstrap 不熟悉 或者对项目体积要求不是太高，不推荐操作，可能会导致误删

最后在 app.scss 文件中导入

```js
// app.scss
@import './assets/scss/bootstrap-utilities.scss';
```
