---
title: java8 查漏补缺
categories: [后端]
tags: [java]
toc: true
date: 2021/8/3
---

这篇文章记录了 java8 基础知识。长期更新

<!-- more -->

# 数据类型与运算符

## java 中基本数据类型分为 8 中：

- 整数类型为： byte short int Long
  - byte: `-2^8 ~ 2^8 - 1`
  - short: `-2^(8*2) ~ 2^(8*2) -1`
  - int: `-2^(8*2*2) ~ 2^(8*2*2)` -2147483648 ~ 2147483647
  - long: `-2^(8*2*2*2) ~ 2^(8*2*2*2)`，使用 long 需要使用 l 标注,如 2000l
- 浮点型： float double
  - 默认为 double，使用 float 的话需要通过 f 标注,比如 12.01f
  - double 小数范围为 64，float 为 32
  - 所有的数学函数运算都是 double
- 布尔值： boolean
- 字符：char

> 一般不将 char 作为归类为整数类型,char 使用 unicode 对应的数字来描述单个字符。从严格意义上来说它也属于整数类型

**数值类型混合计算**

规则：

首先

- A: 所有的 char byte short 被升级为 int。

其次

- B:如果有一个操作数是 long，整个表达式全部升级为 long
- C:如果有一个操作数是 float，那么整个表达式就全部升级为 float
- D:如果有一个操作数是 double，那么整个表达式就全部升级为 double

需要注意的是，上述类型升级只应用于表达式内。在表达式外，该变量并没有任何不同。

```java
byte b;
int i;

b = 10;
i = b * b;// 不需要强制转换，b*b 执行规则A，自动转换成int

b = 10;
b = (byte) (b*b) // b * b 执行规则A，自动转换成int,将int赋值给byte 需要强制转换
```

## 引用数据类型

**为什么引用类型的比较需要使用 equals？**

以字符串为例，equals 比较的是两个 String 对象的字符串序列是否相等，而 == 比较的是两个变量引用的是否为同一个变量。

**字符串是不可变的，如何创建可变字符串？**
使用 StringBuffer 类，它创建的字符串对象是可以改变的。它提供 setCharAt 方法用于在字符串中设置字符。Java 还提供了与 StringBuffer 相关的类 StringBuilder，该类创建的字符串对象也是可以改变的。

## 短路逻辑运算符与普通运算符的区别

对于普通逻辑运算符 `condition1 & condition2` ，即使 condition1 为 false，也会运行 condition2。
对于短路逻辑运算符 `condition1 && condition2` ，如果 condition1 为 false，那么剩余的 condition2 就不会继续执行。

# 包，类，接口

**protect,public,private 有什么区别？**

| \*                 | private | 默认 | protect | public |
| ------------------ | ------- | ---- | ------- | ------ |
| 同一个类中可见     | 是      | 是   | 是      | 是     |
| 同一个包下的子类   | 否      | 是   | 是      | 是     |
| 同一个包中的非子类 | 否      | 是   | 是      | 是     |
| 不同包的子类       | 否      | 否   | 是      | 是     |
| 不同包的非子类     | 否      | 否   | 否      | 是     |

**接口如何定义？**

```java
access interface name {
  ret-type method-name1 (param-list);
  ret-type method-name2 (param-list);
  type var1 = value;
  type var2 = value;
  // ...
  ret-type method-nameN(param-list);
  type varN = value;
}
```

access 字段：
access 字段要么是 public，要么不实用。
