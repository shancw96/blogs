---
title: 【长期更新】spring-data-jpa 使用
categories: [Java]
tags: [database]
toc: true
date: 2020/3/8
---

JPA 允许开发者直接和 java 对象交互，而不是通过 SQL 语句。

java 对象与 数据库表的相互映射 叫做 对象关系映射(ORM - object relational mapping)。JPA 是一种 ORM 的一种。通过 JPA，开发者能够从数据库数据映射，存储，更新，恢复数据。

JPA 是一种规范，它有几种实现方式。最受欢迎的是[Hibernate](https://hibernate.org/)，EclipseLink and Apache OpenJPA

> 译者注: EclipseLink and Apache OpenJPA 现在已经处于淘汰状态

<!-- more -->

## QUICK GUIDE

> [JavaPersistenceAPI link](https://www.vogella.com/tutorials/JavaPersistenceAPI/article.html#jpaintro)

### Entity 实体

一个应该被数据库保存的类，它必须通过 `javax.persistence.Entity`进行注解，一张表对应一个实体。

所有的实体类必须定义一个主键，并且有一个无参数的构造方法或者不是 final 修饰的类。

通过@GeneratedValue 能够在数据库中自动生成主键

默认情况下，类名对应表名，通过`@Table(name="NEWTABLENAME")`能够指定表名

### 字段持久性

Entity 实体的字段将会保存在数据库中，JPA 既可以使用你的实例变量也可以使用对应的 getters，setters 来访问字段。但是不能混合两种方式，如果要使用 setter 和 getter 方法，则 Java 类必须遵循 Java Bean 命名约定。JPA 默认会保留实体的所有字段，**如果想要某一个字段不被保存，那么需要通过`@Transient` 标记**

| annotation      | description                         |
| --------------- | ----------------------------------- |
| @Id             | 实体的唯一标识                      |
| @GeneratedValue | 与实体的 ID 一起使用，表示自动生成. |
| @Transient      | Field will not be saved in database |

### CrudRepository Interface

CrudRepository 接口为 entity class 提供了最基础的 CRUD 功能。

```java
public interface CrudRepository<T, ID> extends Repository<T, ID> {
    // 保存单个
    <S extends T> S save(S var1);
    // 保存多个
    <S extends T> Iterable<S> saveAll(Iterable<S> var1);
    // 根据Id 查找
    Optional<T> findById(ID var1);
    // 判断是否存在
    boolean existsById(ID var1);
    // 获取所有
    Iterable<T> findAll();
    // id List 查找
    Iterable<T> findAllById(Iterable<ID> var1);
    // 获取保存的数量
    long count();
    // 根据ID 删除
    void deleteById(ID var1);
    // 根据实体删除
    void delete(T var1);
    // 根据实体集合删除
    void deleteAll(Iterable<? extends T> var1);

    void deleteAll();
}

```

## 关系映射

JPA 可以定义类与类之间的映射，对应的 annotation 如下

- @OneToOne 一对一
- @OneToMany 一对多
- @ManyToOne 多对一
- @ManyToMany 多对多

### oneToMany

学生和笔记本的关系:

1. 一个学生可以有多个笔记本
2. 一个笔记本只能对应一个学生

```java
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

@Entity
public class Laptop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lid;

    private String lname;
}
```

生成的 ER 图如下，此时会产生一个中间表 student_laptop，用于关联。
![](/images/hibernate/oneToMany.png)

如果不想生成中间表，则可以使用 mappedBy 或者是 Join Column。

使用 mappedBy 将当前的 student 映射到每一台 laptop 上。

mappedBy 用于指定具有双向关系的两个实体中。哪个实体是被关联处理的。在这里，Laptop 被 student 关联处理

```java
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long rollno;

    private String name;

    private int marks;

    @OneToMany(mappedBy="student")
    private List<Laptop> laptop = new ArrayList<>();
}
@Entity
public class Laptop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lid;

    private String lname;
    @ManyToOne
    private Student student;
}
```

![](/images/hibernate/oneToMany-mappedBy.png)

使用 JoinColumn 将当前 Laptop 关联到 student

```java
@Entity
public class Laptop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lid;
    private String lname;

    @ManyToOne
    @JoinColumn(name="rollno")
    private Student student;
}
```

### ManyToMany

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
