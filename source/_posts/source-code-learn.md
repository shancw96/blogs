---
title: 在jest test中debug
categories: [源码]
tags: []
toc: true
date: 2020/8/31
---

## 在对应的源码处插入 `debugger`

## 借助 chrome 的控制台进行调试

- 打开 chrome，并输入地址: `chrome://inspect`
- 选择 `Open dedicated DevTools for Node`

## 在控制台使用 node 运行测试文件

- 在 package.json - script 添加

  ```js
  "test:debug": "node --inspect node_modules/.bin/jest --runInBand"

  或者 --watch 模式：方便在修改源码或测试的时候重跑

  "test:debug": "node --inspect --watch node_modules/.bin/jest --runInBand"
  ```

  现在能够通过 `yarn test:debug <path_to_test>` 进行 debug

* 或者不使用 package.json 设置脚本 直接控制台输入 `node --inspect node_modules/.bin/jest --runInBand <path_to_test> `
