---
title: MySQL-handbook
categories: [数据库]
tags: [database, mysql]
toc: true
date: 2021/4/22
---

这篇文章覆盖了 mysql 的常用知识，比如常用的语句 Select,Where ，常用的操作符 IN,BETWEEN, AND...常用的连接如 Inner Join, Self Join, 等等等。。。

这篇文章是[YouTube: MySQL Tutorial for Beginner - Programming with Mosh](https://www.youtube.com/watch?v=7S_tz1z_5bA&list=WL&index=6&t=1881s&ab_channel=ProgrammingwithMosh)的笔记

<!-- more -->

# The SELECT Clause

## 筛选出特定的行

```sql
-- first_name, last_name 是表名对应的数据项,
select first_name, last_name
from customers
```

## 数学（加减乘除）计算 和 as 别名使用

```sql
select
  last_name,
  first_name,
  points,
  (points + 10) * 100 as 'discount factor'
from customers
```

## select 去重 - distinct

```sql
select state from customer;
-- VA VA CO FL TX
```

```sql
select distinct state from customer;
-- VA CO FL TX
```

## 练习：

返回数据库中所有的商品并标上打 9 折的价格

```sql
-- return all products
-- name
-- unit price
-- new price

select
  name,
  unit_price,
  unit_price * 1.1 as new_price
from product
```

# The WHERE Clause

mysql 的字符检索策略: utf8_general_ci 是不区分大小的,也就是说下面两个语法相同

```sql
select * from user where username = 'admin' and password = 'admin'
-- ==
select * from user where username = 'ADMIN' and password = 'Admin'
```

解决方法： https://blog.csdn.net/Veir_123/article/details/73730751

## 运算符

```sql
-- 大于/小于
-- > , >= , < <=,

-- 不等于
select * from Customer where state != 'va'
select * from Customer where state <> 'va'
-- !==, <>
```

## 多条件查询

## The AND, OR, and NOT Operators

and 并且： 找出出生年月在 1990/01/01 之后的并且 分数大于 1000

```sql
select * from customer
where birth_data > '1990-01-01' and points > 1000;
```

NOT 非 找出出生年月在 1990/01/01 之后, 分数不小于等于 1000 的人

```sql
select * from customer
where birth_data > '1990/01/01' not point <= 1000
```

我们可以使用 （）来提升优先级
注意：and 优先级是高于 OR 的，我们为了方便理解，增加了（）来主动提升优先级

```sql
select * from customer
where birth_data > '1990-01-01'
  OR (points > 1000 AND state = 'VA')

```

练习：

```sql
-- from the order_items table, get the order_items
-- for order #6
-- where the total price is greater than 30

select * from order_items
where order_id = 6 and unit_price * quantity > 30;
```

## The IN Operator

当多个 OR 语句来联合查询，我们可以使用 IN 来代替。
例子：找出在'VA'或者 'FL'或者 'GA'这三个州的顾客

OR

```sql
select *
from customer
where state = 'VA' OR state = 'FL' OR state = 'GA'
```

IN

```sql
select *
from customer
where state IN('VA', 'FL', 'GA')
```

例子：找出不在'VA'或者 'FL'或者 'GA'这三个州的顾客

```sql
select *
from customer
where state NOT IN('VA', 'FL', 'GA')
```

练习：

```sql
-- return product with
--  quantity in stock equal to 49, 38, 72

select *
from products
where quantity_in_stock in(49, 38, 72)
```

## The BETWEEN Operator

在什么之间

AND

```sql
select * from customer
where points >= 1000 AND points <= 3000
```

Between

```sql
select * from customer
where points between(1000, 3000)
```

## The LIKE Operator

模糊查询

- `%`符号代表 0 ～多个字符
  ```sql
  -- 找出所有last_name以admin开头的顾客
  SELECT * from customer where last_name like 'admin%'
  -- 找出所有last_name 包含了admin 的顾客
  SELECT * from customer where last_name like '%admin%'
  ```
- `_`表示 1 个字符
  ```sql
  -- 找出所有last_name 以y结尾，长度为5的 customer
  SELECT * from customer where last_name like '____y'
  ```

练习

```sql
-- get the customer whose
--  addresses contain TRAIL or AVENUE
--  phone numbers end with 9

select * from customer
where (address like '%TRAIL%' OR address like '%AVENUE%')
  and phone_number like '%9';
```

## The REGEXP Operator

正则表达式更加灵活，可以实现和 like 相同的效果

```sql
-- 找出所有last_name以admin开头的顾客
SELECT * from customer where last_name REGEXP '^admin'
-- 找出所有last_name 包含了admin 的顾客
SELECT * from customer where last_name REGEXP 'admin'
-- 找出所有last_name 以admin结尾 的顾客
SELECT * from customer where last_name REGEXP 'admin$'
```

```sql
-- get the customer whose
--  addresses contain TRAIL or AVENUE
select * from customer
where address REGEXP 'TRAIL|AVENUE'
```

## The IS NULL Operator

判断字段是否为 null

```sql
-- 找出手机号为空的用户
select * from customer where phone is null
-- 找出手机号不为空的用户
select * from customer where phone is not null
```

## The ORDER BY Operator

排序: 默认情况下以 id 排序，如果想要改变查询结果的排序规则，需要使用 order by 操作符号，如果想要倒序排，则需要额外加上 DESC

注意： order by 使用的字段是 select 设置的，支持使用 as 别名，进行动态计算，具体参考这块的练习

按照用户的出生日期倒序排列

```sql
select * from customer order by birth_date desc
```

如果用户出生日期相同按照，所在州进行再次排序

```sql
select * from customer
order by birth_data desc, state desc
```

练习： 按照订单 quantity 和 unit_price 构成的总价来排序订单

```sql
select *, quantity * unit_price as total_price
from order_items
where order_id =2
order by total_price desc
```

## The LIMIT Operator

限制数据库返回的 customer 个数

```sql
-- 限制返回的数量为3个

select * from customer limit 3
```

选择 6 条数据后的 3 条数据

```sql
select * from customer limit 6, 3 -- offset 6, pick 3
```

# Join

## Inner Joins

## Joining Across Databases

## Self Joins

## Joining Multiple Tables

## Compound Join Conditions

## Implicit Join Syntax

## Outer Joins

## Outer Join Between Multiple Tables

## Self Outer Joins

## The USING Clause

## Natural Joins

## Cross Joins

# Unions

# Column Attributes

# Inserting

## Inserting a Single Row

## Inserting Multiple Rows

## Inserting Hierarchical Rows

# Creating a Copy of a Table

# Updating

## Updating a Single Row

## Updating Multiple Rows

# Using Subqueries in Updates

# Deleting Rows

# Restoring Course Databases
