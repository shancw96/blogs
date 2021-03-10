---
title: Spring-learn-IoC
categories: [Java]
tags: [Spring]
toc: true
date: 2021/3/8
---

## Spring Container

- 主要功能：
  - 创建和管理对象(Inversion of Control)
  - 为对象注入依赖(Dependency Injection)

### Spring Ioc (Inversion of Control 控制反转)

<img src="Spring-container.png" alt="Spring inversion of control">

#### 配置 Spring 容器(spring container)

- XML 文件：过时的方法
- Java annotation: java 注释
- Java Source code

### Spring 开发流程

1. 配置 Spring Beans

```XML
<bean id="myCoach" class="com.shancw.springdemo.BaseballCoach">
</bean>
```

2. 创建 Spring 容器 ApplicationContext

```java
ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml")
```

3. 从 Spring 容器中取回特定 bean

```java
Coach theCoach = context.getBean("myCoach", Coach.class);
```

**example code**

```java
// main.java
import com.shancw.springdemo.Coach;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class HelloSpringApp {
    public void main(String[] args) {
        // load the spring configuration file
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext");
        // retrieve bean from spring container
        Coach theCoach = context.getBean("myCoach", Coach.class);
        // call methods on the bean
        System.out.println(theCoach.getDailyWorkout());
        // close the context
        context.close();
    }
}
```

```xml
<!-- applicationContext.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- Define your beans here -->
    <bean id="myCoach" class="com.shancw.springdemo.TrackCoach"></bean>
</beans>
```

### FAQ: 什么是 Spring Bean?

Spring Bean 就是一个由 Spring 容器创建的 Java 对象。

**code example**
bean myFortuneService

```xml
<bean id="myFortuneService" class="com.shancw.springdemo.HappyFortuneService"></bean>
```

等价于 new HappyFortuneService

```java
HappyFortuneService myFortuneService = new HappyFortuneService();
```

bean myCoach

```xml
<bean id="myCoach" class="com.shancw.springdemo.BaseballCoach">
    <constructor-arg ref="myFortuneService"></constructor-arg>
</bean>
```

等价于

```java
BaseballCoach myCoach = new BaseballCoach(myFortuneService)
```

<img src="ioc.jpg">

### Dependency Injection 依赖注入

<img src="dependence-injection.jpg">
你要买辆车，这辆车在工厂里制造，厂家直销，你必须要和工厂直接说出需求。在工厂里有各种各样不同的配件，比如引擎，椅子，方向盘等等。你只需要做出选择，这些配件就会由工程师组装在车上。

**这里的车配件就是各种依赖，你做出选择就是在进行依赖注入**

#### constructor injection

配置 bean

```xml
<!-- Define your beans here -->
<bean id="myFortuneService" class="com.shancw.springdemo.HappyFortuneService"></bean>
<bean id="myCoach" class="com.shancw.springdemo.BaseballCoach">
+    <constructor-arg ref="myFortuneService"></constructor-arg>
</bean>
```

文件使用

```java
// BaseballCoach.java
package com.shancw.springdemo;

public class BaseballCoach implements Coach {
    // inject dependence
    private FortuneService fortuneService;
    // constructor
    public BaseballCoach(FortuneService theFortuneService) {
        fortuneService = theFortuneService;
    }
}

```

#### Setter Injection

配置 bean

```xml
<!-- 服务 -->
<bean id="myFortuneService" class="com.shancw.springdemo.HappyFortuneService"></bean>
<!-- setter service
    id 为 bean 对象的名称
    class 为文件class名称
    CircketCoach myCircketCoach = new CircketCoach()
 -->
<bean id="myCircketCoach" class="com.shancw.springdemo.CircketCoach">
    <!-- 配置 setter injection
        name 为需要注入的属性名称
        ref 为需要调用的bean 名称
        myCircketCoach.setFortuneService(myFortuneService)
    -->
    <property name="fortuneService" ref="myFortuneService"></property>
</bean>
```

文件使用

```java
public class CircleCoach {
    ...
    private FortuneService fortuneService;
    ...

    // setter injection
    public void setFortuneService(FortuneService fortuneService) {
        this.fortuneService = fortuneService;
    }
}
```

<img src="setter-injection.png">
