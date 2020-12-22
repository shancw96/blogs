---
title: ts 基础
categories: [ts]
tags: []
toc: true
date: 2020/12/03
---

-------- latestUpdate: 2020/12/22 --------

## namespace - 一种灵活的模块化

namespace 是指内部模块化声明

### 什么叫内部模块化？和 modules（外部模块）有什么区别？

举个例子：有一个大仓库，仓库内部有很多的储物间。大仓库就是 modules，储物间就是 namespace

### 语法注意点

```ts
namespace Validation {
  // 1. namespace 通过export 对外暴露 指定变量，接口，甚至是class，用法于modules 一致
  export interface StringValidator {
    ...
  }
  // 2. namespace 内部可以 申明内部变量，并在需要对外暴露的对象内部进行使用
  const lettersRegexp = /^[A-Za-z]+$/
  const numberRegexp = /^[0-9]+$/
  export class ZipCodeValidator implements StringValidator {
    isAcceptable(s: string) {
      return s.length === 5 && numberRegexp.test(s)
    }
  }
}

// 调用
let validators: any = {}
validators['ZIP CODE'] = new Validation.ZipCodeValidator()
```

## 类型断言 as - 强制指定变量类型

当 TS 编译器没有我们更了解当前的类型的时候，使用 as 来告诉编译器 ”trust me, I know what I’m doing“，如下代码所示，显示的指定 someValue 为 string 类型

example1

```js
let someValue: unknown = "this is a string";

let strLength: number = (someValue as string).length;
```

example2

```js
interface Shape {
 color: string;
}

interface PenStroke {
 penWidth: number;
}

interface Square extends Shape, PenStroke {
 sideLength: number;
}

let square = {} as Square
```

这样在编译的时候就不会监测出错误，可以减少不必要的报错信息，**但是不能滥用**

## interface - 变量的类型清单

### interface 可以设置单个值作为类型

```js
interface ValidationSuccess {
  isValid: true;
  reason: null;
}
```

### Function Types: 函数类型

```js
interface SearchFunc {
  (source: string, subString: string): boolean; // 行参 : 返回值
}
```

### Class Types： ”类“类型

与 java 中 interface 的概念相同

使用 1: 基本

```js
interface ClockInterface {
  tick(): void;
}

class DigitalClock implements ClockInterface {
  constructor(h: number, m: number) {}
  tick() {
    console.log("beep beep");
  }
}
```

使用 2: 对构造函数添加限制

```js
interface ClockConstructor {
  new(hour: number, minute: number): ClockInterface;
}

interface ClockInterface {
  tick(): void;
}

const Clock: ClockConstructor = class Clock implements ClockInterface {
  constructor(h: number, m: number) {}
  tick() {
    console.log("beep beep");
  }
};
```

## Literal Types (Literal 单个，逐个)

literal 是 一种类型的具体某一个子集类型。如 "Hello World" 是 string 的一个子集类型。
TS 目前支持三种 literal 子集类型: string, number, boolean

String Literal Types：
`type Easing = 'ease-in' | 'ease-out' | 'ease-in-out'`

Numeric Literal Types
`type Dice = 1 | 2 | 3 | 4 | 5 | 6 ` // 这个可能无效

```js
function rollDice(): 1 | 2 | 3 | 4 | 5 | 6 {
  return (Math.floor(Math.random() * 6) + 1) as 1 | 2 | 3 | 4 | 5 | 6;
}

const result = rollDice();
```

Boolean Literal Types

```js
interface ValidationSuccess {
  isValid: true;
  reason: null;
}

interface ValidationFailure {
  isValid: false;
  reason: string;
}

type ValidationResult = ValidationSuccess | ValidationFailure;
```

## TS-Class

### Public, private, and protected 修饰符

class 的变量默认情况下都为 public，使用 private 关键字可以设置 class 的私有变量

```js
class Animal {
  private name: string;

  constructor(theName: string) {
    this.name = theName;
  }
}

new Animal("Cat").name;
>> Property 'name' is private and only accessible within class 'Animal'.
```

**private** 变量只能够在**当前 class 内部**获取
注意：内部是指： 不能通过 subClassInstance.privateXXX 获取到对应的值
**protected** 关键字标记的变量，能够由**当前 class** 或者**他的 subClass 内部** 获取

```js
class Person {
  protected name: string;
  constructor(name: string) {
    this.name = name;
  }
}

class Employee extends Person {
  private department: string;

  constructor(name: string, department: string) {
    super(name);
    this.department = department;
  }

  public getElevatorPitch() {
    return `Hello, my name is ${this.name} and I work in ${this.department}.`;
  }
}

let howard = new Employee("Howard", "Sales");
console.log(howard.getElevatorPitch());
console.log(howard.name);
>> Property 'name' is protected and only accessible within class 'Person' and its subclasses.
```

