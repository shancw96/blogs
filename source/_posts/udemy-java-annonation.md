---
title: Spring-learn -> 「IoC injection」 @Component, @AutoWired,@Scope
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

 <!--more--> 
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

## Autowiring 自动绑定

> 原始的注入方式可以参看: [前一篇文章](http://blog.limiaomiao.site/2021/03/08/udemy-java-spring-beans/)

### 构造函数注入 construction injection

1. 定义依赖接口和类

```java
// FortuneService.java
public interface FortuneService {
  public String getFortune();
}

// happyFortuneService.java
@Component
public class HappyFortuneService implements FortuneService {
  public String getFortune() {
    return "Today is your lucky day!"
  }
}
```

2. 在类中创造一个构造函数用于注入

```java
@Component
public class TennisCoach implements Coach {
  private FortuneService fortuneService;
  public TennisCoach(FortuneService theFortuneService) {
    fortuneService = theFortuneService
  }
}
```

3. 在类的构造函数中使用@AutoWired

```java
@Component
public class TennisCoach implements Coach {
  private FortuneService fortuneService;

+ @AutoWired
  public TennisCoach(FortuneService theFortuneService) {
    fortuneService = theFortuneService
  }
}
```

**theFortuneService 是如何实现正确传入 HappyFortuneService 实例的？**
Spring 会扫描 class，遇到带有@Component 注解的，会生成对应的 bean。

上述 HappyFortuneService 生成了一个 implement FortuneService
的 bean，

在 TennisCoach 中遇到了@AutoWired 注解，会传入实现了 FortuneService 接口的 实例，此处就是 HappyFortuneService

**如果存在多个 class implement 了 FortuneService，怎么处理**

<img src="multi-implements.png" />

使用`@Qualifier` 注解

```java
@Component
public class TennisCoach implements Coach {
  private FortuneService fortuneService;

+ @AutoWired
+ @Qualifier('happyFortuneService') // 想要指定的Bean Id
  public TennisCoach(FortuneService theFortuneService) {
    fortuneService = theFortuneService
  }
}
```

**为什么在构造函数上注释(committed)了@AutoWired 字段，还是可以正常执行自动绑定？**

```java
//@Autowired
public TennisCoach(FortuneService theFortuneService) {
    System.out.println(" theFortuneService " + theFortuneService);
    fortuneService = theFortuneService;
}
```

从 Spring 4.3 开始，如果目标 bean 仅定义一个以其开头的构造函数 @AutoWired 注解在构造函数上没有必要存在了。个人还是推荐写@AutoWired 因为更有可读性

[DOC reference](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-autowired-annotation)

### setter 注入 setter injection

```java
// FortuneService.java
@Component
public class TennisCoach implements Coach {
  private FortuneService fortuneService;

+ @AutoWired
  public void setFortuneService(FortuneService theFortuneService) {
    this.fortuneService = theFortuneService // 此处有this
  }
}
```

### 字段注入 field injection

利用了 java 的反射技术，不再需要 setter 方法

```java
@Component
public class TennisCoach implements Coach {
+ @AutoWired
  private FortuneService fortuneService;

}
```

### 3 种 injection 用哪种

喜欢哪个就用哪个，对我来说，field injection 最好
