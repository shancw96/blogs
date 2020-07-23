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

# Vuex 的实现

## 个人实现

```js
// mini-vuex
import Vue from "vue";
export const Store = function Store(options = {}) {
  const { state = {}, mutations = {}, getters = {}, actions = {} } = options;
  this._vm = new Vue({
    data: {
      $$state: state,
    },
  });
  this._mutations = mutations;
  this._actions = actions;
  // 使用这种方式实现getters
  this.getters = Object.keys(getters).reduce((reactiveGetter, getterKey) => {
    Object.defineProperty(reactiveGetter, key, {
      get: function () {
        return getters[key](this.state);
      },
    });
    return reactiveGetter;
  }, {});
};
Store.prototype.commit = function (type, payload) {
  if (this._mutations[type]) {
    this._mutations[type](this.state, payload);
  }
};
Store.prototype.dispatch = function (type, payload) {
  if (this._actions[type]) {
    /*
    action例子：
    fetchVal({commit}, payload) {
      // async data fetch...
      commit('EXAMPLE', payload)
    }
    */
    // apply null用于去除state context
    this._actions[type].apply(null, [this.state, payload]);
  }
};
Object.defineProperties(Store.prototype, {
  state: {
    get: function () {
      return this._vm._data.$$state;
    },
  },
});
// index
import Vuex from "mini-vuex";
const store = new Vuex.Store({
  state: {
    count: 0,
  },
  mutations: {
    increment() {
      state.count += 1;
    },
  },
  getters: {
    doubleCount: function (state) {
      return state.count * 2;
    },
  },
});
// vm.$store 访问
Vue.prototype.$store = store;

//use

console.log(this.$store.getters.doubleCount);
```

## 官方 vuex 精简版

```js
function partial(fn, arg) {
  return function () {
    return fn(arg);
  };
}
```

getters

```js
// bind store public getters
store.getters = {};
const wrappedGetters = store._wrappedGetters;
forEachValue(wrappedGetters, (fn, key) => {
  // use computed to leverage its lazy-caching mechanism
  // direct inline function use will lead to closure preserving oldVm.
  // using partial to return function with only arguments preserved in closure environment.
  computed[key] = partial(fn, store); // -> computed: { [key](){/run code/}} 并传入store为参数
  Object.defineProperty(store.getters, key, {
    get: () => store._vm[key],
    enumerable: true, // for local getters
  });
});
store._vm = new Vue({
  data: {
    $$state: state,
  },
  computed,
});
```
