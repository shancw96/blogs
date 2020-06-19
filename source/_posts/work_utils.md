---
title: konva To Image
categories: [konva, "开发"]
tags: [utils]
toc: true
date: 2020/6/19
---

# 需求：

将 svg 源文件 插入 konva 中，支持后续的，可操作，可导出功能

# 分析

因为需要插入 konva 而不是简单的插入 dom 元素下。因此单纯使用 innerHTML 不符合开发需求。
转而采用 svg 转 base64 的方式 内嵌 src 完成。
流程如下 svgString -> svgEl -> base64 -> image -> konva Image

# utils

## svgStr -> svgEl

```js
const svgEl = document.createElement("div");
svgEl.innerHTML = svgStr;
return svgContainer.firstElementChild;
```

## svgEl -> base64

```js
/**
 * @description svg 生成 base64
 * @param {Element} svgEl
 */
const svg2Base64 = (svgEl) => {
  const s = new XMLSerializer().serializeToString(svgEl);
  return `data:image/svg+xml;base64,${btoa(unescape(encodeURIComponent(s)))}`;
};
```

## base64 -> image

```js
```
