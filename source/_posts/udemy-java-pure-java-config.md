---
title: Spring-learn ->3. Java 源码实现依赖注入
categories: [Java]
tags: [Spring]
toc: true
date: 2021/3/14
---

前面两篇学习了 完全XML 实现依赖注入和 XML文件搭配 annotation 实现依赖注入，这篇文章将介绍最后一种方式：纯Java 代码实现依赖注入

<!-- more -->

### Spring Configuration
1. 创建Java 类并使用@Configuration 注释

```java
@Configuration
public class SportConfig {

}

```
2. 添加 组件扫描 component scanning 支持@ComponentScan 

```java
  @Configuration
+ @ComponentScan("com.shancw.spring.demo")
  public class SportConfig {

  }

```
3. 读取Spring java 配置类
```java
AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(SportCofig.class);
```
4. 从spring 容器中获取相应的bean

```java
Coach theCoach = context.getBean("tennisCoach", Coach.class)
```

### Define Spring Beans

**手动生成实例并返回**

1. Define method to expose Bean &&  Inject Bean dependencies
  ```java
    @Configuration
    @ComponentScan("com.shancw.spring.demo")
    public class SportConfig {
  +   @Bean //swimCoach 方法名将会变成bean id
  +   @public Coach swimCoach() {
  +     SwimCoach mySwimCoach = new SwimCoach();
  +     return mySwimCoach; 
      }
    }

  ```

3. 读取Spring java 配置类
  ```java
  AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(SportCofig.class);
  ```
4. Retrieve bean from Spring container 

  ```java
  Coach theCoach = context.getBean("swimCoach", Coach.class)
  ```