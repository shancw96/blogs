---
title: 什么是DTO，使用场景是什么?
categories: [Java]
tags: [Spring]
toc: true
date: 2021/4/19
---

# 什么是 DTO？

`页面展示UI <---> DTO <----> Entity <----> 业务`

数据传输对象,用于表现层（前端）和应用层（entity）的数据交互。

DTO 是面向界面 UI,是通过 UI 的需求来定义的.通过 DTO 我们实现了表现层 UI 与 entity 之间的解耦。

> 这句话的意思是，后端不直接返回 Entity 实体给前端，而是封装一个前端需要的数据格式给他。这就是 DTO

数据传输对象 DTO 是根据 UI 的需求进行设计的，而不是根据领域对象 Entity 进行设计的。
比如，Customer 领域对象可能会包含一些诸如 FirstName, LastName, Email, Address 等信息。
**但如果 UI 上不打算显示 Address 的信息，那么 CustomerDTO 中也无需包含这个 Address 的数据**.

model 面向业务，我们通过业务来定义 Entity。而 DTO 面向 UI，通过 UI 的需求来定义。通过 DTO，我们实现了 UI 和 Entity 之间的解耦。如果开发过程中 Entity 发生改变，而 UI 不变，那么只需要改动 DTO 和 Entity 之间的映射关系而不需要去改变 UI。

# 项目中的使用例子

entity

```java
/**
 * 角色
 * @author Zheng Jie
 * @date 2018-11-22
 */
@Getter
@Setter
@Entity
@Table(name = "sys_role")
public class Role extends BaseEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JSONField(serialize = false)
    @ManyToMany(mappedBy = "roles")
    private Set<User> users;

    @ManyToMany
    private Set<Menu> menus;

    @ManyToMany
    private Set<Dept> depts;

    @ApiModelProperty(value = "名称", hidden = true)
    private String name;

    private String dataScope = DataScopeEnum.THIS_LEVEL.getValue();

    @Column(name = "level")
    private Integer level = 3;

    private String description;
}

```

DTO

```java
@Getter
@Setter
public class RoleDto extends BaseDTO implements Serializable {

    private Long id;

    private Set<MenuDto> menus;

    private Set<DeptDto> depts;

    private String name;

    private String dataScope;

    private Integer level;

    private String description;
}

```

Service

```Java
public class RoleServiceImpl implements RoleService {
  @Override
    public List<RoleDto> queryAll() {
        Sort sort = Sort.by(Sort.Direction.ASC, "level");
        return roleMapper.toDto(roleRepository.findAll(sort));
    }
}
```
