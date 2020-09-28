---
title: Vue Composition 笔记01-概览
categories: [Vue]
tags: [Vue3]
toc: true
date: 2020/7/10
---

## setup

setup 函数 是 composition API 的入口，它的返回对象的属性会被合并到 组件模版的渲染上下文

```jsx
<template>
  <div>{{ count }} {{ object.foo }}</div>
</template>

<script>
  import { ref, reactive } from 'vue'

  export default {
    setup() {
      const count = ref(0)
      const object = reactive({ foo: 'bar' })

      // 暴露给模板
      return {
        count,
        object,
      }
    },
  }
</script>
```
