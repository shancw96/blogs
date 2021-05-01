---
title: mapStruct handbook
categories: [后端]
tags: [Spring, ORM, 项目架构]
toc: true
date: 2021/4/27
---

mapStruct 用于对象转换, 在项目中主要用于 DTO <-> entity 之间的转换，这篇文章介绍了 mapStruct 的配置和常用 API

<!-- more -->

# 安装使用

## maven 配置项

```xml
...
<properties>
    <java.version>11</java.version>
		<mapstruct.version>1.4.2.Final</mapstruct.version>
		<lombok.version>1.18.20</lombok.version>
</properties>
...
<dependencies>
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>${mapstruct.version}</version>
    </dependency>
</dependencies>
...
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
              <!-- 这里的Java 版本需要按照你项目里的Java 版本进行设置 -->
              <source>${java.version}</source>
              <target>${java.version}</target>
              <annotationProcessorPaths>
                  <path>
                      <groupId>org.mapstruct</groupId>
                      <artifactId>mapstruct-processor</artifactId>
                      <version>${org.mapstruct.version}</version>
                  </path>
                  <!-- other annotation processors -->
                  <!-- 集成lombok：mapStruct 使用 @Getter @Setter ...注解 -->
                  <path>
                    <groupId>org.projectlombok</groupId>
                    <artifactId>lombok</artifactId>
                    <version>${lombok.version}</version>
                  </path>
                </annotationProcessorPaths>
            </configuration>
        </plugin>
    </plugins>
</build>
...
```

## 项目中配置

创建 mapper 包，通过创建 instance 的方式，实现指定 entity 的转换

配置接口：articleMapper interface

```java
@Mapper
public interface ArticleMapper {
    ArticleMapper INSTANCE = Mappers.getMapper(ArticleMapper.class);

    Article covert(ArticleDto articleDto);

    @Mapping(source = "title", target="title")
    ArticleDto covert(Article article);
}

```

编译后，会在 target/generated-source/annotations/com.xxx.xxx.mapper 下生成 interface ArticleMapper 的具体实现

```java
@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2021-04-27T13:26:18+0800",
    comments = "version: 1.4.2.Final, compiler: javac, environment: Java 15.0.2 (Oracle Corporation)"
)
public class ArticleMapperImpl implements ArticleMapper {

    @Override
    public Article covert(ArticleDto articleDto) {
        if ( articleDto == null ) {
            return null;
        }

        Article article = new Article();

        article.setUpdateTime( articleDto.getUpdateTime() );
        article.setCreateTime( articleDto.getCreateTime() );
        article.setId( articleDto.getId() );
        article.setTitle( articleDto.getTitle() );
        article.setVisitCount( articleDto.getVisitCount() );
        article.setContent( articleDto.getContent() );
        List<Comment> list = articleDto.getComments();
        if ( list != null ) {
            article.setComments( new ArrayList<Comment>( list ) );
        }

        return article;
    }

    @Override
    public ArticleDto covert(Article article) {
        if ( article == null ) {
            return null;
        }

        ArticleDto articleDto = new ArticleDto();

        articleDto.setTitle( article.getTitle() );
        articleDto.setCreateTime( article.getCreateTime() );
        articleDto.setUpdateTime( article.getUpdateTime() );
        articleDto.setId( article.getId() );
        articleDto.setVisitCount( article.getVisitCount() );
        List<Comment> list = article.getComments();
        if ( list != null ) {
            articleDto.setComments( new ArrayList<Comment>( list ) );
        }
        articleDto.setContent( article.getContent() );

        return articleDto;
    }
}

```

使用：

```java
Article article = new Article(...);

ArticleDto dto = ArticleMapper.INSTANCE.convert(article);
```

# 常用 mapping

- int and String

```java
    @Mapper
    public interface CarMapper {

        @Mapping(source = "price", numberFormat = "$#.00")
        CarDto carToCarDto(Car car);

        @IterableMapping(numberFormat = "$#.00")
        List<String> prices(List<Integer> prices);
    }
```

- Date and String

  ```java
  @Mapper
  public interface CarMapper {

          @Mapping(source = "manufacturingDate", dateFormat = "dd.MM.yyyy")
          CarDto carToCarDto(Car car);

          @IterableMapping(dateFormat = "dd.MM.yyyy")
          List<String> stringListToDateList(List<Date> dates);
      }
  ```

## 多对象转一个对象

Address

```java
@Data
public class Address {
    private String street;
    private Integer zipCode;
    private Integer houseNo;
    private String description;
}

```

UserWithAddress

```java
@Data
public class UserWithAddressVo {

    private String username;
    private Integer sex;
    private String street;
    private Integer zipCode;
    private Integer houseNumber;
    private String description;
}

```

convert 方法

```java
@Mapping(source = "person.description", target = "description")
@Mapping(source = "address.houseNo", target = "houseNumber")
UserWithAddressVo userAndAddress2Vo(User user, Address address);

```

当多个原对象中，有相同名字的属性时，需要通过 @Mapping 注解来具体的指定， 以免出现歧义（不指定会报错）。 如上面的 description

## 忽略特定字段

```java
@Mapper
public interface FishTankMapper {

    @Mapping(target = "fish.name", ignore = true)
    FishTankDto map( FishTank source );
}
```

## 默认值

```java
@Mapper(uses = StringListMapper.class)
public interface SourceTargetMapper {

    SourceTargetMapper INSTANCE = Mappers.getMapper( SourceTargetMapper.class );

    @Mapping(target = "stringProperty", source = "stringProp", defaultValue = "undefined")
    @Mapping(target = "longProperty", source = "longProp", defaultValue = "-1")
    Target sourceToTarget(Source s);
}
```

## 使用表达式

### 自定义表达式

```java

imports org.sample.TimeAndFormat;

@Mapper( imports = TimeAndFormat.class )
public interface SourceTargetMapper {

    SourceTargetMapper INSTANCE = Mappers.getMapper( SourceTargetMapper.class );

    @Mapping(target = "timeAndFormat",
         expression = "java( new TimeAndFormat( s.getTime(), s.getFormat() ) )")
    Target sourceToTarget(Source s);
}

```

### 默认表达式

当属性值为 null 触发

```java
imports java.util.UUID;

@Mapper( imports = UUID.class )
public interface SourceTargetMapper {

    SourceTargetMapper INSTANCE = Mappers.getMapper( SourceTargetMapper.class );

    @Mapping(target="id", source="sourceId", defaultExpression = "java( UUID.randomUUID().toString() )")
    Target sourceToTarget(Source s);
}
```

更多转化查看[MapStruct: 5.1. Implicit type conversions](https://mapstruct.org/documentation/stable/reference/html/#implicit-type-conversions)
