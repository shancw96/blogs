---
title: cloudExpress 开发 01 宏观架构
categories: [React]
tags: []
toc: true
date: 2020/9/9
---

CLI 为 create-react-app

## eslint 开启

> 基于 create-react-app 不需要手动安装 eslint

```js
{
  "extends": ["react-app"],
  "plugins": ["react", "react-hooks"],
  "rules": {
    "no-console": "warn",
    "valid-jsdoc": "warn",
    "react-hooks/rules-of-hooks": "warn", // 检查 Hook 的规则
    "react-hooks/exhaustive-deps": "warn" // 检查 effect 的依赖
  }
}
// package.json
"eslint-config-react-app": "^5.2.1",
"eslint-plugin-react": "^7.20.6",
"eslint-plugin-react-hooks": "^4.1.0"
```

## redux 基础设置构建

store 文件夹
-store

- actions（异步/副作用在这里执行）: 描述了有事情发生了这一事实，并没有描述应用如何更新 state
- reduers（纯函数）: 指定了应用状态的变化如何响应 actions 并发送到 store
  ```js
  (previousState, action) => newState;
  ```
- modules：按模块拆分
- store.js：入口文件，生成 store,此处可以引入中间件,如处理异步请求的 redux-chunk

[✈️ 为什么要使用 redux-thunk：](https://cn.redux.js.org/docs/advanced/AsyncActions.html)action 本质上是同步的，如果想要处理异步请求，则需要在 reducer 和 action 之间加一个过度 thunk，用来缓冲，这就是 redux-thunk 的存在意义

```js
import { createStore, applyMiddleware } from "redux";
import thunkMiddleware from "redux-thunk";
import rootReducers from "./reducers/root";
const store = createStore(rootReducers, applyMiddleware(thunkMiddleware));

store.subscribe(() => {});

export default store;
```

Redux 的数据流

1. 调用 store.dispatch(action)
2. Redux store 调用传入的 reduer 函数
3. 根 reducer 应该把多个子 reducer 输出合并成一个单一的 state 树。
4. Redux store 保存了根 reducer 返回的完整 state 树。

## Router

> App.js 主要用于路由设置

需要的 package

- react-router-dom
- react-router

### Switch 组件

> <Switch> looks through its children <Route>s and renders the first one that matches the current URL.

Switch 和 js 中 switch 的作用相同，在 switch 的子路由中 匹配当前 url

例子：
当匹配到 / 则执行 PrivateRoute 的规则判断
当匹配到 /login 则执行 AccountRoute 的规则判断

```js
<Router>
  <Switch>
    <PrivateRoute path="/">
      <Admin />
    </PrivateRoute>
    <AccountRoute path="/login">
      <Login />
    </AccountRoute>
  </Switch>
</Router>
```

#### 使用自定义路由实现简单的组件鉴权

```js
// PrivateRoute.jsx
export default function PrivateRoute({ children, ...rest }) {
  // children: React.Element
  // rest: computedMatch: {path, url, isExact, params}, location: {}, path

  const account = useSelector((state) => state.account);
  return (
    <Route {...rest} render={() => (account.email ? children : <Login />)} />
  );
}
```

> render:func 行内渲染函数
