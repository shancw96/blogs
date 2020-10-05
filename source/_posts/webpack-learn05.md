---
title: webpack - 文件---指纹，压缩
categories: [webpack]
tags: []
toc: true
date: 2020/10/5
---

## 文件指纹

- Hash: 和整个项目的构建有关，只要项目文件有修改，整个项目构建的 hash 值就会更改
- ChunkHash: 和 webpack 打包的 chunk 有关，不同的 entry 会生成不同 chunk
- ContentHash：根据文件内容来定义 hash，内容不变，则 contenthash 不变

### js 指纹设置

```js
module.exports = {
  entry: {
    app: "./src/app.js",
    search: "./src/search.js",
  },
  output: {
    // chunkhash:8 表示开启并使用生成的hash的前8位，hash一共32位
    filename: "[name]_[chunkhash:8]",
    path: __dirname + "/dist",
  },
};
```

### css 指纹设置

css 文件指纹需要先把 css 代码生成独立的文件，然后在对其设置 hash。

需要用到的包：

- MiniCssExtractPlugin: 把 css 代码生成独立的文件

**注意**
css 指纹设置 和 style-loader 冲突，不能同时使用。原因：style-loader 是将转换后的 css 直接插入 header。而 css 指纹则需要生成独立的文件

### webpack.config.js

```js
const path = require("path");
module.exports = {
  entry: "entry.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist"),
  },
  modules: {
    rules: [
      {
        test: /\.css$/,
        // use: ["style-loader", "css-loader", "less-loader"],
        use: [MiniCssExtractPlugin.loader, "style-loader", "css-loader"],
      },
      // less 解析
      {
        test: /\.css$/,
        // use: ["style-loader", "css-loader", "less-loader"],
        use: [MiniCssExtractPlugin.loader, "style-loader", "css-loader"],
      },
      // sass 解析
      {
        test: /\.scss$/,
        // use: ["style-loader", "css-loader", "sass-loader"],
        use: [MiniCssExtractPlugin.loader, "style-loader", "css-loader"],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: `[name][contenthash:8].css`,
    }),
  ],
};
```

### 字体，图片文件指纹

```js
module.exports = {
  entry: "entry.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist"),
  },
  modules: {
    rules: [
      // url-loader： 大于10240的图片不做base64 转换，此时和file-loader base64转换
      {
        test: /\.(png|jpg|gif|jpeg)/,
        use: [
          {
            loader: "file-loader",
            options: {
              name: "[name]_[hash:8].[ext]",
            },
          },
        ],
      },
      // file-loader：处理字体文件
      {
        test: /\.(woff|woff2|eot|ttf)/,
        use: [
          {
            loader: "file-loader",
            options: {
              name: "[name]_[hash:8].[ext]",
            },
          },
        ],
      },
    ],
  },
};
```
