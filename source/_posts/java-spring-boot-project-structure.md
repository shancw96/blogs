---
title: Spring-boot 项目结构 best Practice
categories: [java]
tags: [Spring Boot]
toc: true
date: 2021/3/24
---

这篇文章介绍了 Spring Boot 项目的分层 和 具体目录结构
![spring boot的项目结构](/images/spring-boot-structure.png)
![sprint boot分层](/images/spring-boot-data-flow.png)

<!-- more -->

## Models & DTOs

Models: 数据库实体层，也被称为 entity 层，pojo 层

Data Transfer Object（数据传输对象）:用于在不同进程间传输 data。

设计 DTO 的动机：进程间的数据交互通常通过昂贵的远程 interface 实现（比如 web Service），DTO 通过聚合多次请求，只发送一次实际的请求。DTO 在实际项目使我们仅传输需要与用户界面共享的数据，而不传输我们可能已经使用多个子对象聚合并保存在数据库中的整个模型对象

> pojo: plain old java Object - 普通的 java 对象

## DAOs

在传统的多层应用程序中，通常是 Web 层调用业务层，业务层调用数据访问层。业务层负责处理各种业务逻辑，而数据访问层只负责对数据进行增删改查。

编写数据访问层的时候，可以使用 DAO 模式。DAO 即 Data Access Object 的缩写，它没有什么神秘之处，实现起来基本如下：

```java
public interface AgencyRepository extends MongoRepository<Agency, String> {
    Agency findByCode(String agencyCode);

    Agency findByOwner(User owner);

    Agency findByName(String name);
}
```

DAOs 放在 repository package 下，他们是 MongoRepository 接口的扩展，帮助 service 层 从 数据库中取回/存储数据

## Security

安全项配置放在 config package 下，但是具体的配置文件放在 security package 下。一个应用可能有多个不同的安全配置项，如 sessionID + cookies 或者 JWT token 认证

## controllers

从拦截请求到准备好响应并将其发送回去，它将所有内容绑定在一起
