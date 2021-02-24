---
title: webpack - 安装 & entry, output, loaders, plugins,mode 简单接触
categories: [工程化]
tags: [webpack]
toc: true
date: 2020/10/4
---

## webpack 安装

`npm i webpack webpack-cli --save-dev`

## entry output

### code

```js
// webpack.config.js
const path = require('path')
module.exports= {
  mode: 'production',
  entry: './entry.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  }
}

// entry.js 目标文件
document.write('<h1>Hello World</h1>')

//index.html 显示的html
<html>
  <body>
    <script src="dist/bundle.js"></script>
  </body>
</html>
```

### 通过 npm script 执行 webpack 命令

npm 对应代码

```json
{
  ...
  scripts: {
    ...
    build: 'webpack'
  }
}
```

执行：

```bash
npm run build
```

原理：webpack 安装后，会在 node_modules/.bin 目录下创建对应的软链接，如安装 webpack 后， bin 目录下会出现 webpack 运行代码。详细见文章最后

### 知识点

#### entry

入口文件告诉 webpack，哪一个文件是构建依赖图的开始(通过入口文件构建成一颗依赖树)

##### entry 写法

**单入口: 字符串格式**

```js
const config = {
  entry: "./path/to/my/entry/file.js",
};
```

**多入口：多页应用**

```js
const config = {
  entry: {
    pageOne: "./src/pageOne/index.js",
    pageTwo: "./src/pageTwo/index.js",
    pageThree: "./src/pageThree/index.js",
  },
};
```

#### output

output 告诉 webpack 如何将编译后的文件输出到磁盘
**多个入口起点**
通过[name]占位符，来实现打包出来多个文件

```js
{
  entry: {
    app: './src/app.js',
    search: './src/search.js'
  },
  output: {
    filename: '[name].js',
    path: __dirname + '/dist'
  }
}

// dist
// app.js
// search.js
```

## loaders

> webpack 开箱即用只支持 js 和 json 两种文件类型的打包，通过 loader 打包其他类型的文件，并加入到对应的依赖图中
> 本身是一个函数，接收源文件作为参数，返回转换结果

### 常用的 loaders

| 名称          | 描述                      |
| ------------- | ------------------------- |
| babel-loader  | 转换 es6 es7 语法         |
| css-loader    | 支持 css 文件的加载和解析 |
| less-loader   | 将 less 文件转换为 css    |
| ts-loader     | 将 ts 转换成 js           |
| file-loader   | 图片，字体的打包          |
| raw-loader    | 将文件以字符串的形式导入  |
| thread-loader | 多进程打包 js 和 css      |

### loaders 的用法

```js
const path = require("path");
module.exports = {
  output: {
    filename: "bundle.js",
  },
  module: {
    rules: [
      {
        test: /\.txt$/,
        use: "raw-loader",
      },
    ],
  },
};
```

loaders 放在 module 下，通过 rules 数组进行匹配

- test 指定匹配规则
- use 指定使用的 loader 名称

## plugins

> 插件用于 bundle 文件的优化，资源管理和环境变量注入
> 作用于整个构建过程（可以在 webpack 构建的整个过程中调用 plugins）

### 常用的 plugins

| 名称                     | 描述                                           |
| ------------------------ | ---------------------------------------------- |
| commonsChunkPlugin       | 将 chunks 相同的模块代码提取成公共的 js        |
| cleanWebpackPlugin       | 清理构建目录                                   |
| extractTextWebpackPlugin | 将 css 从 bundle 文件中提取出成独立的 css 文件 |
| CopyWebpackPlugin        | 将文件或者文件夹拷贝构建的输出目录             |
| HtmlWebpackPlugin        | 创建 Html 文件去承载输出的 bundle              |
| UglifyjsWebpackPlugin    | 压缩 js                                        |
| ZipWebpackPlugin         | 将打包的资源生成一个 zip                       |

### plugins 用法

```js
const path = require("path");
module.export = {
  output: {
    filename: "bundle.js",
  },
  plugins: [new HtmlWebpackPlugin({ template: "./src/index.html" })],
};
```

## mode

> mode 用来指定当前的构建环境，类型有: production, development, none

设置 mode 可以使用 webpack 内置的函数，默认值为 production

| 选项        | 描述                                                                                                                                                                                                                      |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| development | 会将 process.env.NODE_ENV 的值设为 development。启用 NamedChunksPlugin 和 NamedModulesPlugin。                                                                                                                            |
| production  | 会将 process.env.NODE_ENV 的值设为 production。启用 FlagDependencyUsagePlugin, FlagIncludedChunksPlugin, ModuleConcatenationPlugin, NoEmitOnErrorsPlugin, OccurrenceOrderPlugin, SideEffectsFlagPlugin 和 UglifyJsPlugin. |
