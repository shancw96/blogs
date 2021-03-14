---
title: Java persistence API 介绍
categories: [Java]
tags: [database]
toc: true
date: 2020/3/8
---

> [link](https://www.vogella.com/tutorials/JavaPersistenceAPI/article.html#jpaintro)

## 概览

java 对象与 数据库表的相互映射 叫做 对象关系映射(ORM - object relational mapping)。JPA 是一种 ORM 的一种。通过 JPA，开发者能够从数据库数据映射，存储，更新，恢复数据。JPA 能够在 JAVA-EE 和 JAVA-SE 项目中使用。

> 译者注： [java ee, java se, java me 区别](https://www.zhihu.com/question/31455874)

JPA 是一种规范，它有几种实现方式。最受欢迎的是[Hibernate](https://hibernate.org/)，EclipseLink and Apache OpenJPA

> 译者注: EclipseLink and Apache OpenJPA 现在已经处于淘汰状态

JPA 允许开发者直接和 java 对象交互，而不是通过 SQL 语句。

JAVA 对象和数据库表的映射通过持久性元数据定义。hibernate 等的 JPA 提供者使用元数据来执行正确的数据库操作

JPA 元数据通常通过 java 类的 annotation(注释)定义，除此之外，元数据还可以通过 XML 进行定义。如果 annotation 和 XML 都有，那么 XML 将会覆写 annotation

下面的定义基于 annotation 的使用：
JPA 定义了 类 SQL 的查询语言用于 静态/动态查询.

绝大多数的 JPA 持久化提供者，提供了基于元数据创建[数据库架构](https://en.wikipedia.org/wiki/Database_schema)的选项

## Entity 实体

一个应该被数据库保存的类，它必须通过 `javax.persistence.Entity`进行注解，一张表对应一个实体。

所有的实体类必须定义一个主键，并且有一个无参数的构造方法或者不是 final 修饰的类。

通过@GeneratedValue 能够在数据库中自动生成主键

默认情况下，类名对应表名，通过`@Table(name="NEWTABLENAME")`能够指定表名

## 字段持久性

Entity 实体的字段将会保存在数据库中，JPA 既可以使用你的实例变量也可以使用对应的 getters，setters 来访问字段。但是不能混合两种方式，如果要使用 setter 和 getter 方法，则 Java 类必须遵循 Java Bean 命名约定。JPA 默认会保留实体的所有字段，如果想要某一个字段不被保存，那么需要通过`@Transient` 标记

| annotation      | description                                                                             |
| --------------- | --------------------------------------------------------------------------------------- |
| @Id             | Identifies the unique ID of the database entry                                          |
| @GeneratedValue | Together with an ID this annotation defines that this value is generated automatically. |
| @Transient      | Field will not be saved in database                                                     |

## 关系映射

JPA 可以定义类与类之间的映射，对应的 annotation 如下

- @OneToOne 一对一
- @OneToMany 一对多
- @ManyToOne 多对一
- @ManyToMany 多对多

## JpaRepository 增删改查

- [SpringDataJpa：JpaRepository 增删改查](https://blog.csdn.net/fly910905/article/details/78557110)

- [JpaRepository documentation](https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/JpaRepository.html)

*

## 关联阅读

- [Hibernate 入门](https://hibernate.org/orm/documentation/getting-started/)
