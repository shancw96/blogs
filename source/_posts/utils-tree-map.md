---
title: 树结构特定key 映射
categories: [前端]
tags: [implement]
toc: true
date: 2021/12/17
---

```ts
const treeDataMock = [
  {
    title: "parent 0",
    key: "0-0",
    children: [
      { title: "leaf 0-0", key: "0-0-0", isLeaf: true },
      { title: "leaf 0-1", key: "0-0-1", isLeaf: true },
    ],
  },
  {
    title: "parent 1",
    key: "0-1",
    children: [
      { title: "leaf 1-0", key: "0-1-0", isLeaf: true },
      { title: "leaf 1-1", key: "0-1-1", isLeaf: true },
    ],
  },
];

type TreeNodeProps = {
  title: string;
  key: string;
  children: any;
  [key: string]: any;
};
// 替换 原有树结构的key 和 value 为特定 key value
const treeDataMapping = (
  originDef: TreeNodeProps,
  mappedDef: TreeNodeProps,
  treeData: TreeNodeProps[]
) => {
  const {
    title: originTitle,
    key: originKey,
    children: originChildren,
  } = originDef;
  const {
    title: mappedTitle,
    key: mappedKey,
    children: mappedChildren,
  } = mappedDef;
  return treeData?.map(mapCore);

  function mapCore(item: TreeNodeProps) {
    const newNode = {
      [mappedTitle]: item[originTitle],
      [mappedKey]: item[originKey],
    };
    return item?.[originChildren] instanceof Array
      ? {
          ...newNode,
          [mappedChildren]: item[originChildren].map(mapCore),
        }
      : { ...newNode, [mappedChildren]: [] };
  }
};

console.log(
  treeDataMapping(
    { title: "title", key: "key", children: "children" },
    { title: "areaName", key: "id", children: "children" },
    treeDataMock
  )
);
```
