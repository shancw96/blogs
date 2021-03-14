---
title: Spring-learn -> beans与IoC
categories: [Java]
tags: [Spring]
toc: true
date: 2021/3/8
---

- 主要功能：
  - 创建和管理对象(Inversion of Control)
  - 为对象注入依赖(Dependency Injection)

 <!--more--> 
## Spring 开发流程

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

## FAQ: 什么是 Spring Bean?

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

## Dependency Injection 依赖注入

<img src="dependence-injection.jpg">
你要买辆车，这辆车在工厂里制造，厂家直销，你必须要和工厂直接说出需求。在工厂里有各种各样不同的配件，比如引擎，椅子，方向盘等等。你只需要做出选择，这些配件就会由工程师组装在车上。

**这里的车配件就是各种依赖，你做出选择就是在进行依赖注入**

### constructor injection

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

### Setter Injection

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

### Literal Values injection 字段注入

1. 为 injection 创建 setter methods

```java
public class CircleCoach {

    private String emailAddress;

    public void setEmailAddress(String address) {
        this.emailAddress = address;
    }
}
```

2. 在 Spring 配置文件中配置注入

```xml
<property name="emailAddress" value="shancw1996@gmail.com"></property>
```

## Bean lifeCycle 和 scope

### bean scope

Spring 的 Bean 默认情况下都是单例模式，但是可以通过 scope 属性进行配置，配置项如下

| scope          | Description                                    |
| -------------- | ---------------------------------------------- |
| singleton      | 单例模式，默认 scope                           |
| prototype      | 每个 container 调用都会创建一个新的 bean       |
| request        | 这个 bean 仅对 HTTP 请求生效                   |
| session        | 这个 bean 仅对 HTTP web session 生效           |
| global-session | 这个 bean 仅对一个全局的 HTTP web session 生效 |

```xml
<beans ...>
    <bean id="myCoach" class="com.shancw.springdemo.TrackCoach" scope="singleton"></bean>
</beans>
```

### bean Lifecycle

<img src="bean-lifecycle.png"  alt="bean-lifecycle">

bean 配置

```xml
<beans>
    <bean id="myCoach" class="com.shancw.springdemo.TrackCoach" init-method="doMyStartupStuff" destroy-method="clearMyStuff">
</beans>
```

init-methods 和 destroy-method 名称没有任何限制，但是不能传入参数。

java 代码编写

```java
public class TrackCoach {
    ...

    // init-method
    public void doMyStartupStuff() {
        // write you code here
    }

    // destroy-method
    public void clearMyStuff() {
        // write you code here
    }
}
```

**_For "prototype" scoped beans, Spring does not call the destroy method. Gasp! _**
