---
title: JS-异步函数-Promise 实现
categories: [js]
tags: [异步, promise]
toc: true
date: 2020/7/2
---

# Promise 介绍及相关必要知识

Promise 对象表示了异步函数的最终结果（可能是成功，也可能是失败的）。

> MDN:The Promise object represents the eventual completion (or failure) of an asynchronous operation, and its resulting value

## 宏观任务与微观任务的认识

Promise 属于微观任务。那么什么是微观任务，与之相对的宏观任务又是什么？

- JS 宿主发起的任务为宏观任务，JS 引擎发起的任务为微观任务。如`window.setTimeou`由浏览器（JS 宿主）提供的 API，所以属于宏观任务。
- 宏观任务的队列就相当于事件循环。事件循环：`MacroTask1, ... , MacroTaskN`。
- 一个宏观任务包含了微观任务队列。MacroTask1: MicroTask1, ... , MicroTaskN
  <!-- ![JS 宏观任务与微观任务](promise.png) -->
  <img src="promise.png" style="zoom:30%;" alt="微观任务与宏观任务的关系">

# Promise 实现

[Promise/A+ 规范](https://www.ituring.com.cn/article/66566)
