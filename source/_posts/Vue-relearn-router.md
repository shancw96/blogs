---
title: 在项目中 Vue Router的构建
categories: [Vue]
tags: []
toc: true
date: 2020/7/25
---

# VueRouter

## 路由组件传参

```js
routes: [
  { path: "/", component: Hello }, // 不传递参数
  { path: "/hello/:name", component: Hello, props: true }, // 将route.params 作为props 传递给组件(用于组件解耦)
  { path: "/static", component: Hello, props: { name: "world" } }, // static values
  { path: "/dynamic/:years", component: Hello, props: dynamicPropsFn }, // 在 params 和 props 之间增加一层map操作
];
```

## 404 设置

```js
routes: [
  ... 基本路由设置
  {path: '*', component: component404, name:'404'}
]
```

## redirect 重定向路由设置

```js
routes: [
  ... 基本路由设置
  {path: '/a', redirect:'/bar'},
  {path: '*', component: component404, name:'404'}
]
```

## 使用 NProgress 插件设置虚拟 ajax 请求进度栏

[NPorgress 地址](http://ricostacruz.com/nprogress/)

### 安装

npm 形式：npm install --save nprogress

### 使用

在 router.js 中导入

```js
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';//导入样式
const router = new Router({
  routes: [...]
})

router.beforeEach((to, from, next) => {
  NPorgress.start();
  ...other logic
  next();
})

router.afterEach((to, from, next) => {
  NProgress.end();
  ...other logic
  next();
})
```

### 总结

- NProgress 是提供给用户看的视觉动画，并不是真正意义上的 ajax 监听。
- NProgress.start 为开始动画 NProgress.end 为结束动画（进度条加载完成）
- start 和 end 方法调用的时机为 router 对应的两个钩子，路由跳转前和路由跳转后。在跳转前开启动画加载，在跳转后结束动画

## 菜单与路由结合

菜单结构：嵌套数组
路由结构；嵌套数组

因为两种接口大致相同，所以 路由 routes -> filterMethod -> 菜单结构 并不难实现

### 具体实现思路：

1. 隐藏不想要展示的路由：添加 hideInMenu 字段 hideInMenu: true
2. 隐藏不想要的子路由：在当前路由下添加 hideChildMenu 字段 hideChildMenu: true
3. 路由名称和 icon 显示： 添加 meta 字段 meta: {icon:'dashboard', title:'首页'}

### 获取路由列表

```js
this.$router.options.routes;
```

### 过滤函数

```js
const routes = this.$router.options.routes;

const createMenu = (route) => {
  const shouldRender = (route) => pick(route, "hideInMenu") === true;
  const renderCore = compose(
    join(addToObj, pick(_, "name"), pick(_, "title")),
    ifElse(
      (MenuItem) => pick(MenuItem, "hideChildMenu") === true,
      (MenuItem) => createMenu(pick(MenuItem, children)),
      (_) => _
    )
  );
  return ifElse(shouldRender, renderCore, (_) => [])(route);
};
const getMenuData = (routes) =>
  isVaild(routes) ? routes.map((route) => createMenu(route)) : [];
```

## 路由鉴权

auth 权限校验函数

```js
// 获取当前用户的权限列表
export function getCurrentAuthority() {
  return ["admin"]; // 当前用户的权限列表
}
// 检查用户的权限列表中是否有 requiredAuthList 中的任意一个元素
// check(['user', 'admin']) 检验当前用户是否为user 或admin 如果是的话。。。
export function check(requiredAuthList) {
  const userAuthList = getCurrentAuthority();
  return current.some((item) => requiredAuthList.includes(item));
  // return requiredAuthList.every(requiredAuth => userAuthList.include(requiredAuth));
}

export function isLogin() {
  // 假设权限码9527 - 9530 为已登陆用户的三种状态
  const userAuthList = getCurrentAuthority();
  return (
    userAuthList &&
    userAuthList.some((authCode) => [9527, 9528, 9529].include(auth))
  );
}
```

### 在 router 中设置鉴权

给需要鉴权的路由 meta 添加 authorizate 字段，然后在 beforeEach 钩子中调用 check 方法判断是否具有权限

- 给需要鉴权的路由 meta 添加 authority 字段

```js
route = [
  ...
  {
    path:'/needAuth',
    meta: {authority: ['admin', 'user']}
  }
  ...
]

router.beforeEach((to, from, next) => {
  const record = to.matched.some(record => record.meta.authority)
  if(record && !check(record.meta.authority)) {
    // 如果没登陆则需要前往login
    if(!isLogin() && to.path !=='/login'){
      next({
        path: '/login'
      })
    }else{// 没有权限访问
      this.$message({
        type:'warning',
        msg:'权限不足'
      })
      next({
        path: "403"
      })
    }
  }else{
    next();
  }
})
```

### 通过函数式组件来决定用户是否有权限查看特定组件

```js
import {check} from 'utils/auth';
export default {
  functional: true,
  props: {
    authority: {
      type: Array,
      required: true
    }
  }
  render(h, context){
    const {props, scopedSlots} = context;
    return check(props.authority) ? scopedSlots.default() : null
  }
}
```

使用姿势

```html
//example.vue
<template>
  <!-- 需要用户是admin才能够访问 -->
  <authCheck :authority="[admin]">
    <button title="distory files"/>
  <authCheck>
</template>
<script>
import authCheck from 'component/fp/auth';
component: {
  authCheck
}
</script>
```
