---
title: Nuxt 基础项目构建
categories: [前端]
tags: [vue, implement]
toc: true
date: 2020/9/5
---

## Directory Structure

### layouts

> 通过添加 layouts/default.vue，能够使所有的页面继承 default.vue 的布局

**在具体组件页面中，通过设置 layout: 'xxx' 可以选择对应的 layout 样式**

```js
- layouts
  - default.vue
  - none.vue
```

示例代码 default.vue + 面包屑

```html
<template>
  <el-container class="h-100">
    <el-header class="layout-header" height="56px">
      <el-row class="w-100 h-100" type="flex" align="middle">
        <el-col :span="12">
          <span class="text-lg">智能监测预警平台</span>
        </el-col>
        <el-col :span="12">
          <span class="float-right mx-4">
            <i :class="`${breadcrumb.iconClass} mr-1`" />
            {{ breadcrumb.name }}
          </span>
        </el-col>
      </el-row>
    </el-header>
    <el-main class="p-0">
      <!-- pages 内容将在此显示 -->
      <Nuxt />
    </el-main>
  </el-container>
</template>

<script>
  // 导入面包屑设置
  import MENUS from "menu.config";
  export default {
    data() {
      return {
        breadcrumb: {},
      };
    },
    mounted() {
      // 通过mounted，每次组件创建的时候，都会重新更新面包屑
      this.updateBreadcrumb();
      this.$router.afterEach(() => {
        this.updateBreadcrumb();
      });
    },
    methods: {
      updateBreadcrumb() {
        const prefixPath = this.$route.name?.split("-")[0];
        // 从MENUS 中找到
        this.breadcrumb = MENUS.find((menu) => menu.path === prefixPath) || {};
      },
    },
  };
</script>
```

## middleware

> 中间件文件会在渲染页面前执行，使用场景：权限验证（进入页面前，需要验证是否有权限）
> 当创建了一个中间件，如 auth.js,那么这个中间件的 name 就是它的文件名

middleware 的执行顺序:

- nuxt.config.js (in the order within the file)
- Matched layouts
- Matched pages

### 在页面中可以指定执行那些中间件

```js
// pages/index.vue
export default {
  middleware: ["auth", "stats"],
};
```

## plugin

> plugin 一般用于自定义已添加的模块 或 添加 vue-plugin， 如 element-ui UI framework

例子（自定义@nuxt/axios 模块 如果 http response 500，则进行重定向）：

```js
// plugin/axios.js
export default function ({ $axios, redirect }) {
  $axios.onError((error) => {
    if (error.response.status === 500) {
      redirect("/sorry");
    }
  });
}

// nuxt.config.js
module.exports = {
  modules: ["@nuxtjs/axios"],
  plugins: ["~/plugins/axios.js"],
};
```

例子（Vue Plugin 使用 elementUI 并自定义）:

```js
// 自定义主题：https://element.eleme.cn/#/zh-CN/component/custom-theme
// plugin/element-ui/index.js
import Vue from 'vue'
import Element from 'element-ui'
import './element-variables.scss'

Vue.use(Element, { size: 'medium' })

// plugin/element-ui/element-variables.scss
@import "/assets/css/var";
@import "~element-ui/packages/theme-chalk/src/index";
@import "~element-ui/packages/theme-chalk/src/display";
```

## assets

> 编译的时候会被压缩，一般存放 css fonts

### css

#### css 配置

index.scss 作为入口文件，需要在 nuxt.config.js 中配置

```js
// nuxt.config.js
css: [..., "@/assets/css/index.scss"];
```

预设 class `_utilities.scss` 参考 [github bootstrap 的 utilities 文件](https://github.com/twbs/bootstrap/blob/main/scss/_utilities.scss), 怎么用可以看[bootstrap 官网提供的例子(v4.5)](https://getbootstrap.com/docs/4.5/utilities/borders/)

```js
// index.scss
@import "functions"; // 对应github bootstrap
@import "mixins";// 对应github bootstrap
@import "base";// 对应github bootstrap
@import "utilities";// 对应github bootstrap
```

[✈️ 传送门,暂未对外开放](https://github.com/shancw96/nuxt-template/tree/master/assets/css)
