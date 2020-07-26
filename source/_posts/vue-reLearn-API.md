---
title: Vue 学习 - API
categories: [Vue]
tags: []
toc: true
date: 2020/7/20
---

- 控制台输入 vm 可以访问当前 Vue 实例

# Slot

## 基本写法 v-slot

父组件

```jsx
<todo-list>
  <todo-item v-for="item in list">
    <template v-slot:pre-icon>
      <span>前置图标</span>
    </template>
  </todo-item>
</todo-list>
```

子组件

```jsx
<li>
  <slot name="pre-icon"></slot>
</li>
```

## 父组件 获取子组件插槽传出的值 slotProps

父组件 使用 使用带值的 v-slot 来定义 子插槽的 props

````jsx
<todo-list>
  <todo-item v-for="item in list">
+    <template v-slot:pre-icon="slotProps">
      <span>前置图标</span>
    </template>
  </todo-item>
</todo-list>

console.log(slotProps) // -> {value:'test'}
```jsx

子组件 在slot上添加属性
```jsx
<li>
+  <slot name="pre-icon" value="test"></slot>
</li>
````

## 默认值

子组件

```jsx
<li>
  <slot name="pre-icon">默认icon😊</slot>
</li>
```

# 双向绑定 v-model 的理解

## v-model 是语法糖，用于简化代码

如 input

```jsx
// version1
<input :v-model="value" />

// version2
<input :value="message" @change="handleChangeVal">
methods: {
  handleChangeVal(e) {
    this.message = e.target.value
  }
}
```

# 虚拟 dom 和 key 属性作用（需要深入学习）

插入 和 移动 key 有作用，唯一性判断

[虚拟 DOM DIFF：为什么不要使用 index 作为自定义组件的 key](https://juejin.im/post/5e8694b75188257372503722)

# Watch API 食用方式

```js
export default {
  data: function () {
    return {
      a: 1,
      b: { c: 2, d: 3 },
      e: {
        f: {
          g: 4,
        },
      },
    };
  },
  watch: {
    // 基础监听
    a: function (val, oldVal) {
      this.b.c += 1;
    },
    // 嵌套监听
    "b.c": function (val, oldVal) {
      this.b.d += 1;
    },
    // 深度监听
    e: {
      handler: function (val, oldVal) {
        //code
      },
      deep: true,
    },
  },
};
```

# 使用`.sync` 来更新 props

## 更新单个 prop `:propName.sync="data"`

parent

```html
<child :title.sync="title"></child>
```

child

```js
export default {
  props: {
    title: String,
  },
  methods: {
    changeTitle() {
      this.$emit("update:title", "hello");
    },
  },
};
```

## 更新多个 props `v-bind.sync="data"`

parent

```html
<child v-bind.sync="bundle"></child>
<script>
  data() {
    return {
      bundle:{
        prop1: 1,
        prop2: 2
      }
    }
  }
</script>
```

child

```js
export default {
  props: ["prop1", "props"],
  //其余保持一致
};
```
