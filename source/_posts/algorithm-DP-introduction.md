---
title: 《算法》动态规划
categories: [算法]
tags: [algorithm, DP]
toc: true
date: 2021/3/3
---

动态规划：将复杂的问题划分成子问题并且保存这些子问题的值，以此来避免重复计算
如下两类问题推荐使用 DP 解决：

1. Overlapping Subproblems 重叠子问题
2. Optimal Substructure 最佳子结构

## 1. Overlapping Subproblems

DP 通过将计算的子问题的值存储在一个 table 中来避免重复计算，从而优化程序的计算时间。因此如果复杂的问题划分成的子问题没有重合的，那么 DP 并没有什么用，比如二叉搜索树。

子问题的值存储方式有两种：

1. Memoization (Top Down)
2. Tabulation (Bottom Up)

以 fib 为例：

```js
function fib(n) {
  return n <= 1 ? n : fib(n - 1) + fib(n - 2)
}

                         fib(5)
                     /             \
               fib(4)                fib(3)
             /      \                /     \
        *fib(3)     *fib(2)         fib(2)    fib(1)
        /     \        /    \       /    \
  *fib(2)  *fib(1) *fib(1) *fib(0) fib(1) fib(0)
  /    \
*fib(1) *fib(0)
```

### Memoization

初始化一个 table，当我们需要计算子问题的值的时候，先在 table 中查找是否存在

```js
function fib_memo(n) {
  let table = [0, 1];
  return fib_core(n);
  function fib_core(n) {
    if (table[n]) return table[n];
    table[n] = fib_core(n - 1) + fib_core(n - 2);
    return table[n]; // fib_core(n)不走 if(table[n]) 此处必须要有return
  }
}
```

### tabulation

```js
function fib_table(n) {
  const table = [0, 1];
  for (let i = 2; i <= n; i++) {
    table[i] = table[i - 1] + table[i - 2];
  }
  return table[n];
}
```

### 相同与不同

tabulated 和 memoized 都通过一个 table 去存储子问题的结果，但是方式有所不同。

memoized 版本，table 是按需填充。而在 tabulated 版本中，则是从第一个开始，所有的实例一个一个填充完。

比如，memoized 版本的 LCS(longest common subsequence)就不需要填充满整个 table

[文章推荐：memoization vs tabulation](https://programming.guide/dynamic-programming-vs-memoization-vs-tabulation.html)

## 2. Optimal Substructure 最佳子结构

如果可以通过使用子问题的最优解来获得给定问题的最优解，则给定问题具有最优子结构属性：

如果节点 x 位于从源节点 u 到目标节点 v 的最短路径中，则从 u 到 v 的最短路径是从 u 到 x 的最短路径和从 x 到 v 的最短路径的组合

最短路径问题有如下最佳子结构属性：

- [floyd-warshall](https://www.geeksforgeeks.org/floyd-warshall-algorithm-dp-16/)

- [Bellman–Ford](https://www.geeksforgeeks.org/dynamic-programming-set-23-bellman-ford-algorithm/)
