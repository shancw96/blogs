---
title: HTML-CSS 查漏补缺
categories: [html-css]
tags: []
toc: true
date: 2020/12/22
---

## display:none visibility:hidden 区别

场景：业务需求封装一个可控制显示/隐藏的 tooltip，因为需要频繁的切换显示隐藏，因此需要考虑不同的隐藏方法之前有什么性能区别

### display: none;

株连九族，子孙后代全部消失。连块安葬的地方都没有（不留空间）。因为影响比较大，导致民间哗然（渲染 + 回流）

### visibility: hidden;

株连九族，但是子孙可以通过一定手段逃脱死亡。有安葬的地方（占据空间）。民间反响较小(无渲染与回流)

因此在项目中使用 visibility: hidden 作为控制 tooltip 显示的方法
