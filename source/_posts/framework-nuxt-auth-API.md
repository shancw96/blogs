---
title: nuxt auth 简单使用介绍
categories: [vue]
tags: [nuxt]
toc: true
date: 2020/7/15
---

# 安装

npm 和 yarn 安装

install with yarn:

```bash
yarn add @nuxtjs/auth @nuxtjs/axios
```

Install with npm:

```bash
npm install @nuxtjs/auth @nuxtjs/axios
```

在 nuxt.config.js 中添加相关配置

```js
  module.exports = {
    /*
    ** Headers of the page
    */
    head: {...},
    css: [...],
    build: {...},
    plugins: [...],

    axios: {...},
    // Default Values
    modules: [
      ...
      '@nuxtjs/auth'
    ],
    auth: {
      defaultStrategy: 'local',
      strategies: {
        local: {
          // Each endpoint is used to make requests using axios
          endpoints: {
            login: { url: '/api/login', method: 'post', propertyName: 'id_token' },
            logout: { url: '/api/logout', method: 'post' },
            user: { url: '/api/account', method: 'get', propertyName: null }
          },
          tokenRequired: true,
          tokenType: 'Bearer',
          tokenName: 'Authorization' // 默认为Authorization
        }
      },
      watchLoggedIn: true,
      resetOnError: true,
      redirect: {
        login: '/login',
        logout: '/login',
        callback: '/login',
        home: '/templates'
      }
    },
    proxy: {...},
    router: {...}
  };

```

auth.strategies 对应需要 stratege 的 API 比如:

```js
this.$auth.loginWith(strategeName /* */);
this.$auth.login(/* */); // 此处没有选择登陆策略，则选择默认的
```

# 路由鉴权

没有登陆的话就跳转会 login 界面

```js
export default ({ store, route, redirect, $axios }) => {
  if (!route.fullPath.startsWith('/login') && !store.getters['auth/loggedIn']) {
    return redirect('/login');
  } else {
    ...
  }
};
```

# API 介绍

auth 模块全局注入，在 vue 页面中可以使用`this.$auth`来访问

## 属性

### user

这个对象存放已认证的 user 的信息比如名称，获取方式如下

```js
// 通过auth 模块获取
this.$auth.user;

// 通过vuex获取
this.$store.state.auth.user;
```

小结：
this.$auth 使用了vuex 作为全局状态管理，状态获取可以直接使用this.$auth 来访问 vuex 对应的 auth 模块，除此之外，还使用 storage 来做持久化处理

### loggedIn

boolean：用户是否认证成功，是否有效

## 方法

### 登出登入

#### loginWith(strategyName, ...args)

- returns Promise

```js
this.$auth
  .loginWith("local" /* .... */)
  .then(() => this.$toast.success("Logged In!"));
```

#### logout(...args)

- returns Promise
  登出操作

```js
await this.$auth.logout(/*...*/);
```

### user 相关

#### setUser(user)

保存用户数据，并更新状态为 login

```js
this.$auth.setUser(user);
```

### 用户权限相关

#### setUserToken(token)

- returns Promise
  设置 auth token 并且通过当前 token 和当前 strategy 来获取用户

```js
this.$auth.setUserToken(token).then(() => this.$toast.success("User set!"));
```

#### setToken(strategy, token)

全局更新 token

```js
// Update token
this.$auth.setToken("local", ".....");
```

#### fetchUser()

使用当前的 strategy 来重新获取 user 信息

```js
await this.$auth.fetchUser();
```

### plugin/auth.js

onRedirect(handler)：在重定向 url 前调用

```js
export default function ({ $auth }) {
  $auth.onRedirect((to, from) => {
    console.error(to);
    // you can optionally change `to` by returning a new value
  });
}
```

onError(handler) 认证错误处理

```js
export default function ({ $auth }) {
  $auth.onError((error, name, endpoint) => {
    console.error(name, error);
  });
}
```

# Storage

## Universal Storage

全局存储：一次存储，cookie，localStorage，vuex 中全部都存在

## Local state

获取方式：

```js
this.$auth.$state;
// OR
this.$auth.$storage.$state;
```

监听数据改变

```js
this.$auth.$storage.setState(key, val);
this.$auth.$storage.getState(key);

this.$auth.$storage.watchState("loggedIn", (newValue) => {});
```

## 设置 cookie

```js
this.$auth.$storage.setCookie(key, val, isJson);
this.$auth.$storage.getCookie(key);
```

## 设置本地存储

```js
this.$auth.$storage.setLocalStorage(key, val, isJson);
this.$auth.$storage.getLocalStorage(key);
```
