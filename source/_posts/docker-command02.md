---
title: docker学习 - 命令02 运行一个webApp
categories: [工程化]
tags: [Docker]
toc: true
date: 2020/9/19
---

## example- webApp

### 启动一个随机端口的 webApp

```bash
docker run --name static-site -e AUTHOR="Your Name" -d -P dockersamples/static-site
```

- -d will create a container with the process detached from our terminal
- -P will publish all the exposed container ports to random ports on the Docker host
- -e is how you pass environment variables to the container
- --name allows you to specify a container name

* AUTHOR is the environment variable name and Your Name is the value that you can pass

### 启动一个指定端口的 app

docker run --name static-site -d -p 8888:80 dockersamples/static-site

8888:80 - 真实机器的端口 ：container 的端口

### 查看端口

docker port static-site
