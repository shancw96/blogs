---
title: 前端面试
categories: [算法]
tags: []
toc: true
date: 2022/3/11
top: 2
---

上次更新时间：2022/4/13

<!-- more -->

## JS

### 原始(Primitive)类型有哪些

string, number, boolean, **null**，**undefined**， **symbol**

#### **简单介绍下 symbol？**

- 中文-符号，es6 新增
- 用途：确保对象属性使用唯一标识符，不会发生属性冲突的危险

#### **null 和 undefined 的区别？**

- undefined 介绍
  - undefined：当使用 var 或者 let 声明变量但没有初始化时，就相当于给变量赋予了 undefined 【红宝书】
  - **永远不要故意给某个变量设置为 undefined，undefined 主要用于比较**。
  - 增加 undefined 值的目的就是正式明确空对象指针（null）和未初始化变量的区别
- null 介绍
  - 从逻辑上讲，null 值表示一个空对象指针，所以`typeof null === object`
  - 在定义将来要保存对象值的变量时，建议使用 null 来初始化。

### 对象 (Object)

#### 什么是对象？

- 一组数据和功能的集合
- Object 是派生其他对象的基类
- 每一个 Object 都有如下几个属性和方法
  - constructor 用于创造当前对象的构造函数
  - method：hasOwnProperity(properityName) 判断当前对象，不包括原型链，是否存在指定的属性名称
  - method：isPrototypeof（object）是否是某个对象的原型
  - method：properityIsEnumerable（properityName）判断对象上的某个属性是否可以遍历
  - method：toLocalString（）
  - method：toString（）
  - valueOf：返回对象的字符串，数值或者布尔值标识，通常与 toString 返回值相同

#### array function Map Set 属于对象吗？

- 属于，从 Object 基类派生而来

### 执行上下文和作用域

> 执行上下文，后续简称为上下文

#### 什么是 执行上下文（Evaluation Context） ：

用来评估和执行 js 代码的环境（an execution context is an abstract concept of an environment where the Javascript code is evaluated and executed. ）；

包括了所有的可访问数据，以及描述了可执行的行为

#### 执行上下文的分类：

- 全局上下文：根据宿主环境的不同，表示全局上下文的对象也不一样，比如在浏览器中是 window
- 函数上下文：每个函数调用都有自己的上下文。
- Eval Function 上下文：开发者几乎用不到，暂不讨论

#### 详细说说函数上下文

当代码执行流进入函数时，函数的上下文被推到一个上下文栈上，当执行完毕后，再从这个上下文栈中弹出，讲控制权交给执行上下文。上下文中的代码在执行的时候，会创建一个**作用域链（scope chain）**。以代码为例：

```JS
function firstLevel() {
    const prop = 1;
    const a = 1;
    function secondLevel() {
        const prop = 2;
        const b = 2;
        function thirdLevel() {
            const prop = 3;
            const c = 3;
            console.log(a);
        }
    }
}
```

当我们代码执行到 thirdLevel 时候，创建的作用域链如下：

```JS
context（third level）- context(second level) - context(first level)
```

此时，当执行到`console.log(a)`,对 a 变量的查找，会沿作用域链逐层搜索，最终在 context（first level）找到。

#### 闭包是什么？

那么什么是闭包呢？还是以上面例子进行改造

```JS
function firstLevel() {
    const prop = 1;
    const a = 1;
    function secondLevel() {
        const prop = 2;
        const b = 2;
        function thirdLevel() {
            const prop = 3;
            const c = 3;
            console.log(a);
            return function fourthLevel() {
                console.log(a, b, c);
            }
        }
    }
}

const closureExample = firstLevel();
```

看代码，直白解释：

如果有个函数 A，他的 return 结果是另外一个函数 B，此时我们通过一个变量，接收函数 A 的执行结果，函数 B。那么这就生成了一个闭包。

对闭包深入理解：

```JS
function A() {
    ....
    const a = xx;
    const b = xx;
    const c = xx;
    return function B() {
        // 访问a，b，c
    }
}

const closure = A(); // 带着特定作用域链的函数B
```

闭包保存了原本函数 A 在执行完毕后，应该销毁的作用域链。使得即使在 A 结束后，依然可以通过函数 B 对它的内部变量进行访问。

文章参考：

- 红宝书 - 第三章
- [Understanding Execution Context and Execution Stack in Javascript](https://blog.bitsrc.io/understanding-execution-context-and-execution-stack-in-javascript-1c9ea8642dd0)

## 【基础】Promise 相关

- Promise 是什么，用来解决什么问题

  解决异步操作的一个方案

- 有哪些状态
  - pending
  - fulfilled
  - rejected

## 【基础】Array 的常用方法

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

## 【进阶】EventLoop

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
