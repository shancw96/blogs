---
title: 「three」顶点，几何体结构
categories: [前端图形化]
tags: [ThreeJS]
toc: true
Date:2020/10/6
---

几何体(Geometry)是由顶点构成，不同的渲染材质（material），展现的图形也不一样。渲染材质有 点（point），线(line)，面(mesh)。Geometry + material = 可视化图形

# BufferGeometry

## 通过 BufferGeometry API 操作顶点

> 通过 ThreeJs 提供的 BufferGeometry 和 BufferAttribute 两个 API 可以自定义几何体

### BufferGeometry 和 SphereGeometry等 的区别在那

BufferGeometry 是最基础的 API， SphereGeometry 基于 BufferGeometry 封装了圆形操作，BoxGeometry 基于 BufferGeometry 封装了立方体操作，总而言之
**BufferGeometry 是 Three 图形生成的核心，而其余的 Geometry 是在其基础上的二次封装**，类似于 人 - 中国人，非洲人的区别

### BufferAttribute

Threejs 提供的接口 `BufferAttribute`**目的是为了创建各种各样顶点数据**，比如顶点**颜色数据，顶点位置**数据，然后作为几何体 BufferGeometry 的顶点位置坐标属性 `BufferGeometry.attributes.position`、顶点颜色属性 `BufferGeometry.attributes.color` 的值。

顶点 API 使用总结

```js
// 访问几何体顶点位置数据
BufferGeometry.attributes.position;
// 访问几何体顶点颜色数据
BufferGeometry.attributes.color;
// 访问几何体顶点法向量数据
BufferGeometry.attributes.normal;
```

### 使用顶点索引复用 创建网格模型

绘制一个矩形网格模型,至少需要两个三角形拼接而成，两个三角形，每个三角形有三个顶点，也就是说需要定义 6 个顶点位置数据，其中两个顶点是完全重合的。也就是只需要定义 4 个有效值，剩下两个可以通过顶点数组的索引获得

#### 不使用顶点复用

```js
var geometry = new THREE.BufferGeometry(); //声明一个空几何体对象
//类型数组创建顶点位置position数据
var vertices = new Float32Array([
  0, 0, 0, //顶点1坐标
  80, 0, 0, //顶点2坐标
  80, 80, 0, //顶点3坐标

  0, 0, 0, //顶点4坐标   和顶点1位置相同
  80, 80, 0, //顶点5坐标  和顶点3位置相同
  0, 80, 0, //顶点6坐标
]);
// 创建属性缓冲区对象
var attribue = new THREE.BufferAttribute(vertices, 3); //3个为一组
// 设置几何体attributes属性的位置position属性
geometry.attributes.position = attribue
var normals = new Float32Array([
  0, 0, 1, //顶点1法向量
  0, 0, 1, //顶点2法向量
  0, 0, 1, //顶点3法向量

  0, 0, 1, //顶点4法向量
  0, 0, 1, //顶点5法向量
  0, 0, 1, //顶点6法向量
]);
// 设置几何体attributes属性的位置normal属性
geometry.attributes.normal = new THREE.BufferAttribute(normals, 3); //3个为一组,表示一个顶点的xyz坐标
```

#### 使用顶点复用

只定义有效顶点

```js
var geometry = new THREE.BufferGeometry(); //声明一个空几何体对象
//类型数组创建顶点位置position数据
var vertices = new Float32Array([
  0, 0, 0, //顶点1坐标
  80, 0, 0, //顶点2坐标
  80, 80, 0, //顶点3坐标
  0, 80, 0, //顶点4坐标
]);
// 创建属性缓冲区对象
var attribue = new THREE.BufferAttribute(vertices, 3); //3个为一组
// 设置几何体attributes属性的位置position属性
geometry.attributes.position = attribue
var normals = new Float32Array([
  0, 0, 1, //顶点1法向量
  0, 0, 1, //顶点2法向量
  0, 0, 1, //顶点3法向量
  0, 0, 1, //顶点4法向量
]);
// 设置几何体attributes属性的位置normal属性
geometry.attributes.normal = new THREE.BufferAttribute(normals, 3); //3个为一组,表示一个顶点的xyz坐标
```

通过索引复用

```js
// Uint16Array类型数组创建顶点索引数据
var indexes = new Uint16Array([
  // 0对应第1个顶点位置数据、第1个顶点法向量数据
  // 1对应第2个顶点位置数据、第2个顶点法向量数据
  // 索引值3个为一组，表示一个三角形的3个顶点
  0, 1, 2,
  0, 2, 3,
])
// 索引数据赋值给几何体的index属性
geometry.index = new THREE.BufferAttribute(indexes, 1); //1个为一组
```

# Geometry

