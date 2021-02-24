---
title: webpack - 文件解析(js/jsx, css/scss, 图片/字体)
categories: [工程化]
tags: [webpack]
toc: true
date: 2020/10/5
---

## es6, jsx 解析 babel-loader

需要用到的包

- @babel/core ：babel 核心文件
- @babel/preset-env : es6 规则解析
- @babel/preset-react : jsx 规则解析

- babel-loader： webpack 打包

### webpack.config.js

```js
const path = require("path");
module.exports = {
  entry: "entry.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist"), // -> /Users/wushangcheng/Desktop/dist
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: "babel-loader",
      },
    ],
  },
};
```

### .babelrc

babel 的 配置文件是.babelrc

```json
{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}
```

> node join 与 resolve 的区别

```js
1. join是把各个path片段连接在一起， resolve把‘／’当成根目录
path.join("/a", "/b");
// /a/b
path.resolve("/a", "/b");
// /b
2. resolve在传入非/路径时，会自动加上当前目录形成一个绝对路径，而join仅仅用于路径拼接
path.join(__dirname, 'dist') // -> /Users/wushangcheng/Desktop/dist
path.resolve('dist') // -> /Users/wushangcheng/Desktop/dist
```

## CSS 解析

**loader 的执行是从右到左**，右侧的会优先解析
需要用到的包

- style-loader 将编译完成的 css 插入 html 中的工具
- css-loader 将 CSS 转化成 CommonJS 模块

* less-loader 将 less 解析成 css
* sass-loader 将 sass 解析成 css

通过将 style-loader 和 css-loader 与 sass-loader 链式调用，可以立刻将样式作用在 DOM 元素

### webpack.config.js

```js
const path = require("path");
module.exports = {
  entry: "entry.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist"),
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
      // less 解析
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader", "less-loader"],
      },
      // sass 解析
      {
        test: /\.scss$/,
        use: ["style-loader", "css-loader", "sass-loader"],
      },
    ],
  },
};
```

## 图片，字体解析

> 图片文件解析主要是为了在生成的 dist 文件下存在对应的打包文件，解决打包后文件丢失

需要用到的包

- file-loader： 当在开发的文件目录引入一个文件，会将该文件生成到输出目录，并且返回生成后的文件地址（hash）
- url-loader: url-loader 基于 file-loader 封装了一层， 可以将图片作为 base64 解析到 js 文件。

```js
module.exports = {
  entry: "entry.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist"),
  },
  module: {
    rules: [
      // url-loader： 大于10240的图片不做base64 转换，此时和file-loader base64转换
      {
        test: /\.(png|jpg|gif|jpeg)/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10240,
            },
          },
        ],
      },
      // file-loader：处理字体文件
      {
        test: /\.(woff|woff2|eot|ttf)/,
        use: "file-loader",
      },
    ],
  },
};
```

> **base64 作用**
> base64 也会经常用作一个简单的“加密”来保护某些数据
> base64 解析到 js 后，可以减少 http 请求从而加快资源获取
