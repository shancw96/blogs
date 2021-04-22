---
title: leetcode03-最长无重复子串-mid
categories: [算法]
tags: [algorithm, string]
toc: true
date: 2020/9/28
---

一般的解法都是基于暴力解法优化而来，先看一下暴力解法思路

## brutal force

n 长度的字符串，一共有 n \* n -1 中情况，两层 for 循环可以计算出所有有效子串的长度

- 时间复杂度 O（n^2）
- 空间复杂度 O（1）

## sliding window

上述的方法，最大的问题在于 对于 abcdeaeflj 字符串
遍历过程如下
a, ab, abc, abcd, abcde
b, bc, bcd, bcde, bcdea
...
当 a 遇到重复字符后，结束。
进入下一个子串的遍历，我们从 a 子串的遍历已经得知 abcd 是一个无重复子串，但是，由于算法局限性，b 子串又重复判断了 bcd 子串

**当子串越长，需要重复计算的子串也越长**
上述问题解决方法：保存上一次的子串计算结果，跳过重复计算的部分

对于**遇到重复字符**的子串，进行以下操作

1. 删除重复子串及其之前的字符，只保留剩余的字符串
2. 将重复的字符加入剩余的字符串

操作如下

```js
a b c d b e f
|-----|
*************
a b c d b e f
    |---|
```

上面的操作，由于像是一个左右滑动的容器， 被形象的称为**滑动窗口**

### 代码实现

```js
function lengthOfLongestSubstring(str) {
  // let startPointer = 0
  let endPointer = 0;
  let curSubStr = new Map();
  let maxSubLen = 0;
  while (endPointer !== str.length) {
    if (isSubStrHasChar(endPointer)) {
      // 比较当前滑动窗口的大小和之前的最大值
      maxSubLen = Math.max(maxSubLen, curSubStr.size);
      // 更新滑动窗口
      // curSubStr.set(getChar(endPointer), endPointer)
      // 1. 删除重复的字符之前的字符
      const repeatCharIndex = curSubStr.get(getChar(endPointer));
      removeCharFromMap(repeatCharIndex, curSubStr);
      // 2. 更新重复的字符的位置
      curSubStr.set(getChar(endPointer), endPointer);
    } else {
      curSubStr.set(getChar(endPointer), endPointer);
    }
    endPointer += 1;
  }
  // 当字符串不存在重复，那么此时遍历过的节点就是最长子节点
  return Math.max(curSubStr.size, maxSubLen);

  function isSubStrHasChar(endPointer) {
    return curSubStr.has(str[endPointer]);
  }

  function removeCharFromMap(maxIndex, targetMap) {
    targetMap.forEach((charIndex, key) =>
      charIndex <= maxIndex ? targetMap.delete(key) : ""
    );
  }
  function getChar(index) {
    return str[index];
  }
}
```
