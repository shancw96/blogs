---
title: git 批量删除本地分支
categories: [版本控制]
tags: [git]
toc: true
date: 2020/7/3
---

# 解决方案

## 删除分支命令

删除一条分支：

```bash
git branch -D branchName
```

删除当前分支外的所有分支：

```bash
git branch | xargs git branch -d
```

删除分支名包含指定字符的分支：

```bash
git branch | grep 'dev' | xargs git branch -d
# 该例将会删除分支名包含’dev’字符的分支
```

## 命令解释

`|`
管道命令，用于将一串命令串联起来。前面命令的输出可以作为后面命令的输入。

`git branch`
用于列出本地所有分支。

`grep`
搜索过滤命令。使用正则表达式搜索文本，并把匹配的行打印出来。

`xargs`
参数传递命令。用于将标准输入作为命令的参数传给下一个命令。

3. 管道命令与 xargs 命令的区别
   管道是实现’'将前面的标准输出作为后面的标准输入"

xargs 是实现“将标准输入作为命令的参数"

## 使用例子

删除所有包含 bugFix 关键字的分支

```bash
git branch | grep 'bugFix' | xargs git branch -d
```
