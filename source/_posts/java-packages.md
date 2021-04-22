---
title: Spring Boot 常用annotation
categories: [后端]
tags: [Spring Boot]
toc: true
date: 2021/3/7
updated: 2021/3/29
---

这里记录了遇到的 annotation

 <!--more-->

- java.util.Objects 学习
  - Object.equals 和普通的"=="判断有什么区别

* db 相关

  +`@JsonIgnoreProperties` 转换实体时忽略 json 中不存在的字段 [link](https://fasterxml.github.io/jackson-annotations/javadoc/2.6/com/fasterxml/jackson/annotation/JsonIgnoreProperties.html)

- mongoDB 相关
  - @DBRef: 设置对象之间的关联 https://blog.csdn.net/coolcaosj/article/details/22915455

* @Controller 添加在类上，表示这是 controller 对象

  - name 属性：该 controller 对象的 bean 名称

## web 开发

- @RestController = @Controller + @ResponseBody 组合
  return 返回的结果，会经过 JSON 序列化，最终返回
- @crossOrigin
  允许跨域

* @RequestMapping 将特定 url 的 请求绑定到当前 类/方法 上
  - path 属性：接口路径。[] 数组，可以填写多个接口路径。
  - values 属性：和 path 属性相同，是它的别名。
  - method 属性：请求方法 RequestMethod ，可以填写 GET、POST、POST、DELETE 等等。[] 数组，可以填写多个请求方法。如果为空，表示匹配所有请求方法

- @GetMapping 注解：对应 @GET 请求方法的 @RequestMapping 注解。
- @PostMapping 注解：对应 @POST 请求方法的 @RequestMapping 注解。
- @PutMapping 注解：对应 @PUT 请求方法的 @RequestMapping 注解。
- @DeleteMapping 注解：对应 @DELETE 请求方法的 @RequestMapping 注解。

* @RequestParam 注解：请求参数
  - name 属性：对应的请求参数名。如果为空，则直接使用方法上的参数变量名。
  - value 属性：和 name 属性相同，是它的别名。
  - required 属性：参数是否必须传。默认为 true ，表示必传。
  - defaultValue 属性：参数默认值。

- @RequestBody
  Annotation indicating a method parameter should be bound to the body of the web request.
- @ResponseBody
  Annotation indicating a method parameter should be bound to the body of the web request.

- org.springframework.web.util.HtmlUtils 了解

  - htmlEscape
