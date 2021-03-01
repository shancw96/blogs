---
title: nginx 安装与简单使用
categories: [linux]
tags: []
toc: true
date: 2021/3/1
---

## 启动，停止，重载 配置文件

- stop -- 强制关闭
- quit -- 关闭服务（在当前存在的请求结束后）
- reload -- 重载配置文件
- reopen -- 重新打开 log 文件

命令：`nginx -s [signal]` 如 `nginx -s stop`强制停掉配置文件

## 可配置项目

### 托管静态资源(如 SPA) （Serving Static Content）

比如：将 image 和 HTML 两种类型的文件进行托管在 /data/www 和 /data/images

修改配置文件如下:

```bash
http {
  server {
  }
}
```

server_name 输入的 url 的 host，可以用判断执行哪个 server 代码块

```conf
http {
  server {
    listen 80;
    server_name www.example.com
    # ... other config A
  }
  server {
    listen 80;
    server_name example.com
    # ... other config B
  }
}
```

如上配置，如果输入 www.example.com 走的是 configA 。输入 example.com 走的是 configB
