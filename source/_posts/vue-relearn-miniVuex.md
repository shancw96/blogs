---
title: Vuex implement
categories: [Vue]
tags: []
toc: true
date: 2020/8/3
---
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
