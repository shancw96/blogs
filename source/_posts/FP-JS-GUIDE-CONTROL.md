---
title: FP 指北 - BASIC
categories: [Functional Programming]
tags: []
toc: true
date: 2020/8/9
---

函数式编程属于 declarative Programming，declarative Programming 即声明式编程。

## 注重描述过程而不是具体怎么去实现

> StackOverFlow[Declarative programming is when you write your code in such a way that it describes what you want to do, and not how you want to do it](https://stackoverflow.com/questions/129628/what-is-declarative-programming)，

举个例子，SQL 是典型的声明式语言，告诉计算机我想干嘛，具体的实现由计算机去是实现。如下 sql 查询例子。

```sql
SELECT * FROM Websites;
WHERE score >= 80;
```

### 使用现成的库来在日常开发中贴近声明式

但是在日常开发中，有很多特定的数据处理操作，是使用语言本身没有提供的，这时候就需要我们自己去构建，也就是通常说的造轮子。
幸运的是，大部分的轮子都有现成的库提供，如 Lodash 和 Ramda。个人喜好 Ramda 多点。Lodash 和 Ramda 相比更像是一个 utils

### 日常开发

命令式的思想

```js
async function showStudent(ssn) {
  const student = await db.get(ssn);
  if (student) {
    document.querySelector(
      `#${elementId}`
    ).innerHTML = `${student.ssn}, ${student.firstname}, ${student.lastname}`;
  } else {
    throw new Error("student not Found");
  }
}
```

声明式的思想

```js
// STEP1 构思控制流
const showStudent = _.compose(
  findFromDB("xxx"),
  remakeName,
  addToDom("#student-info")
);

// STEP2 控制块具体实现
const findFromDB = _.curry((db, id) => {
  const result = db.get(id); // 为了更加通用不使用student 作为变量名
  if (!result) throw new Error("Object not Found");
});

const remakeName = (student) =>
  `${student.ssn}, ${student.firstname}, ${student.lastname}`;

const addToDom = (document.querySelector(elementId).innerHTML = info);

// STEP 3  执行
showStudent("8888-888-88");
```

## 无副作用

### 什么叫副作用？

> In computer science, a function or expression is said to have a side effect if it modifies some state outside its scope or has an observable interaction with its calling functions or the outside world.

上面说的简单来说就是，如果一个函数直接修改函数体外部的变量或者是做了 I/O 操作就属于有副作用的函数。

个人理解是 直接修改外部变量，或者做了 I/O，异步等操作可能会导致程序出现预期意外的结果，这些可能性统称为副作用

# 控制流

## I combinator identity :: a -> a

## K combinator tap :: (a -> \*) -> a -> a

可以讲 debug 函数 插入 控制流中，例如

```js
const debug = R.tap(debugLog);
const cleanInput = R.compose(normalize, debug, trim);
const isValidSsn = R.compose(debug, checkLengthSsn, debug, cleanInput);
```

## S combinator

接收多个函数作为参数，并且返回一个新的函数。即 compose
compose 一般与 curry 搭配使用构建控制流

```js
compose(
  curry(fn1(essentialParameter)),
  curry(fn2(essentialParameter)),
  curry(fn3(essentialParameter))
);
```

## Fork combinator

接收三个函数作为参数 joinFn, operateFn1, operateFn2。

```js
a = operateFn1(ori);
b = operateFn2(ori);
result = joinFn(a, b);

----------------------------------
              input
                |
      ---------------------
      |                   |
     fn1                 fn2
      |                   |
      ----------|----------
              joinFn
                |
              outPut
```

<img src="forkCombinator" alt="fork combinator">
