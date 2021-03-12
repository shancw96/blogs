---
title: Spring-learn -> annotation
categories: [java]
tags: [Spring]
toc: true
date: 2021/3/11
---

## 什么是 Java 的 annotation

- 被加到 Java 类上的 特殊的 label/marker

* 给类提供元数据(meta-data)

- 在编译阶段加载 或者 在运行时用于特殊处理

如 `@Override`，告诉编译器，这个方法会覆写 implement 或者 extends 的方法，于是在编译阶段，编译器会检查 override 是否正确

```java
@Override
public String getDailyWorkout() {
  return "Run a hark 5k"
}
```

## 为什么要在 Spring 配置中使用 Annotation

- XML 配置非常冗长

- annotation 可以用来配置 Spring bean

* annotation 简化了 XML 的配置

## annotation 是怎么实现简化 XML 配置的: Scanning class

- Spring 会扫描你的 Java class 来查看是否存在 annotation

* 如果存在 annotation，那么会自动在 Spring 容器中注册 annotation 对应的 bean

## @Component

### 在 Spring 配置文件中启用 component Scanning

```xml
<beans ...>
  <context:component-scan base-package="com.shancw.springdemo">
</beans>
```

### 在类中使用@Component annotation

```java
@Component("thatSillyCoach") //thatSillyCoach 是bean id
public class TennisCoach implements Coach {
  @Override
  public String getDailyWorkout() {
    return "practice your backend volley"
  }
}
```

### 使用自动注册的 bean。retrieve bean from Spring container

```java
Coach theCoach = context.getBean("thatSillyCoach", Coach.class);
```

### 默认名称

如果不指定 bean id 那么 spring 会自动生成一个默认的 bean id 就是类名

```java
@Component //TennisCoach 是bean id
public class TennisCoach implements Coach {
  @Override
  public String getDailyWorkout() {
    return "practice your backend volley"
  }
}
```

## @Autowiring

- 构造函数注入 construction injection
- setter 注入 setter injection
- 字段注入 field injection

原始的注入方式可以参看前一篇文章
