---
title: 设计模式 - 发布订阅
categories: [设计模式]
tags: []
toc: true
date: 2021/1/7
---

```js
class Observer {
  constructor() {
    this._topics = {};
  }
  // 订阅：evtName fn: 执行evtName的自定义行为
  on(evtName, fn) {
    this._topics[evtName] = this._topics[evtName] || [];
    this._topics[evtName].push(fn);
  }
  // 发布
  emit(evtName) {
    if (!this._topics[evtName]) return;
    this._topics[evtName].forEach((fn) => fn());
  }
  // 清除指定项目
  off(evtName, offFn) {
    if (offFn) {
      const index = this._topics[evtName].findIndex((fn) => fn === offFn);
      this._topics[evtName] =
        index === -1
          ? this._topics[evtName]
          : [
              ...this._topics[evtName].slice(0, index),
              ...this._topics[evtName].slice(index + 1),
            ];
    } else {
      this._topics[evtName] = [];
    }
  }
}
const evtController = new Observer();
const testFn = () => {
  console.log("ababab");
};
const testFn2 = () => {
  console.log("cccccc");
};
evtController.on("test", testFn);
evtController.on("test", testFn2);

evtController.emit("test");

evtController.off("test", testFn2);

evtController.emit("test");
```
