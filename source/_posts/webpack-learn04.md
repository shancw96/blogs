---
title: webpack - 热更新
categories: [工程化]
tags: [webpack]
toc: true
date: 2020/10/5
---

## 热更新

需要用到的插件 plugin: HotModuleReplacementPlugin

需要用到的包：webpack-dev-server

需要开启的选项：

- 通过 WDS 启动: webpack-dev-server
- 将 mode 设置为 development

## webpack.config.js

```js
const webpack = require('webpack')
module.exports = {
  ...
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  devServer: {
    contentBase: './dist',//入口文件/文件夹
    hot: true
  }
}
```

## package.json

```json
  "scripts": {
    ...
    "dev": "webpack-dev-server --config webpack.dev.js --open"
  },
```

> WDS 特点：
> 不刷新浏览器，不输出具体打包文件，而是放在内存中
