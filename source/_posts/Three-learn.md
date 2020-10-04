---
title: 「three」几何体展示，两大类相机
categories: [前端图形化]
tags: [ThreeJS]
toc: true
date:
---

## 内容概览

- 两个辅助类：
  - 鼠标操作 orbitControl
  - 三维坐标系 AxisHelper

* 几何体展示
  - 基础几何体
  - 材质介绍
* 两大类 camera 介绍
  - 正交相机
  - 透视相机

## 鼠标操作三维场景

为了使用鼠标操作三维场景，可以借助 three.js 众多控件之一 OrbitControls.js
导入方式（npm 安装 threejs）：`import OrbitControl from 'three/examples/jsm/controls/OrbitControls'`

支持的场景操作

- 缩放：滚动—鼠标中键
- 旋转：拖动—鼠标左键
- 平移：拖动—鼠标右键

监听方式：

1. 使用 orbitControl 提供的事件监听器：

```js
function render() {
  renderer.render(scene, camera); //执行渲染操作
}
render();
var controls = new THREE.OrbitControls(camera, renderer.domElement); //创建控件对象
controls.addEventListener("change", render); //监听鼠标、键盘事件
```

2. 使用 requestAnimationFrame
   为了方便调试预览 threejs 提供了一个辅助三维坐标系 AxisHelper，可以直接调用 THREE.AxisHelper 创建一个三维坐标系，然后通过.add()方法插入到场景中即可。

```js
function render() {
  renderer.render(scene, camera); //执行渲染操作
  // mesh.rotateY(0.01);//每次绕y轴旋转0.01弧度
  requestAnimationFrame(render); //请求再次执行渲染函数render
}
render();
var controls = new THREE.OrbitControls(camera); //创建控件对象
```

## 辅助三维坐标系 AxisHelper

```js
// 辅助坐标系  参数250表示坐标系大小，可以根据场景大小去设置
var axisHelper = new THREE.AxisHelper(250);
scene.add(axisHelper);
```

## 基础几何体

```js
//长方体 参数：长，宽，高
var geometry = new THREE.BoxGeometry(100, 100, 100);
// 球体 参数：半径60  经纬度细分数40,40
var geometry = new THREE.SphereGeometry(60, 40, 40);
// 圆柱  参数：圆柱面顶部、底部直径50,50   高度100  圆周分段数
var geometry = new THREE.CylinderGeometry(50, 50, 100, 25);
// 正八面体
var geometry = new THREE.OctahedronGeometry(50);
// 正十二面体
var geometry = new THREE.DodecahedronGeometry(50);
// 正二十面体
var geometry = new THREE.IcosahedronGeometry(50);
```

## 几何体材质

### 材质常见属性

| 材质属性                                  | 简介                                         |
| ----------------------------------------- | -------------------------------------------- |
| color                                     | 材质颜色，比如蓝色 0x0000ff                  |
| wireframe 将几何图形渲染为线框。 默认值为 | false                                        |
| opacity                                   | 透明度设置，0 表示完全透明，1 表示完全不透明 |
| transparent                               | 是否开启透明，默认 false                     |

### 局部高亮（高光）

处在光照条件下的物体表面会发生光的反射现象，不同的表面粗糙度不同，宏观上来看对光的综合反射效果，可以使用**两个反射模型**来概括，**一个是漫反射，一个是镜面反射**
对于 three.js 而言漫反射、镜面反射分别对应两个构造函数 `MeshLambertMaterial() MeshPhongMaterial()`,

```js
var sphereMaterial = new THREE.MeshPhongMaterial({
  color: 0x0000ff,
  specular: 0x4488ee,
  shininess: 12,
}); //材质对象
```

### 材质类型

| 材质类型             | 功能                                                              |
| -------------------- | ----------------------------------------------------------------- |
| MeshBasicMaterial    | 基础网格材质，不受光照影响的材质                                  |
| MeshLambertMaterial  | Lambert 网格材质，与光照有反应，漫反射                            |
| MeshPhongMaterial    | 高光 Phong 材质,与光照有反应                                      |
| MeshStandardMaterial | PBR 物理材质，相比较高光 Phong 材质可以更好的模拟金属、玻璃等效果 |

## 相机

初学者对这两种相机对象建立一个基本的印象即可，知道什么样的场景要选择哪种相机, 如果不想深入学习，只要会参考案例代码或查阅 Threejs 文档修改相机相关参数即可
正交相机

### 正交相机与投影相机的简单解释

对于**正投影**而言，一条直线**放置的角度**不同，投影在投影面上面的长短不同；对于**透视投影**而言，投影的结果除了与几何体的**角度**有关，还和**距离**相关
<img src="camera-diff.png" alt="正交与透射区别"/>

### 正交投影

<img src="orthoCamera.png" alt="正交相机" />

```js
// 构造函数格式
OrthographicCamera(left, right, top, bottom, near, far);
/**
 * 正投影相机设置
 */
var width = window.innerWidth; //窗口宽度
var height = window.innerHeight; //窗口高度
var k = width / height; //窗口宽高比
var s = 150; //三维场景显示范围控制系数，系数越大，显示的范围越大
//创建相机对象
var camera = new THREE.OrthographicCamera(-s * k, s * k, s, -s, 1, 1000);
camera.position.set(200, 300, 200); //设置相机位置
camera.lookAt(scene.position); //设置相机方向(指向的场景对象)
```

注意：
**左右边界的距离与上下边界的距离比值**与画布的**渲染窗口的宽高比例**要**一致**，否则三维模型的显示效果会被单方向不等比例拉伸

### 透视投影

| 参数   | 含义                                                                                                                                  | 默认值                               |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| fov    | fov 表示视场，所谓视场就是能够看到的角度范围，人的眼睛大约能够看到 180 度的视场，视角大小设置要根据具体应用，一般游戏会设置 60~90 度  | 45                                   |
| aspect | aspect 表示渲染窗口的长宽比，如果一个网页上只有一个全屏的 canvas 画布且画布上只有一个窗口，那么 aspect 的值就是网页窗口客户区的宽高比 | window.innerWidth/window.innerHeight |
| near   | near 属性表示的是从距离相机多远的位置开始渲染，一般情况会设置一个很小的值。                                                           | 0.1                                  |
| far    | far 属性表示的是距离相机多远的位置截止渲染，如果设置的值偏小小，会有部分场景看不到                                                    | 1000                                 |

<img src="perspectiveCamera.png" alt="透视相机" />

透视相机的 lookat， position 解释

- .lookAt()方法用来指定相机拍摄对象的坐标位置
  <img src="camerLookAt.png" alt="相机属性设置" />

#### 相机位置放置

如果是观察一个产品外观效果，相机就位于几何体的外面，如果是室内漫游预览，就把相机放在房间三维模型的内部。
