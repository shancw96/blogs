---
title: 设计模式 - 单例
categories: [设计模式]
tags: []
toc: true
date: 2021/1/31
---

> 单例模式，也叫单子模式，是一种常用的软件设计模式，属于创建型模式的一种。在应用这个模式时，单例对象的类必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局对象，这样有利于我们协调系统整体的行为

```typescript
class Singleton {
  private static instance: Singleton;
  constructor(config: any) {
    if (!Singleton.instance) {
      Singleton.instance = this.createInstance(config);
    }
    return Singleton.instance;
  }

  private createInstance() {}

  methodA() {}
  methodB() {}
}
```
