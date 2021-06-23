---
title: 算法-二叉树-刷题
categories: [算法]
tags: [二叉树]
toc: true
date: 2021/6/23
---

# 116

给定一个完美二叉树，其所有叶子节点都在同一层，每个父节点都有两个子节点。二叉树定义如下:

```js
function Node(val) {
  this.val = val;
  this.left = null;
  this.right = null;
  this.next = null;
}
```

题目链接：[116. Populating Next Right Pointers in Each Node](https://leetcode.com/problems/populating-next-right-pointers-in-each-node/)

题目的意思是，把二叉树的每一层节点都用 next 指针连接起来。

![](https://leetcode.com/problems/populating-next-right-pointers-in-each-node/)

# 114

这道题目需要深刻意识到后续遍历压栈的重要性
每次 flatten 都会保存当时的 root 变量 快照。
前一次 flatten 和 后一次 flatten 之间 通过 root.right 联系在一起。不需要通过 返回值来实现关联不同栈

```js
/**
 * Definition for a binary tree node.
 * function TreeNode(val, left, right) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.left = (left===undefined ? null : left)
 *     this.right = (right===undefined ? null : right)
 * }
 */
/**
 * @param {TreeNode} root
 * @return {void} Do not return anything, modify root in-place instead.
 */
var flatten = function (root) {
  if (!root) return null;

  flatten(root.left);
  flatten(root.right);

  const leftChild = root.left;
  const rightChild = root.right;

  root.right = leftChild;
  root.left = null;

  while (root.right) {
    root = root.right;
  }

  root.right = rightChild;
};
```
