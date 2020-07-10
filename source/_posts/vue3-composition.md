---
title: Vue Composition 笔记01-概览
categories: [Vue]
tags: [Vue3]
toc: true
date: 2020/7/10
---

## 基本用法

```html
<!-- template 与之前没有区别 -->
<template>
  <button @click="increment">
    Count is: {{ state.count }}, double is: {{ state.double }}
  </button>
</template>
<script>
  // vue3 将vue核心功能按模块进行了拆分
  // reactive：响应式模块，computed：计算属性
  import { reactive, computed } from "vue";
  export default {
    //setup 函数是一个新的组件选项。作为在组件内使用 Composition API 的入口点
    setup() {
      const state = new reactive({
        count: 0,
        double: computed(() => state.count * 2),
      });

      // vue3 中的函数
      function increment() {
        state.count++;
      }

      return {
        state,
        increment,
      };
    },
  };
</script>
```

### 上述代码概括：

- vue2 与 vue3 单个 vue 文件，还是由两部分组成(template, script)
- 想要使用 vue3 的新特性，需要使用 setup 方法，在 setup 内部进行

* vue3 将核心功能按模块进行了拆分

## 模块

### reactive + watchEffect

> reactive 几乎等价于 2.x 中现有的 Vue.observable() API，且为了避免与 RxJS 中的 observable 混淆而做了重命名

> watchEffect API 基于响应式，能够自动识别对应的值变化，并执行副作用代码

#### 使用方法

```js
import { reactive } from "vue";

// state 现在是一个响应式的状态
const state = reactive({
  count: 0,
});

// 当监测到count属性发生变化，则输出count*2
// watchEffect 在初始化的时候会执行一次，用于收集依赖
watchEffect(() => {
  console.log(state.count * 2);
});
state.count += 1;

//上述代码输出如下：
// -> 2
// -> 4
```

#### 小结：

- reactive 模块能够创建响应式数据，与外部的交互通过 watchEffect 实现。
- watchEffect 需要初始化执行一次来收集依赖

### computed

> 与 vue2 的 computed 实现的功能相同，都是基于一个状态，得到另外一个状态

#### 使用方法

```js
// 在外部声明
import { reactive, computed} from  'vue;
const state = reactive({
  count: 0
});
const double = computed(()=> state.count * 2);

// 或者直接写在内部
const stateInner = reactive({
  count:0,
  double: computed(()=> state.count * 2)
})
```

#### 小结

- computed api 与 vue2 思想相同
- 计算属性可以在 reactive 内部定义

### Ref（引用）

> Ref 能够创造一个引用类型数据
> 引入它是为了以变量形式传递响应式的值而不再依赖访问 this

#### toRef

当使用 reactive 的时候，不能够使用解构，因为解构意味着返回新的数据，返回新的数据意味着丢失响应式。
通过 toRef 对响应式数据进行包裹能够解决这类问题

```js
function useMousePosition() {
  const pos = reactive({
    x: 0,
    y: 0,
  });

  // ...
  return toRefs(pos);
}

// x & y 现在是 ref 形式了!
const { x, y } = useMousePosition();
```
