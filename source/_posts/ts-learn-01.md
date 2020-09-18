---
title: ts 简单入门
categories: [typescript]
tags: []
toc: true
date: 2020/9/13
---

## types

基础 Boolean, Number, String, Array, Object, Undefined, Null

新增:

1. Tuple 元组 （限制类型，长度的 Array）
2. Enum 枚举 类似于 dictionary
3. Any 任何类型的超集
4. Void 一般用作无返回值

## interface

当传入一个对象做函数参数的时候，嵌套定义非常麻烦，于是出现了 interface

- 可选属性使用 名称+问号的形式
- 只读属性：readOnly
-

```ts
interface labeledValue {
  label: string;
  optional?: number;
  readOnly: number;
}

function printLabel(labeledObj: LabeledValue) {
  console.log(labeledObj.label);
}
```

## functions

可选参数和默认值的类型推导一致：`(firstName: string, lastName?: string) => string`.

```js
function buildName(firstName: string, lastName?: string) {
  // ...
}
function buildName(firstName: string, lastName = "Smith") {
  // ...
}
```

Rest 操作符设置参数

```ts
function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}

// employeeName will be "Joseph Samuel Lucas MacKinzie"
let employeeName = buildName("Joseph", "Samuel", "Lucas", "MacKinzie");
```

## overload

```ts
type tagName = "img" | "input"; // 自己定义一种新的类型，独立于基本类型外
function createElement(tagName: "img"): HTMLImageElement;
function createElement(tagName: "input"): HTMLInputElement;
// ... more overloads ...
function createElement(tagName: string): Element {
  // ... code goes here ...
}
```

## Enums

### numeric enums

```ts
enum Direction {
  Up = 1,
  Down, // 2
  Left, //3
  Right, //4
}

enum Direction {
  Up, // 0
  Down, // 1
  Left, // 2
  Right, // 3
}
```

### String enums

```ts
enum Direction {
  Up = "UP",
  Down = "DOWN",
  Left = "LEFT",
  Right = "RIGHT",
}
```

### 混合 enums ：String | Number

```ts
enum BooleanLikeHeterogeneousEnum {
  No = 0,
  Yes = "YES",
}
```

## 泛型

```ts
function identity(arg: number): number {
  return arg;
}

--- 如果我们想要这个函数对其他的类型也生效，并且方便复用,可以使用any
function identity(arg: any): any {
  return arg;
}
--- any 会导致前后传入的参数类型可能不一致，所以使用一个通用的方式
function identity<T>(arg: T): T {
  return arg;
}

```
