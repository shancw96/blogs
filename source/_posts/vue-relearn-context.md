---
title: Vue 渲染函数 & JSX
categories: [Vue]
tags: []
toc: true
date: 2020/10/15
---

props: An object of the provided props
children: An array of the VNode children
slots: A function returning a slots object
scopedSlots: (v2.6.0+) An object that exposes passed-in scoped slots. Also exposes normal slots as functions.
data: The entire data object, passed to the component as the 2nd argument of createElement
parent: A reference to the parent component
listeners: (v2.3.0+) An object containing parent-registered event listeners. This is an alias to data.on
injections: (v2.3.0+) if using the inject option, this will contain resolved injections.
