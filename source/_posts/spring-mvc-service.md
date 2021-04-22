---
title: Spring MVC 中Service 的存在原因和使用
categories: [后端]
tags: [Spring Boot]
toc: true
date: 2021/4/19
---

# 什么是 Service 层

Service 层位于 repository 和 Controller 之间。负责处理所有的业务逻辑。

Controller 层像是一个服务员，他把客人（前端）点的菜（数据、请求的类型等）进行汇总什么口味、咸淡、量的多少，交给厨师长（Service 层），厨师长则告诉沾板厨师（Dao 1）、汤料房（Dao 2）、配菜厨师（Dao 3）等（统称 Dao 层）我需要什么样的半成品，副厨们（Dao 层）就负责完成厨师长（Service）交代的任务。

Controller--> Service (service 接口-->serviceImpl) -->repository 接口-->db

<!-- more -->

# 如何设计 service 层

Service 层主要负责业务模块的逻辑应用设计。**先设计放接口的类，再创建实现的类**，然后在配置文件中进行配置其实现的关联。service 层调用 repository 接口，接收 repository 返回的数据，完成项目的基本功能设计。

## 代码设计方式

- Interface + Class 面向服务

  ```java
  // 业务层接口

  public interface IUserService {
      boolean login(User user);
  }
  // 业务层实现类

  @Service("userService")
  public class UserServiceImpl implements IUserService {
      public boolean login(User user) {
          //登录判断逻辑
      }
  }

  ```

- 单独 Class 面向业务
  对于一个中小项目来说，脱掉 Service 层接口的枷锁，实现起业务来，十分流畅，不再用抽象，只关注于业务即可。

  ```java
  public class UserService{
      public boolean login(User user) {
          //登录判断逻辑
      }
  }
  ```

# Service 设计需要注意的点

## Service 间能够相互调用？

Service 间不应该相互调用，特别是去除接口的情况下，让 Service 完全成为一个业务体的设计下，更加不应该相互调用 Service。
每个 Service 对应一个业务，业务之间应该有明确的分界，不然会出现业务间的耦合，这是设计的不合理。

如果是 Service 间的逻辑通用，可以创建一个 ServiceHelper 类,里面放的，就是 Service 间的通用逻辑，各自调用这个逻辑即可。

## Service 的业务逻辑只由 Service 自己知道

用户登录的例子：

错误示范：

```java
@Service("userService")
public class UserService {
    public boolean login(User user) {
        //登录判断逻辑
    }
}

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public
    @ResponseBody ResponseResult login(@RequestBody User form) {
        if(userService.login(form)) {
            return ResponseResult.getOk("登陆成功");
        } else {
            return ResponseResult.getError("登陆失败");
        }
    }
}
```

这个 Service 最终会被一个 Controller 所调用，当 Controller 调用该方法时，还需要判断返回值是 true 还是 false，再返回结果，**其逻辑“泄露”了**，因为 Controller 要了解业务是 true 是登陆成功

正确的方式：

```java

@Service("userService")
public class UserService {
    /** * @return ResponseResult响应结果.为{"status":"状态码","msg":"响应信息","data":"响应数据"} */
    public ResponseResult login(User entity) {
        //用MD5加密密码
        entity.setPassword(MD5Utils.getMD5(entity.getPassword()));
        //用账号和加密后的密码为查询条件，查询数据库中是否有对应的数据
        Optional<User> optional = userRepository.selectOne(entity);
        return optional.map(ResponseResult::getOk).orElseGet(() -> ResponseResult.getError("账号/密码错误"));
    }
}

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public
    @ResponseBody ResponseResult login(@RequestBody User form) {
        return userService.login(form);
    }
}
```

平时我们一直说，Controller 一定要尽量少的逻辑，其实反过来说，是指 Service 的逻辑应该高内聚，这样 Controller 如 Service 的耦合自然就是最低，Controller 真真正正的坐到，不用理会 Service 的实现，只需要调用即可。

# 参考文章：

- [\*如何设计 Service 层](https://my.oschina.net/bingzhong/blog/1559856)

* [SpringBoot 框架中的 DAO 层、Entity 层、Service 层、Controller 层](https://www.jianshu.com/p/18c4418e9b99)
