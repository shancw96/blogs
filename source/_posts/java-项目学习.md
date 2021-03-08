---
title: Spring Boot 开发用到的package
categories: [Java]
tags: [Spring Boot, dev]
toc: true
date: 2021/3/7
---

- 注释：org.springframework.web.bind.annotation

  - crossOrigin
    Annotation for permitting cross-origin requests on specific handler classes and/or handler methods.
  - PostMapping
    Annotation for mapping HTTP POST requests onto specific handler methods.
  - RequestBody
    Annotation indicating a method parameter should be bound to the body of the web request.
  - ResponseBody
    Annotation indicating a method parameter should be bound to the body of the web request.

- org.springframework.web.util.HtmlUtils 了解

  - htmlEscape

- java.util.Objects 学习
  - Object.equals 和普通的"=="判断有什么区别

* db 相关

  +`@JsonIgnoreProperties` 转换实体时忽略 json 中不存在的字段 [link](https://fasterxml.github.io/jackson-annotations/javadoc/2.6/com/fasterxml/jackson/annotation/JsonIgnoreProperties.html)
