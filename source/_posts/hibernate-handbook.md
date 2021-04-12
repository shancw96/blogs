---
title: hibernate 基础
categories: [java]
tags: [hibernate]
toc: true
date: 2021/4/6
updated: 2021/4/12
---

这篇文章介绍了 hibernate 的日常使用

<!-- more -->

JDBC: java database connectivity

我们使用 JDBC 来 连接 java 和 database。JDBC 需要开发自己去写 SQL 语句。

hibernate 在 JDBC 的基础上，抽象了 SQL 操作，在不写 SQL 的情况下，将 java 和 database 关联起来

ORM(Object Relation Mapping)

## oneToMany

学生和笔记本的关系:

1. 一个学生可以有多个笔记本
2. 一个笔记本只能对应一个学生

```java
@Getter
@Setter
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long rollno;

    private String name;

    private int marks;

    @OneToMany
    private List<Laptop> laptop = new ArrayList<>();
}

@Getter
@Setter
@Accessors
@Entity
public class Laptop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lid;

    private String lname;
}
```

生成的 ER 图如下
![](/images/hibernate/oneToMany.png)

此时会产生一个中间表 student_laptop，用于关联，如果不想生成中间表，则需要用到 mappedBy 将当前的 student 映射到每一台 laptop 上
![](/images/hibernate/oneToMany-mappedBy.png)

## ManyToMany

多对多必须要借助中间表实现，如果不使用 mappedBy 会生成两个中间表`laptop_student`和 `student_laptop`
![](/images/hibernate/manyToMany2.png)

使用了 mappedBy 后，则只需要维护一个中间表,代码如下

```java
@Getter
@Setter
@Accessors
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long rollno;

    private String name;

    private int marks;

    @ManyToMany(mappedBy = "student")
    private List<Laptop> laptop = new ArrayList<>();
}

@Getter
@Setter
@Accessors
@Entity
public class Laptop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lid;

    private String lname;

    @ManyToMany
    private List<Student> student = new ArrayList<>();
}

```

![](/images/hibernate/manyToMany.png)

## fetchType

FetchType.LAZY 和 FetchType.EAGER 有什么区别 ？

有时候，你有两个实体，并且他们之间有关联。比如，你有一个实体 名称叫 大学，还有另外一个实体叫 学生。

他们之间的关系如下：

一个大学可能有很多个学生。但是一个学生只能属于一个大学

![](/images/hibernate/fetchType.png)

```java
public class University {
   private String id;
   private String name;
   private String address;
   private List<Student> students;

   // setters and getters
}
```

现在，当你从数据库中加载一个大学，JPA 加载了它的 id, name, address。但是对于 student 字段怎么加载 你有两种选择

1. 和其他字段一起加载 FetchType.EAGER
2. 按需加载，当调用 university's getStudents() 方法的时候加载 FetchType.Lazy
