---
title: 前端面试
categories: [算法]
tags: []
toc: true
date: 2022/3/11
top: 1
---

上次更新时间：2022/3/11

<!-- more -->

## JS

### 【基础】let const 区别

let 与 const 都是只在声明所在的块级[作用域](https://so.csdn.net/so/search?q=作用域&spm=1001.2101.3001.7020)内有效。

let 声明的变量可以改变，值和类型都可以改变，没有限制。

`const`声明的变量不得改变值，这意味着，const 一旦声明变量，就必须立即初始化，不能留到以后赋值。

### 【基础】Promise 相关

- Promise 是什么，用来解决什么问题

  解决异步操作的一个方案

- 有哪些状态
  - pending
  - fulfilled
  - rejected

### 【基础】Array 的常用方法

- 归类

  - pop

  - shift

  - unshift

  - indexOf

  - splice

  - slice

  - reduce

  - map

- map 和 reduce 的使用场景？简单概括 reduce 和 map 的用处

### 【中等】什么是闭包

- **闭包**是有权限访问其他函数作用域内的变量的一个函数 - 红宝书

- **闭包解决了什么？**

  _由于闭包可以缓存上级作用域，那么就使得函数外部打破了“函数作用域”的束缚，可以访问函数内部的变量。以平时使用的 Ajax 成功回调为例，这里其实就是个闭包，由于上述的特性，回调就拥有了整个上级作用域的访问和操作能力，提高了极大的便利。开发者不用去写钩子函数来操作上级函数作用域内部的变量了。_

- **闭包有哪些应用场景**

  - 回调函数
  - 函数 curry

- 存在的问题

  常驻内存，增加内存使用量。 - 使用不当会很容易造成内存泄露。

### 【进阶】EventLoop

- Promise.resolve().then 和 setTimout(xx, 0) delay 为 0 哪个快？为什么？

  - Promise 属于 microTask, setTimeout 属于 macroTask。

  - 执行顺序为：`microTask` > `UI render` > `macroTask`
  - **两个 setTimeout 的最小间隔约为 4ms**，

- 假设有个函数，需要大量计算，比如从 1 数到 100000000，JS 如果直接执行一个 for loop 或者 while loop 那么很大可能会直接显示：当前页面未响应。我们要怎么样去优化用户的体验

  - setTimeout 切分
  - web workers: 给 JS 创造多线程运行环境，允许主线程创建 worker 线程，分配任务给后者，主线程运行的同时 worker 线程也在运行，相互不干扰，在 worker 线程运行结束后把结果返回给主线程。

## Vue

- key

  1. key 的作用主要是为了高效的更新虚拟 DOM，其原理是 vue 在 patch 过程中通过 key 可以精准判断两个节点是否是同一个，从而避免频繁更新不同元素，减少 DOM 操作量，提高性能。
  2. 所以用 index 来做 key 会出现复用错的问题，还可以在列表更新时引发一些隐蔽的 bug。key 的作用很简单，就是为了复用。正是因为会复用，比如[10,11,12]，对应 key 是 0,1,2，如果我把 11 这项删了，就是[10,12]，key 是 0,1，这是发现 11 对应的 key 和 12 对应的 key 都是 1

- v-model

  - v-model 一句话概括：实现数据的双向绑定

  - 和 v-bind 区别？基于 v-bind 实现

  - 如何实现一个 v-model 语法糖： 使用 v-bind 获取 value v-on 绑定 input 触发事件

- v-if 和 v-show

  - **v-if** 也是惰性的：如果在初始渲染时条件为假，则什么也不做——在条件第一次变为真时才开始局部编译（编译会被缓存起来）。

  - 相比之下，**v-show** 简单得多——元素始终被编译并保留，只是简单地基于 CSS 切换。

- 通信方式

  - $emit
  - props
  - provide inject 父->子 非响应式
  - vuex
  - eventBus 无约束，混乱，不推荐使用

- vue2 和 vue3 在响应式实现上的区别

  - Object.defineProperity VS proxy
