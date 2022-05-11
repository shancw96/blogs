---
title: Type Challenges
categories: [前端]
tags: [typescript, promise]
toc: true
date: 2022/5/3
---

Typescript 类型体操，每日一题，重学 TS

<!-- more -->

## Easy

### [Pick](https://tsch.js.org/4)

```tsx
// Implement the built-in `Pick<T, K>` generic without using it.

// Constructs a type by picking the set of properties `K` from `T`

// For example

interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyPick<Todo, "title" | "completed">;

const todo: TodoPreview = {
  title: "Clean room",
  completed: false,
};

// answer
type MyPick<T, K extends keyof T> = {
  [k in K]: T[k];
};
```

#### 涉及到的知识点：

##### [extends](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)

用于范型约束，限制范型可能出现的种类

##### [keyof](https://www.typescriptlang.org/docs/handbook/2/keyof-types.html)

keyof 操作符，接受一个 object，返回其 key 的集合

```typescript
type Point = {
  x: number;
  y: number;
};
type p = keyof Point; // ==> type p = 'x'| 'y'
```

##### [in](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-in-operator-narrowing)

in 操作符用于判断 object 是否有特定的属性

```typescript
type Fish = { swim: () => void };
type Bird = { fly: () => void };

function move(animal: Fish | Bird) {
  if ("swim" in animal) {
    return animal.swim();
  }

  return animal.fly();
}
```

### [implement Readonly](https://github.com/type-challenges/type-challenges/blob/main/questions/00007-easy-readonly/README.md)

Implement the built-in `Readonly<T>` generic without using it.

Constructs a type with all properties of T set to readonly, meaning the properties of the constructed type cannot be reassigned.

For example

```typescript
interface Todo {
  title: string
  description: string
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar"
}

todo.title = "Hello" // Error: cannot reassign a readonly property
todo.description = "barFoo" // Error: cannot reassign a readonly property
```

#### 涉及到的知识点：

##### readonly

只读，会将iterable 对象的所有key设置为只读

```typescript
type MyReadOnly<T> = {
  readonly [key in keyof T]: T[key]
}
```



### Tuple to Object

Give an array, transform into an object type and the key/value must in the given array.

For example

```typescript
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

type result = TupleToObject<typeof tuple> // expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
```



answer:

```typescript
type TupleToObject<T extends string[]> = {
  [valye in T[number]]: value
}
```

知识点：



##### [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)

```typescript
type Person = { age: number; name: string; alive: boolean };

type Age = Person["age"]; //-> type Age = number
```

##### Mapped Types

 using `number` to get the type of an array’s elements

![image-20220504223237103](https://blog.shancw.net/public/uploads/image-20220504223237103.png)

##### [typeof](https://www.typescriptlang.org/docs/handbook/2/typeof-types.html#handbook-content)

TypeScript adds a `typeof` operator you can use in a *type* context to refer to the *type* of a variable or property:





### First Of Array

Implement a generic `First<T>` that takes an Array `T` and returns it's first element's type.

For example

```typescript
type arr1 = ['a', 'b', 'c']
type arr2 = [3, 2, 1]

type head1 = First<arr1> // expected to be 'a'
type head2 = First<arr2> // expected to be 3
```

answer：

```typescript
type First<T extends unknown[]> = T['length'] extends 0 ? T[0] : never
```



#### 知识点

+ [Conditional Type Constraints](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#conditional-type-constraints)

  `First<T extends unknown[]> = T['length']` 对于这块内容, T extends unknown[] 限制了 T的范围是数组，因此可以通过[indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html) 来获取 T['length']

  `T extends something ? TypeA : TypeB` 就是条件类型约束的写法

+ [unkown any 区别](https://stackoverflow.com/questions/51439843/unknown-vs-any/51439876#51439876)

  unkown 是 type-safe 的 any，任何类型都可以声明为unknown，但如果在使用之前没有做任何类型指定，那么针对unknown的任何操作都会抛出错误

  ```typescript
  let vAny: any = 10;          // We can assign anything to any
  let vUnknown: unknown =  10; // We can assign anything to unknown just like any 
  
  
  let s1: string = vAny;     // Any is assignable to anything 
  let s2: string = vUnknown; // Invalid; we can't assign vUnknown to any other type (without an explicit assertion)
  
  vAny.method();     // Ok; anything goes with any
  vUnknown.method(); // Not ok; we don't know anything about this variable
  ```

  

### [MyAwaited](https://github.com/type-challenges/type-challenges/blob/main/questions/00189-easy-awaited/README.md)

If we have a type which is wrapped type like Promise. How we can get a type which is inside the wrapped type? For example if we have `Promise<ExampleType>` how to get ExampleType?

answer

```typescript
/* _____________ Your Code Here _____________ */

type MyAwaited<T> = T extends Promise<infer item> 
  ? item extends Promise<any> 
    ? MyAwaited<item> 
    : item 
  : never
/* _____________ Test Cases _____________ */
import type { Equal, Expect } from '@type-challenges/utils'

type X = Promise<string>
type Y = Promise<{ field: number }>
type Z = Promise<Promise<string | number>>

type cases = [
  Expect<Equal<MyAwaited<X>, string>>,
  Expect<Equal<MyAwaited<Y>, { field: number }>>,
  Expect<Equal<MyAwaited<Z>, string | number>>,
]

// @ts-expect-error
type error = MyAwaited<number>

```



#### 知识点

+ [infer](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types) 补充类型推断时候可能出现的范型

  Conditional types provide us with a way to infer from types we compare against in the true branch using the `infer` keyword.

  我们可以使用infer对 条件判断类型 true的那部分内容，进行推断

  **以flatten 为例**

  ```typescript
  type Flatten<T> = T extends any[] ? T[number] : T;
  ```

  When `Flatten` is given an array type, it uses an indexed access with `number` to fetch out `string[]`’s element type. Otherwise, it just returns the type it was given.

  当Flatten接收的类型是array，那么使用 indexed access + number 来获取Array具体元素的值

  **使用infer来进行改写**

  ```typescript
  type Flatten<T> = T extends Array<infer Item> ? Item : T
  ```

+ [use infer in Typescript](https://blog.logrocket.com/understanding-infer-typescript/#:~:text=Using%20infer%20in%20TypeScript,to%20be%20referenced%20or%20returned.)

