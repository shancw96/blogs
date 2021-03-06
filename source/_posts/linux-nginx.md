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

## [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

```bash
Syntax:	proxy_pass URL;
Default:	—
Context:	location, if in location, limit_except
```

### 请求 URI 的转发规则：

- 绝对路径：如果 proxy_pass 的 URL **指定了一个 URI**，此时这个 URI 会替换 请求(request)的 URI.
  例 1:

  ```conf
    location /name/ {
      proxy_pass http://127.0.0.1/remote/;
    }

    /name/shancw -> http://127.0.0.1/remote/shancw
  ```

  例 2:

  ```conf
  location /name/ {
    proxy_pass http://127.0.0.1/;
  }

  /name/test.html -> http://127.0.0.1/test.html
  ```

  例 3：

  ```conf
  location /name/ {
    proxy_pass http://127.0.0.1/extra;
  }

  /name/test.html -> http://127.0.0.1/extratest.html
  ```

* 相对路径： 如果 proxy_pass 的 URL **没有指定 URI**, 此时请求(request)的 URI 会被拼接到 proxy_pass 的 URL 上

  ```conf
  location /name/ {
    proxy_pass http://127.0.0.1;
  }

  /name/shancw -> http://127.0.0.1/name/shancw
  ```

应用：[nginx 根据不同 prefix 转接 请求, 实现一个服务器 + 域名托管多个应用服务](https://github.com/shancw96/tech-basis/tree/master/nginx)

### 关于nginx location 的更多使用

[一文弄懂Nginx的location匹配](https://segmentfault.com/a/1190000013267839)

## nginx 下 cache-control 配置

[相关配置介绍](https://www.cnblogs.com/sfnz/p/5383647.html)

使用例子：[blog 下配置指定路径的cache - 3. 2d live看板娘设置 -3.4优化](http://blog.limiaomiao.site/2021/03/14/next-usage/)
