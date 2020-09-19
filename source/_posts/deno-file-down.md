---
title: deno webserver download file
categories: [deno]
tags: []
toc: true
date: 2020/9/20
---

## 交互流程

1. 前端发送请求，并设置 response header 为 blob 类型
2. 后端查询 mongo， 获取文件 path, 读取文件（blob)
3. 前端 通过 file-saver 将文件下载到本地

### 前端发送 下载文件请求

请求信息如下

```ts
method: POST / GET; // get post 都可
responseType: "blob";

interface reqBody {
  fileId: string; // 用于文件查找
}
// axios 拦截例子
function fetchFile(id) {
  return request({
    url: `/file/download/${id}`,
    method: "POST",
    responseType: "blob",
  }); // blob
}
// request 为设置的全局拦截器

// XHR 拦截参考这篇文章
// https://shancw96.github.io/blogs/2020/09/08/utils-imgList2zip/
const getFile = (url) =>
  new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    // unique sign 解决 read from disk
    url = url + `?r=${Math.random()}`;
    xhr.open("GET", url, true);
    xhr.responseType = "blob";
    xhr.onload = () => (xhr.status === 200 ? resolve(xhr.response) : resolve());
    xhr.send();
  });
```

### 后端查询 mongo， 获取文件 path, 读取文件（blob)

mongo 相关操作基于[ denoDB ](https://eveningkid.github.io/denodb-docs/docs/guides/query-models)
后端框架为 [oak](https://github.com/oakserver/oak)

```ts
此处写作中间件格式;
router.get("/file/download", downloadMiddleware, downloadFile);

// downloadMiddleware.ts
import { join } from "https://deno.land/std/path/mod.ts";
import { FileModel } from "yourDir/db.ts";
const download = async (ctx: any, next: () => Promise<void>) => {
  // get id from ctx.request
  const { path } = await FileModel.find(id);
  // 当前oak[4.0.0] 路由如果存在Promise 会crash，所以不使用async/await
  // https://github.com/oakserver/oak/issues/148
  const file = Deno.openSync(join(Deno.cwd(), path), { read: true });
  ctx.tempFile = Deno.readAllSync(file); // 将读取到的blob 存在上下文的tempFile 字段下
  next();
};

// downloadFile.ts
const downloadFile = async (ctx: any) => {
  ctx.response.body = ctx.tempFile;
};
```

### 前端 通过 file-saver 将文件下载到本地

```jsx
import { saveAs } from "file-saver";
// axios 拦截例子
function fetchFile(id) {
  return request({
    url: `/file/download/${id}`,
    method: "POST",
    responseType: "blob",
  }); // blob
}
saveAs(await fetchFile("xxxx"), fileName);

...

<Button onClick={downloadFile}>download</Button>;
```
