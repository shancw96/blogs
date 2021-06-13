---
title: 算法-二分搜索
categories: [算法]
tags: [binarySearch]
toc: true
date: 2021/6/14
---

> 参考：[labuladong：我作了首诗，保你闭着眼睛也能写对二分查找](https://mp.weixin.qq.com/s?__biz=MzAxODQxMDM0Mw==&mid=2247485044&idx=1&sn=e6b95782141c17abe206bfe2323a4226&chksm=9bd7f87caca0716aa5add0ddddce0bfe06f1f878aafb35113644ebf0cf0bfe51659da1c1b733&scene=21#wechat_redirect)

通用模版

```js
function right_bound(nums, target) {

  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = parseInt(left + (right - left) / 2);

    if (nums[mid] === target) {
      ...
    } else if (target < nums[mid]) {
      right = ...;
    } else if (target > nums[mid]) {
      left = ...;
    }
  }
  return ...;
}
```

<!-- more -->

# 寻找一个数

```js
function searchTarget(nums, target) {
  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = parseInt(left + (right - left) / 2);

    if (nums[mid] === target) return mid;
    else if (target < nums[mid]) {
      right = target - 1;
    } else if (target > nums[mid]) {
      left = target + 1;
    }
  }
  return null;
}
```

# 边界判断

当出现[1,2,2,2,2,2]这种情况时候，如果需要返回最左侧，或者最右侧的 2 的时候，上面的算法是无法实现的，需要进行如下修改。

## 左边界

下面代码的核心内容为

```js
if (nums[mid] === target) {
  right = mid - 1;
}
```

```js
function left_bound(nums, target) {
  // 边界情况判断
  if (nums[0] > target || nums[nums.length - 1] < target) return -1;

  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = parseInt(left + (right - left) / 2);

    if (nums[mid] === target) {
      right = mid - 1;
    } else if (target < nums[mid]) {
      right = mid - 1;
    } else if (target > nums[mid]) {
      left = mid + 1;
    }
  }
  return left;
}
```

## 右边界

下面代码的核心内容为

```js
if (nums[mid] === target) {
  left = mid + 1;
}
```

```js
function right_bound(nums, target) {
  // 边界情况判断
  if (nums[0] > target || nums[nums.length - 1] < target) return -1;

  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = parseInt(left + (right - left) / 2);

    if (nums[mid] === target) {
      left = mid + 1;
    } else if (target < nums[mid]) {
      right = mid - 1;
    } else if (target > nums[mid]) {
      left = mid + 1;
    }
  }
  return right;
}
```

# 边界情况如何去判断

想象极限情况 [2,2] -> [2] left，right 如何变化，比如左边界判断如下图：
![图1](/images/algorithm/binarySearch-left-bound.jpeg)