## 通过 Geometry API 操作顶点

> 几何体`Geometry`和缓冲类型几何体`BufferGeometry`表达的含义相同，只是对象的结构不同，Threejs渲染的时候会先把`Geometry`转化为`BufferGeometry`再解析几何体顶点数据进行渲染。

### [Vector3](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/math/Vector3)定义顶点位置坐标数据

```js
var geometry = new THREE.Geometry(); //声明一个几何体对象Geometry
var p1 = new THREE.Vector3(50, 0, 0); //顶点1坐标
var p2 = new THREE.Vector3(0, 70, 0); //顶点2坐标
var p3 = new THREE.Vector3(80, 70, 0); //顶点3坐标
//顶点坐标添加到geometry对象
geometry.vertices.push(p1, p2, p3);
```

### [Color](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/math/Color)定义顶点颜色数据

> 通过threejs顶点颜色对象`Color`可以定义几何体顶点颜色数据，然后顶点颜色数据构成的数组作为几何体`Geometry`顶点颜色属性`geometry.colors`的值。

```js
// Color对象表示顶点颜色数据
var color1 = new THREE.Color(0x00ff00); //顶点1颜色——绿色
var color2 = new THREE.Color(0xff0000); //顶点2颜色——红色
var color3 = new THREE.Color(0x0000ff); //顶点3颜色——蓝色
//顶点颜色数据添加到geometry对象
geometry.colors.push(color1, color2, color3);
```

### 材质属性`.vertexColors`

注意使用顶点颜色数据定义模型颜色的时候，要把材质的属性`vertexColors`设置为`THREE.VertexColors`,这样顶点的颜色数据才能取代材质颜色属性`.color`起作用。

```js
//材质对象
var material = new THREE.MeshLambertMaterial({
  // color: 0xffff00,
  vertexColors: THREE.VertexColors, //以顶点颜色为准
  side: THREE.DoubleSide, //两面可见
});
```



## Face3 API 定义Geometry三角面

下面代码自定义了一个由两个三角形构成的几何体，两个三角形有两个顶点坐标位置是重合的。

```js
var geometry = new THREE.Geometry(); //声明一个几何体对象Geometry

var p1 = new THREE.Vector3(0, 0, 0); //顶点1坐标
var p2 = new THREE.Vector3(0, 100, 0); //顶点2坐标
var p3 = new THREE.Vector3(50, 0, 0); //顶点3坐标
var p4 = new THREE.Vector3(0, 0, 100); //顶点4坐标
//顶点坐标添加到geometry对象
geometry.vertices.push(p1, p2, p3,p4);

// Face3构造函数创建一个三角面
var face1 = new THREE.Face3(0, 1, 2);
//三角面每个顶点的法向量
var n1 = new THREE.Vector3(0, 0, -1); //三角面Face1顶点1的法向量
var n2 = new THREE.Vector3(0, 0, -1); //三角面2Face2顶点2的法向量
var n3 = new THREE.Vector3(0, 0, -1); //三角面3Face3顶点3的法向量
// 设置三角面Face3三个顶点的法向量
face1.vertexNormals.push(n1,n2,n3);

// 三角面2
var face2 = new THREE.Face3(0, 2, 3);
// 设置三角面法向量
face2.normal=new THREE.Vector3(0, -1, 0);

//三角面face1、face2添加到几何体中
geometry.faces.push(face1,face2);
```

### 设置四个顶点

两个三角形有6个顶点，但是两个顶点位置重合的，可以设置4个顶点即可。

```js
var p1 = new THREE.Vector3(0, 0, 0); //顶点1坐标
var p2 = new THREE.Vector3(0, 100, 0); //顶点2坐标
var p3 = new THREE.Vector3(50, 0, 0); //顶点3坐标
var p4 = new THREE.Vector3(0, 0, 100); //顶点4坐标
//顶点坐标添加到geometry对象
geometry.vertices.push(p1, p2, p3,p4);
```

### [Face3 API](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/core/Face3)通过顶点索引构建三角形

```js
// Face3构造函数创建一个三角面
var face1 = new THREE.Face3(0, 1, 2);
// 三角面2
var face2 = new THREE.Face3(0, 2, 3);
```

## 几何体的缩放，旋转，平移

```js
var geometry = new THREE.BoxGeometry(100, 100, 100); //创建一个立方体几何对象Geometry
// 几何体xyz三个方向都放大2倍
geometry.scale(2, 2, 2);
// 几何体沿着x轴平移50
geometry.translate(50, 0, 0);
// 几何体绕着x轴旋转45度
geometry.rotateX(Math.PI / 4);
// 居中：偏移的几何体居中
geometry.center();
console.log(geometry.vertices);
```

