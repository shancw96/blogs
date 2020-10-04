---
title: webpack - 安装 & entry, output, loaders, plugins,mode 简单接触
categories: [webpack]
tags: []
toc: true
date:
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

## 附录

### webpack bin 快捷文件

```js
#!/usr/bin/env node

// @ts-ignore
process.exitCode = 0;

/**
 * @param {string} command process to run
 * @param {string[]} args commandline arguments
 * @returns {Promise<void>} promise
 */
const runCommand = (command, args) => {
  const cp = require("child_process");
  return new Promise((resolve, reject) => {
    const executedCommand = cp.spawn(command, args, {
      stdio: "inherit",
      shell: true,
    });

    executedCommand.on("error", (error) => {
      reject(error);
    });

    executedCommand.on("exit", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject();
      }
    });
  });
};

/**
 * @param {string} packageName name of the package
 * @returns {boolean} is the package installed?
 */
const isInstalled = (packageName) => {
  try {
    require.resolve(packageName);

    return true;
  } catch (err) {
    return false;
  }
};

/**
 * @typedef {Object} CliOption
 * @property {string} name display name
 * @property {string} package npm package name
 * @property {string} binName name of the executable file
 * @property {string} alias shortcut for choice
 * @property {boolean} installed currently installed?
 * @property {boolean} recommended is recommended
 * @property {string} url homepage
 * @property {string} description description
 */

/** @type {CliOption[]} */
const CLIs = [
  {
    name: "webpack-cli",
    package: "webpack-cli",
    binName: "webpack-cli",
    alias: "cli",
    installed: isInstalled("webpack-cli"),
    recommended: true,
    url: "https://github.com/webpack/webpack-cli",
    description: "The original webpack full-featured CLI.",
  },
  {
    name: "webpack-command",
    package: "webpack-command",
    binName: "webpack-command",
    alias: "command",
    installed: isInstalled("webpack-command"),
    recommended: false,
    url: "https://github.com/webpack-contrib/webpack-command",
    description: "A lightweight, opinionated webpack CLI.",
  },
];

const installedClis = CLIs.filter((cli) => cli.installed);

if (installedClis.length === 0) {
  const path = require("path");
  const fs = require("fs");
  const readLine = require("readline");

  let notify =
    "One CLI for webpack must be installed. These are recommended choices, delivered as separate packages:";

  for (const item of CLIs) {
    if (item.recommended) {
      notify += `\n - ${item.name} (${item.url})\n   ${item.description}`;
    }
  }

  console.error(notify);

  const isYarn = fs.existsSync(path.resolve(process.cwd(), "yarn.lock"));

  const packageManager = isYarn ? "yarn" : "npm";
  const installOptions = [isYarn ? "add" : "install", "-D"];

  console.error(
    `We will use "${packageManager}" to install the CLI via "${packageManager} ${installOptions.join(
      " "
    )}".`
  );

  const question = `Do you want to install 'webpack-cli' (yes/no): `;

  const questionInterface = readLine.createInterface({
    input: process.stdin,
    output: process.stderr,
  });
  questionInterface.question(question, (answer) => {
    questionInterface.close();

    const normalizedAnswer = answer.toLowerCase().startsWith("y");

    if (!normalizedAnswer) {
      console.error(
        "You need to install 'webpack-cli' to use webpack via CLI.\n" +
          "You can also install the CLI manually."
      );
      process.exitCode = 1;

      return;
    }

    const packageName = "webpack-cli";

    console.log(
      `Installing '${packageName}' (running '${packageManager} ${installOptions.join(
        " "
      )} ${packageName}')...`
    );

    runCommand(packageManager, installOptions.concat(packageName))
      .then(() => {
        require(packageName); //eslint-disable-line
      })
      .catch((error) => {
        console.error(error);
        process.exitCode = 1;
      });
  });
} else if (installedClis.length === 1) {
  const path = require("path");
  const pkgPath = require.resolve(`${installedClis[0].package}/package.json`);
  // eslint-disable-next-line node/no-missing-require
  const pkg = require(pkgPath);
  // eslint-disable-next-line node/no-missing-require
  require(path.resolve(
    path.dirname(pkgPath),
    pkg.bin[installedClis[0].binName]
  ));
} else {
  console.warn(
    `You have installed ${installedClis
      .map((item) => item.name)
      .join(
        " and "
      )} together. To work with the "webpack" command you need only one CLI package, please remove one of them or use them directly via their binary.`
  );

  // @ts-ignore
  process.exitCode = 1;
}
```