### readonly 修饰符：必须有初始化值

```js
class Octopus {
  readonly name: string;
  readonly numberOfLegs: number = 8;

  constructor(theName: string) {
    this.name = theName;
  }
}

```

### abstract classes 抽象类

abstract class 用于抽象描述一个类是什么样子，具有哪些方法。

#### abstract class 和 interface 之间的区别？

abstarct class 体现了一种继承关系 "xxx is a", 而 interface 则强调 "xxx like a"
--- 以下内容摘录于[深入理解 abstract class 和 interface -- IBM Development 邓辉、孙鸣](https://developer.ibm.com/zh/articles/l-javainterface-abstract/)

考虑这样一个例子，假设在我们的问题领域中有一个关于 Door 的抽象概念，该 Door 具有执行两个动作 open 和 close，此时我们可以通过 abstract class 或者 interface 来定义一个表示该抽象概念的类型，定义方式分别如下所示：

使用 abstract class 方式定义 Door：

```java
abstract class Door {
  abstract void open();
  abstract void close()；
}
```

使用 interface 方式定义 Door：

```java
interface Door {
  void open();
  void close();
}
```

其他具体的 Door 类型可以 extends 使用 abstract class 方式定义的 Door 或者 implements 使用 interface 方式定义的 Door。看起来好像使用 abstract class 和 interface 没有大的区别。

**如果现在要求 Door 还要具有报警的功能。我们该如何设计针对该例子的类结构呢**（在本例中，主要是为了展示 abstract class 和 interface 反映在设计理念上的区别，其他方面无关的问题都做了简化或者忽略）？下面将罗列出可能的解决方案，并从设计理念层面对这些不同的方案进行分析。

**解决方案一：**
简单的在 Door 的定义中增加一个 alarm 方法，如下：

```java
abstract class Door {
  abstract void open();
  abstract void close()；
  abstract void alarm();
}
```

或者

```java
interface Door {
  void open();
  void close();
  void alarm();
}
```

那么具有报警功能的 AlarmDoor 的定义方式如下：

```java
class AlarmDoor extends Door {
  void open() {... }
  void close() {... }
  void alarm() {... }
}
```

或者

```java
class AlarmDoor implements Door ｛
    void open() {... }
    void close() {... }
    void alarm() {... }
｝
```

这种方法**违反了面向对象设计中的一个核心原则 ISP（Interface Segregation Priciple）**，**在 Door 的定义中把 Door 概念本身固有的行为方法和另外一个概念”报警器”的行为方法混在了一起**。这样引起的一个问题是那些仅仅依赖于 Door 这个概念的模块会因为”报警器”这个概念的改变（比如：修改 alarm 方法的参数）而改变，反之依然。

**解决方案二：**

AlarmDoor 在概念本质上是 Door，同时它有具有报警的功能。我们该如何来设计、实现来明确的反映出我们的意思呢？前面已经说过，abstract class 在 Java 语言中表示一种继承关系，而继承关系在本质上是”is a”关系。所以对于 Door 这个概念，我们应该使用 abstarct class 方式来定义。另外，AlarmDoor 又具有报警功能，说明它又能够完成报警概念中定义的行为，所以报警概念可以通过 interface 方式定义。如下所示：

```java
abstract class Door {
  abstract void open();
  abstract void close()；
}
interface Alarm {
  void alarm();
}
class AlarmDoor extends Door implements Alarm {
  void open() {... }
  void close() {... }
  void alarm() {... }
}
```

这种实现方式基本上能够明确的反映出我们对于问题领域的理解，正确的揭示我们的设计意图。其实 **abstract class 表示的是”is a”关系，interface 表示的是”like a”关系**，大家在选择时可以作为一个依据，当然这是建立在对问题领域的理解上的，比如：**如果我们认为 AlarmDoor 在概念本质上是报警器，同时又具有 Door 的功能，那么上述的定义方式就要反过来了**。

### 使用 class 作为接口

当 class 申明的时候做了两件事。1: 类型申明(一个代表 class 实例的类型) 2. 创建构造函数

```js
class Point {
  x: number;
  y: number;
}

interface Point3d extends Point {
  z: number;
}

let point3d: Point3d = { x: 1, y: 2, z: 3 };
```

## 枚举

枚举类型分为 num 枚举, string 枚举, 混合枚举（不推荐使用）。枚举的成员可以通过计算得出

## Generics 泛型

TODO...
