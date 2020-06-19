---
title: 回文链表
categories: [算法]
tags: [链表]
toc: true
---

# 请判断一个链表是否为回文链表,要求为**时间复杂度 O(n) 空间复杂度 O(1)**

[关联 leetcode234](https://leetcode-cn.com/problems/palindrome-linked-list/)
例子 1:

```js
输入：1->2
输出：false
```

例子 2:

```js
输入：1->2->2->1
输出：true
```

## 解决方法 1:半栈法

时间复杂度:O(n) 空间复杂度 O(n/2)

> 快慢指针遍历链表时间复杂度 O(n/2)，在此期间，使用栈保存慢指针的引用。遍历结束后，慢指针指向中间点
> 慢指针接着遍历剩余链表，并逐个将栈中保存的指针引用进行出栈与慢指针对应的值进行比较 时间复杂度 O(n/2) 空间复杂度 O(1)
> 时间复杂度：O(n) 空间复杂度 O(n/2)

```js
const isPalindrome = (head) => {
  // 快慢指针遍历链表
  let fast = head;
  let slow = head;
  let stack = [];
  while (fast && fast.next) {
    stack.push(slow);
    fast = fast.next.next;
    slow = slow.next;
  }
  // 栈弹出
  if (fast) slow = slow.next; //当fast存在的情况下，为奇数， slow 进入下半段。否则slow 已为下半段
  while (slow) {
    const last = stack.pop();
    if (slow.val !== last.val) return false;
    slow = slow.next;
  }
  return true;
};
```

## 解决方法 2: 原地修改法

时间复杂度:O(n) 空间复杂度 O(1)

```js
const isPalindrome = (head) => {
  let prev = null;
  let fast = head;
  let slow = head;
  while (fast && fast.next) {
    fast = fast.next.next;
    let next = slow.next;
    slow.next = prev;
    prev = slow;
    slow = next;
  }
  //如果是奇数个，则slow 手动进入下半段
  if (fast) {
    slow = slow.next;
  }
  // 比较前后两段
  while (slow) {
    if (slow.val !== prev.val) return false;
    slow = slow.next;
    prev = prev.next;
  }
  return true;
};
```
