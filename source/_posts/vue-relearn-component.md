---
title: Vue 学习 - 组件
categories: [Vue]
tags: []
toc: true
date:
---

# 生命周期

<img src="vue2-lifeCycle.jpg" style="zoom:30%">

> 一般开发会 vue 有 template，这时候会有一个 template -> render 函数的转化过程，如果直接跳过 template
> 就省了这一步操作，从而实现优化

render 虚拟 DOM 生成 -> mounted (挂载到真实 DOM)
`this.$nextTick` 用处：当子组件更新完毕后，执行指定内容

# 指令

v-pre： 绕过花括号 直接输出字符串

```js
<div v-pre>
{{this will not be compiled}}
</div>
```

`v-once: 只会解析一次，不会触发响应式`

# Provide Inject

## 层级关系

```js
            A[provide]
B             C                     D
    E[Inject]   F[Inject]     G   H   I[Inject]
```

## 具体写法

父组件

```js
export default {
    ...,
    provide() {
        return {
            theme: {
                color: this.color
            }
        }
    }
}
```

子组件

```js
export default {
  inject: {
    theme1: {
      from: "theme",
      default: () => ({}),
    },
  },
};
```
