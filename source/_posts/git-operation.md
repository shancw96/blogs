---
title: git 操作
categories: [工程化]
tags: [git]
toc: true
date: 2020/7/3
---

## remote 分支操作

```bash
git remote rm [仓库名称] # 删除
git remote add [仓库名称] [地址] # 添加
git remote # 查看remote 仓库列表
git remote set-url [仓库名称] [url] # 更改仓库的地址
git push origin --delete feat-eslint-vue-enable # 删除远程分支
```

## bash + git branch 删除本地垃圾分支

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

### 命令解释

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

### 使用例子

删除所有包含 bugFix 关键字的分支

```bash
git branch | grep 'bugFix' | xargs git branch -d
```

## cheery-pick: 选择某一个 commit merge 到当前分支

1. `git log` 或 `sourcetree 工具`查看一下你想选择哪些 commits 进行合并 如 82ecb31
2. `git cherry-pick 82ecb31`

## reset 撤销提交的代码

```js
git reset --hard head^ 不保留代码，恢复成上一个 commit 版本代码
git reset --soft head^ 保留代码，恢复成上一个 commit
```

## 使用 amend + push -f 实现远程分支 commit 的追加[2021/2/24]

1. git commit --amend // 提交一次追加代码
2. git push origin [仓库名称] -f // -f 强制推送

## git rebase 与 git merge 区别 [2021/2/24]

**git rebase 作用**: 在多人开发的时候维护 git 树的干净整洁，方便回滚迭代
**git rebase 的原理**

- 首先，git 会把 feature1 分支里面的每个 commit 取消掉；
- 其次，把上面的操作临时保存成 patch 文件，存在 .git/rebase 目录下；
- 然后，把 feature1 分支更新到最新的 master 分支；
- 最后，把上面保存的 patch 文件应用到 feature1 分支上

**git rebase 缺陷**
git rebase 和 git merge 都能够实现合并代码的功能，但是 git rebase 不推荐在公共分支上进行操作，因为会出现不同开发人员之间的提交记录不一致的情况，如图
<img src="git-rebase.png" alt="git rebase 缺陷"/>
