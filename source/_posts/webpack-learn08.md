---
title: webpack - 动态import支持
categories: [工程化]
tags: [webpack]
toc: true
date: 2020/10/8
---

对于大型的 web 应用，将所有的代码都放在一个文件中会导致加载非常慢，其中有一些代码只有特定场景才会用到。在这种情况下，按需加载，就很有必要。
webpack 有一个功能能够将代码库分割成 chunks，当代码允许到需要他们的时候再进行加载

**适用的场景**

- 抽离相同的代码到共享块
- 脚本懒加载，使得初次下载的代码更小（首屏优化）

## 懒加载 JS 脚本的方式

### CommonJS: require.ensure（不推荐使用）

`require.ensure(dependencies: String[], callback: function(require), chunkName: String)`
webpack 在编译时，会静态地解析代码中的 require.ensure()，同时将模块添加到一个分开的 chunk 当中。这个新的 chunk 会被 webpack 通过 jsonp 来按需加载。

### ES6: 动态 import(需要 babel 转换)

- 安装 babel 插件
  npm install @babel/plugin-syntax-dynamic-import --save-dev

* .babelrc

```js
{
  "plugins": ["@babel/plugin-syntax-dynamic-import"]
}
```

import 返回的是一个 promise，当自己使用懒加载的时候，需要异步处理
`import('xxx').then(sourceData => (/*do something*/))`

使用例子：参考 vue-router

```js
const routes = [
  ...
  //fiction
  {
    path: "/fiction",
    component: () => import("../views/fiction/index.vue"),
    children: [{
        path: "search",
        name: "fiction_search",
        component: () => import("../views/fiction/search.vue")
      },
      {
        path: "home",
        name: "fiction_home",
        component: () => import("../views/fiction/book_home.vue")
      },
      {
        path: "chapterList",
        name: "fiction_chapterList",
        component: () => import("../components/fiction/chapterList.vue")
      },
      {
        path: "content",
        name: "fiction_content",
        component: () => import("../views/fiction/book_content.vue")
      }
    ]
  }
  ...
];

```
