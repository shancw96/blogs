---
title: webpack - PostCSS
categories: [工程化]
tags: [webpack]
toc: true
date: 2020/10/6
---

postcss-loader 它可以理解为一种插件系统。你可以在使用预处理器的情况下使用它，也可以在原生的 css 中使用它。它都是支持的，并且它具备着一个庞大的生态系统
**postcss-loader 执行顺序必须保证在 css-loader 之前**，建议还是放在 less 或者 sass 等预处理器之后更好。即 loader 顺序：
`less-loader` -> `postcss-loader` -> `css-loader` -> `style-loader` 或者 `MiniCssExtractPlugin.loader`

## autoprefixer 自动补齐 CSS3 前缀

与 sass less 预处理不同，autoprefixer 是后置处理，也就是在 css 生成后进行补全操作
需要的包

- postcss-loader
- autoprefixer

写法 1:内联

```js
module.exports = {
  ...,
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          'style-loader'
          'css-loader',
          {
            loader: 'postcss-loader',
            // postcss 参数传递方式
            options: {
              plugins: () => [
                {
                  require('autoprefixer')({
                    browsers: ['last 2 version', '>1%']
                  })
                }
              ]
            }
          },
          'sass-loader',
        ]
      }
    ]
  }
}
```

写法 2: postcss.config.js

```js
// webpack.config.js
module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader", "postcss-loader"],
      },
    ],
  },
};

// postcss.config.js
module.exports = {
  plugins: [
    require("autoprefixer")({
      browsers: ["last 2 version", ">1%"],
    }),
  ],
};
```

## postcss-px-to-viewport 移动端 px 转换 vw

[如何在 Vue 项目中使用 vw 实现移动端适配](https://www.w3cplus.com/mobile/vw-layout-in-vue.html?expire=1601989799&code=WgRuX7d8CLI&sign=44e763b8fbfe1d83d63a3e55293f4b6d#paywall)

- postcss-px-to-viewport

```js
// postcss.config.js
plugins: [
  require("postcss-px-to-viewport")({
    viewportWidth: 1920, // (Number) The width of the viewport.
    viewportHeight: 1080, // (Number) The height of the viewport.
    unitPrecision: 3, // (Number) The decimal numbers to allow the REM units to grow to.
    viewportUnit: "vw", // (String) Expected units.
    selectorBlackList: ["mint"], // 用于对第三方UI样式取消匹配 mint-xxx 不会被匹配 //see: http://www.wangjianfeng.net/article/27
  }),
];
```

## 更多 https://www.w3cplus.com/PostCSS/using-postcss-for-minification-and-optimization.html
