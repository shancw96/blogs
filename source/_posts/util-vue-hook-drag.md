---
title: vue自定义指令-拖拽
categories: [util]
tags: []
toc: true
date: 2020/1/15
---

## vue 自定义指令是什么？

实现和 v-if v-show 同样的效果，对对普通 DOM 元素进行底层操作。

## 拖拽指令实现

### 用到的 hook

bind: 初始化 mousedown mouseup mousemove 相关事件监听

unbind：解除对应事件监听

### 拖拽实现思路

鼠标左键按在指定位置，触发 mousedown 事件，**记录当前的位置信息**，当鼠标移动的时候，获取鼠标距离记录点的偏移量，并更新元素位置

### 使用

example1:  移动 v-move 所在的元素

```js
<template>
  <div v-move="{dragArea: 'header'}">
    <div class="header"></div>
    <div class="body"></div>
  </div>
</template>
```

example1:  移动 v-move 所在元素下指定元素 body

```js
<template>
  <div v-move="{dragArea: 'header', needMove: 'body'}">
    <div class="header"></div>
    <div class="body"></div>
  </div>
</template>
```

### 代码实现

```js
/**
 *
 * @description 获取el.style.cssText的transform 属性值
 * @param styleText style string
 * @returns {x: number, y: number}
 */
function getTransformStyle(styleText: string): { x: number; y: number } {
  const hasTranslate = (cssText: string) => /translate/.test(cssText);
  const extractTranslateObj = (cssText: string) => {
    const matched = cssText.match(/transform:\s*translate\((.+)px,\s*(.+)px\)/)
    if(!matched) return { x: 0, y: 0 };
    else return {x: Number(matched[1]), y: Number(matched[2])}
  };
  return hasTranslate(styleText)
    ? extractTranslateObj(styleText)
    : { x: 0, y: 0 };
}
/**
 * @description 元素拖拽指令 v-move={dragArea:"childClass"} || v-move={dragArea: "childClass", needMove: "childClass"}
 * @param {String} dragArea 拖拽交互区域的class，默认使用第一个匹配到的class。注意：此class必须为v-move放置的节点内部存在
 * @param {String} needMove 可选：可拖拽区域的class。如果不传，默认使用当前v-move放置的节点
 */
Vue.directive('move', {
  bind(el: HTMLElement, binding, vnode) {
    const dialogHeaderEl: HTMLElement =
      binding.value && binding.value.dragArea
        ? (el.querySelector(`.${binding.value.dragArea}`) as HTMLElement)
        : (el.firstChild as HTMLElement);
    const dragDom: HTMLElement =
      binding.value && binding.value.needMove
        ? (el.querySelector(`.${binding.value.needMove}`) as HTMLElement)
        : el;
    if (dialogHeaderEl && dragDom) {
      dialogHeaderEl.style.cursor = 'move';
      dialogHeaderEl.addEventListener('mousedown', handleMouseDown);
      document.removeEventListener('mouseup', handleMouseDown);
    }
    // 核心功能区
    // 思路：按下鼠标左键开始监听鼠标的移动，将鼠标的偏移量获取到，通过transform:translate(x, y) 的方式添加到拖拽元素上
    // 优化：使用rafThrottle 节流函数，同步帧，在操作无感知的情况下优化性能。
    function handleMouseDown(ev: any) {
      if (ev.button !== 0) return;
      ev.preventDefault();
      const existOffset = getTransformStyle(dragDom.style.cssText);
      const { x: initX, y: initY } = existOffset;
      const startX = ev.pageX;
      const startY = ev.pageY;
      const _dragHandler = rafThrottle((ev: any) => {
        existOffset.x = initX + ev.pageX - startX;
        existOffset.y = initY + ev.pageY - startY;
        updateElTransformStyle(dragDom, existOffset);
      });
      document.addEventListener('mousemove', _dragHandler);
      document.addEventListener('mouseup', () => {
        document.removeEventListener('mousemove', _dragHandler);
      });
      function updateElTransformStyle(
        dragDom: HTMLElement,
        offsetPos: { x: number; y: number }
      ) {
        dragDom.style.setProperty(
          'transform',
          `translate(${offsetPos.x}px, ${offsetPos.y}px)`
        );
      }
    }
  },
  unbind() {
    document.onmouseup = null;
  }
});
```

rafThrottle 可以看之前的文章，就是一个节流函数 [防抖 + 节流（requestAnimationFrame 方式）](https://juejin.cn/post/6916511470944124935)
