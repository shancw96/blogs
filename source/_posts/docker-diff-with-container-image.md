---
title: Docker Image Vs Container
categories: [Docker]
tags: []
toc: true
date: 2020/9/18
---

## what is a docker image

A Docker image is an immutable (unchangeable) file that contains the source code, libraries, dependencies, tools, and other files needed for an application to run —— read-only

docker image 是只读文件，是某一个系统运行时的一个快照，可以作为 container 创建的基础模版

<img src="diff.png" alt="difference between image and container" style="zoom: 50%" />

## what is a docker container

A Docker container is a virtualized run-time environment where users can isolate applications from the underlying system
docker container 是一个虚拟的运行环境（每个 container 都是相互隔离的独立单元）

<img src="container-vs-vm.png" alt="difference between vm and container" style="zoom: 50%" />

VM 是模拟的硬件层，container 模拟的是 app 应用层。如图，可以看到 container 基于的 OS(操作系统)是同一个

## Images vs Containers

Image 可以独立存在，但是 Container 需要运行 Image 才能产生: Image -----> container

### 从 dockerFile 创建 image， 从 image 创建 Container

<img src="connect.png" alt="connection between image and container " style="zoom: 50%" />

1. `DockerFile` -> image: `docker build`
2. image -> container: `docker create`

## docker hub

### images 种类

- **Base images** are images that have no parent images, usually images with an **OS** like ubuntu, alpine or debian.

- **Child images** are images that **build on base images** and add additional functionality.
