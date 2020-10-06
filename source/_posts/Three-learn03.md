---
title: 「three」光源
categories: [前端图形化]
tags: [ThreeJS]
toc: true
Date: 2020/10/6
---

## 光照原理和常见光源类型

- 环境光 AmbientLight
- 平行光 DirectionalLight
- 点光源 PointLight
- 聚光灯光源 SpotLight
- 基类 Light
  - 颜色 color
  * 强度 intensity

<img src="kinds.png" alt="光源类型">

### 环境光[AmbientLight](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/lights/AmbientLight)

环境光是没有特定方向的光源，主要是**均匀整体改变**Threejs 物体表面的明暗效果, 不需要设置光源位置

```js
//环境光:环境光颜色RGB成分分别和物体材质颜色RGB成分分别相乘
var ambient = new THREE.AmbientLight(0x444444);
scene.add(ambient); //环境光对象添加到scene场景中
```

### 点光源[PointLight](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/lights/PointLight)

点光源就像生活中的**白炽灯**，光线沿着发光核心向外发散，同一平面的不同位置与点光源光线入射角是不同的，点光源照射下，**同一个平面不同区域是呈现出不同的明暗效果**。

**点光源需要设置位置属性`.position`，光源位置不同，物体表面被照亮的面不同，远近不同因为衰减明暗程度不同**

```js
//点光源
var point = new THREE.PointLight(0xffffff);
//设置点光源位置，改变光源的位置
point.position.set(400, 200, 300);
scene.add(point);
```

### 平行光[DirectionalLight](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/lights/DirectionalLight)

平行光顾名思义光线平行，对于一个平面而言，平面不同区域接收到平行光的入射角一样。

- **平行光你可以理解为太阳光，从无限远处照射过来**

- **平行光光源的位置属性`.position`,只是用来确定平行光的照射方向**

- 三维空间中为了确定一条直线的方向只需要确定直线上两个点的坐标即可，所以 Threejs 平行光提供了**位置`.position`和目标`.target`两个属性来一起确定平行光方向**。

```js
// 平行光
var directionalLight = new THREE.DirectionalLight(0xffffff, 1);
// 设置光源的方向：通过光源position属性和目标指向对象的position属性计算
directionalLight.position.set(80, 100, 50);
// 方向光指向对象网格模型mesh2，可以不设置，默认的位置是0,0,0
directionalLight.target = mesh2;
scene.add(directionalLight);
```

### 聚光源[SpotLight](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/lights/SpotLight)

聚光源可以认为是一个沿着特定方会逐渐发散的光源，照射范围在三维空间中构成一个圆锥体。通过属性`.angle`可以设置聚光源发散角度，聚光源照射方向设置和平行光光源一样是通过位置`.position`和目标`.target`两个属性来实现。

```js
// 聚光光源
var spotLight = new THREE.SpotLight(0xffffff);
// 设置聚光光源位置
spotLight.position.set(200, 200, 200);
// 聚光灯光源指向网格模型mesh2
spotLight.target = mesh2;
// 设置聚光光源发散角度
spotLight.angle = Math.PI / 6;
scene.add(spotLight); //光对象添加到scene场景中
```

### 光源辅助对象

Threejs 提供了一些光源辅助对象，就像`AxesHelper`可视化显示三维坐标轴一样显示光源对象,通过这些辅助对象可以方便调试代码，查看位置、方向

| 辅助对象           | 构造函数名                                                                                                             |
| :----------------- | :--------------------------------------------------------------------------------------------------------------------- |
| 聚光源辅助对象     | [SpotLightHelper](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/helpers/SpotLightHelper)               |
| 点光源辅助对象     | [PointLightHelper](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/helpers/PointLightHelper)             |
| 平行光光源辅助对象 | [DirectionalLightHelper](http://www.yanhuangxueyuan.com/threejs/docs/index.html#api/zh/helpers/DirectionalLightHelper) |

# 光照阴影

### 平行光投影计算代码

```js
var geometry = new THREE.BoxGeometry(40, 100, 40);
var material = new THREE.MeshLambertMaterial({
  color: 0x0000ff
});
var mesh = new THREE.Mesh(geometry, material);
// mesh.position.set(0,0,0)
scene.add(mesh);

// 设置产生投影的网格模型
mesh.castShadow = true;


//创建一个平面几何体作为投影面
var planeGeometry = new THREE.PlaneGeometry(300, 200);
var planeMaterial = new THREE.MeshLambertMaterial({
  color: 0x999999
});
// 平面网格模型作为投影面
var planeMesh = new THREE.Mesh(planeGeometry, planeMaterial);
scene.add(planeMesh); //网格模型添加到场景中
planeMesh.rotateX(-Math.PI / 2); //旋转网格模型
planeMesh.position.y = -50; //设置网格模型y坐标
// 设置接收阴影的投影面
planeMesh.receiveShadow = true;

// 方向光
var directionalLight = new THREE.DirectionalLight(0xffffff, 1);
// 设置光源位置
directionalLight.position.set(60, 100, 40);
scene.add(directionalLight);
// 设置用于计算阴影的光源对象
directionalLight.castShadow = true;
// 设置计算阴影的区域，最好刚好紧密包围在对象周围
// 计算阴影的区域过大：模糊  过小：看不到或显示不完整
directionalLight.shadow.camera.near = 0.5;
directionalLight.shadow.camera.far = 300;
directionalLight.shadow.camera.left = -50;
directionalLight.shadow.camera.right = 50;
directionalLight.shadow.camera.top = 200;
directionalLight.shadow.camera.bottom = -100;
// 设置mapSize属性可以使阴影更清晰，不那么模糊
// directionalLight.shadow.mapSize.set(1024,1024)
console.log(directionalLight.shadow.camera);
```

### 聚光光源投影计算代码

下面代码是聚光光源的设置，其它部分代码和平行光一样。

```js
// 聚光光源
var spotLight = new THREE.SpotLight(0xffffff);
// 设置聚光光源位置
spotLight.position.set(50, 90, 50);
// 设置聚光光源发散角度
spotLight.angle = Math.PI /6
scene.add(spotLight); //光对象添加到scene场景中
// 设置用于计算阴影的光源对象
spotLight.castShadow = true;
// 设置计算阴影的区域，注意包裹对象的周围
spotLight.shadow.camera.near = 1;
spotLight.shadow.camera.far = 300;
spotLight.shadow.camera.fov = 20;
```

### 模型`.castShadow`属性

`.castShadow`属性值是布尔值，默认false，用来设置一个模型对象是否在光照下**产生投影**效果

```js
// 设置产生投影的网格模型
mesh.castShadow = true;
```

### `.receiveShadow`属性

`.receiveShadow`属性值是布尔值，默认false，用来设置一个模型对象是否在光照下**接受其它模型的投影效果**。

```js
// 设置网格模型planeMesh接收其它模型的阴影(planeMesh作为投影面使用)
planeMesh.receiveShadow = true;
```

### 光源`.castShadow`属性

如果属性设置为 true， 光源将投射动态阴影

```js
// 设置用于计算阴影的光源对象
directionalLight.castShadow = true;
// spotLight.castShadow = true; 
```

