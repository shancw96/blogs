---
title: docker 学习 - 命令01 运行一个container
categories: []
tags: []
toc: true
date:
---

**此处 image 使用 alpine linux**

## 从 docker hub 获取 image

1. docker pull [imageName] ： 拉取 image
2. docker images : 查看 images 列表

## 运行一个 docker

docker run [image] [command]

> docker run image，如果 image 在本地不存在，会自动执行 docker pull

```bash
docker run alpine ls -l
```

**此处的 ls -l 是对 container 执行的命令**如果写成 JS 的 Promise 格式如下

```js
(docker run alpine)
  .then(container => ls -l)
  .then(tag => tag has -it ? open tty : kill container)
```

执行上面程序的流程：image 创建一个 container，在它上面执行 command 命令，如果程序有`-it`，那么会打开一个可与 container 交互的 tty（控制台），否则直接退出

## 查看运行的 container

- docker ps 查看正在运行的 container
- docker ps -a 查看所有运行过的 container

## 操作后台运行 container： **-d**

- docker run -d [images] : The -d flag 启用 detached mode，后台运行
- docker ps 查看正在运行的 container
- docker rm [containerId] 删除正在运行 container

### 使用上面学到的命令运行 alpine shell

- docker pull alpine
- docker run alpine ls -a 查看 alpine 列表
- docker run -it alpine /bin/sh -开启可交互的 tty
