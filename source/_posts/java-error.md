---
title: Java 中异常处理
categories: [后端]
tags: []
toc: true
date: 2021/05/03
---

![](/images/java/error-system.png)

所有的异常由 Throwable 继承而来，在下一级分为 Error 和 Exception(异常)。

Error 层：Java 运行时系统的内部错误和资源耗尽错误。应用程序不需要管

Exception 层：是开发需要管的层次，分为程序 bug 导致的 RuntimeException 和 其他异常（网络请求错误，I/O 错误）

Java 将派生于 Error 类和 RuntimeException 类的异常称为 unchecked 异常。其他异常被称为 checked 异常

通常，应该捕获那些知道如何处理的异常 try...catch，而将不知道如何处理的异常传递出去 throws

<!-- more -->

## 申明已检查异常

一个方法应该再其头部申明所有可能抛出的异常，比如

这个方法产生一个 FileInputStream 对象，但是也可能抛出 FileNotFoundException 异常

```java
public FileInputStream readFile(String name) throws FileNotFoundException
```

如果一个方法可能抛出多个异常，那么通过逗号，将不同异常隔开

```java
public FileInputStream readFile(String name) throws FileNotFoundException， EOFException, xxxException {

}
```

但是不需要申明 Java 的 unchecked 异常：内部错误 Error 和 RuntimeException

## 捕获异常

- 在一个 try 愉快可以捕获多个异常类型

  ```java
  try {
    xxx
  }
  catch(ExceptionXXX e1) {

  }
  catch(ExceptionYYY e1) {

  }
  catch(ExceptionZZZ e1) {

  }
  ```

* 再次抛出异常，改变异常类型
  ```java
  try {
    ...
  }catch(SQLException e) {
    Throwable se = new ServleException("database error");
    se.initCause(e);
    throw se;
  }
  ```

## TODO: spring-boot 中自定义封装错误
