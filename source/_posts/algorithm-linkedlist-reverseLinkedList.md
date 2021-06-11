---
title: 算法 - 反转链表
categories: [算法]
tags: [linkedList]
toc: true
date: 2021/6/10
---

这篇文章包含，反转链表，反转前 N 个链表，反转指定 M-N 之间的链表 的递归解法。
这篇文章主要内容参考[labuladong: 递归反转链表：如何拆解复杂问题](https://mp.weixin.qq.com/s?__biz=MzAxODQxMDM0Mw==&mid=2247484467&idx=1&sn=beb3ae89993b812eeaa6bbdeda63c494&chksm=9bd7fa3baca0732dc3f9ae9202ecaf5c925b4048514eeca6ac81bc340930a82fc62bb67681fa&scene=21#wechat_redirect)，再次基础上加上了自己的理解

<!-- more -->

## 反转链表

[leetcode 206](https://leetcode.com/problems/reverse-linked-list/)

<span style="color: green">函数定义：输入一个节点 head，将「以 head 为起点」的链表反转，并返回反转之后的头结点。</span>

<span style="color: red"> 我们执行 reverse(head),将会执行如下递归操作 </span>

```js
reverse(head);
  --> const last = reverse(head.next);
```

![图1](/images/algorithm/reverse-linkedList-1.png)

按照上述<span style="color: green">函数定义：</span>，那么 reverse(head.next)的期望结果应该如下

![图2](/images/algorithm/reverse-linkedList-2.png)

### 如果确保 last 就是反转后的头节点？

- Base Case： `if(head.next == null) return head`，当 head 节点只有一个（递归得到的尾节点或者链表为单个节点情况），我们将其返回，得到链表的尾节点

- return: last, 返回 last，保证返回的值一直是链表的尾节点

```js
function reverse(head) {
  if (head.next == null) return head;
  const last = reverse(head.next);
  return last;
}
```

<span class="text-large">调整图 2 的链表节点指向</span>  
假设 head 为 1，那么 head.next 就指向 2, head.next.next 就是 2 的指针 next
head.next.next = head; 将 2 的指针指向 1

![图3](/images/algorithm/reverse-linkedList-3.png)

此时 1 还是指向 2，将其指向 null，完成反转

![图4](/images/algorithm/reverse-linkedList-4.png)

<span class="text-large">综上，最后的代码为</span>

```js
function reverse(head) {
  if (!head || head.next === null) return head;
  const last = reverse(head.next);
  head.next.next = head;
  head.next = null;
  return last;
}
```

> 增加 !head 是为了处理 head 不存在的极端 case

## 反转前 N 个链表

```java
// 将链表的前 n 个节点反转（n <= 链表长度）
ListNode reverseN(ListNode head, int n)
```

反转前 N 个链表，和反转整个链表，整体没有太大区别。区别在于，除了需要记录节点 N，还需要记录 N+1 节点，用于连接反转后的链表和未反转的链表

![图1](/images/algorithm/reverse-linkedListN-1.png)

```js
let sucessor = null;
function reverseN(head, n) {
  if (n === 1) {
    sucessor = head.next;
    return head;
  }
  const tail = reverse(head.next, n - 1);
  head.next.next = head;
  head.next = sucessor;
  return tail;
}
```

sucessor 节点作用

![图2](/images/algorithm/reverse-linkedListN-2.png)
反转前 N 个节点，除了记录 tail，还需要记录切分处的后继节点 sucessor，用于反转后的尾节点连接。
如图中， 节点 1，想要连接到节点 4，需要知道节点 4 在哪才行。

## 反转指定区间的链表

[leetcode 92](https://leetcode.com/problems/reverse-linked-list-ii/)

```java
ListNode reverseBetween(ListNode head, int m, int n)
```

如果 m == 1，就相当于反转前 N 个链表

```js
function reverseMN(head, m, n) {
  if (m === 1) {
    return reverseN(head, n);
  }
  head.next = reverse(head.next, m - 1, n - 1);
  return head;
}
```

![图1](/images/algorithm/reverse-linkedListMN.jpeg)

## 分组反转链表

<span class='text-large'> 反转指定节点间的链表 </span>

**reverse 迭代实现 左闭右开**

```java
/** 反转区间 [a, b) 的元素，注意是左闭右开 */
ListNode reverseIterator(ListNode a, ListNode b) {
    ListNode pre, cur, nxt;
    pre = null; cur = a; nxt = a;
    // while 终止的条件改一下就行了
    while (cur != b) {
        nxt = cur.next;
        cur.next = pre;
        pre = cur;
        cur = nxt;
    }
    // 返回反转后的头结点
    return pre;
}
```

实现

```js
function reverseKGroup(head, k) {
  const a = head;
  const b = head;
  for (let i = 0; i < k; i++) {
    // 不足 k 个，不需要反转，base case
    if (b == null) return head;
    b = b.next;
  }

  const newHead = reverseIterator(a, b); // 左闭右开, 破坏性反转

* a.next = reverseKGroup(b, k); //从断开的地方续接

  return newHead;
}
```

核心流程：

```js
const newHead = reverseIterator(a, b); // 左闭右开, 破坏性反转

a.next = reverseKGroup(b, k); //从断开的地方续接
```

![图3](/images/algorithm/reverse-linkedList-between-node3.png)

**补充：reverse 递归左开右闭, 不破坏原有的链表 实现**

```js
// 左开右闭
function reverse(prev, b) {
  const a = prev.next;
  const sucessor = b.next;
  reverseCore(a, b);
  return prev;

  function reverseCore(a, b) {
    if (a === b) return b;
    const newHead = reverseCore(a.next, b);
    a.next.next = a;
*   a.next = sucessor;
    prev.next = b;
    return newHead;
  }
}
```

图示：
![图2](/images/algorithm/reverse-linkedList-between-node2.jpeg)

<span class="text-red"> 坑：上面代码中，星号的那行，不能使用 a.next = b.next;因为 a.next.next = a; 更改了 b 的 next 指向 </span>
