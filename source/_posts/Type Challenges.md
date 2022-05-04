---
title: Type Challenges
categories: [前端]
tags: [typescript]
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
