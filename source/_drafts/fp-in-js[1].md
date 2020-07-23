---
title: fp-in-js
categories: [Functional Programming]
tags: []
toc: true
date: 2020/7/17
---

# search student

## imperative code

```js
async function showStudent(ssn) {
  const student = await db.get(ssn);
  if (student) {
    document.querySelector(
      `#${elementId}`
    ).innerHTML = `${student.ssn}, ${student.firstname}, ${student.lastname}`;
  } else {
    throw new Error("student not Found");
  }
}
```

## FP

```js
const find = _.curry((db, id) => {
  const result = db.get(id); // 为了更加通用不使用student 作为变量名
  if (!result) throw new Error("Object not Found");
});

const cvs = (student) =>
  `${student.ssn}, ${student.firstname}, ${student.lastname}`;

const append = (document.querySelector(elementId).innerHTML = info);

// curry + compose 实现 control flow
const showStudent = _.compose(append("#student-info"), csv, find(db));

showStudent("8888-888-88");
```

# 求平均值

```js
let enrollment = [
  { enrolled: 2, grade: 100 },
  { enrolled: 2, grade: 80 },
  { enrolled: 1, grade: 89 },
];
```

## imperative code

```js
var totalGrades = 0;
var totalStudentsFound = 0;
for (let i = 0; i < enrollment.length; i++) {
  let student = enrollment[i];
  if (student !== null) {
    if (student.enrolled > 1) {
      totalGrades += student.grade;
      totalStudentsFound++;
    }
  }
}
var average = totalGrades / totalStudentsFound; //-> 90
```

## fp

### version1 简单组合

```js
fun() {
  const calcNumAvg = ({sum, size}) => sum / size;
  const getSumAndSize = array => ({
    sum: array.reduce((total, item) => (total += _.get(item, "grade")), 0),
    size: array.length
  });
  const run = _.compose(calcNumAvg,getSumAndSize);
  return run(enrollment)
}

```

### 使用 combinator-join

```js
const calc_avg = _.join(
  (len, sum) => sum / avg,
  calc_size,
  (arr) => arr.reduce((total, item) => (total += _.get(item, "grade")), 0),
  (arr) => arr.length
);
const ans = calc_avg([1, 1, 2, 1, 23, 12, 3, 123, 1, 23, 12, 3]);
```

个人理解的最佳模型：

```js
const input = [xxx, xxx, xxx];
const fn1 = statement1
const fn2 = statement2
const finalFn = compose(fn1, ..., fnn);
const result = finalFn(input);

```

# FP 错误处理 null - checking

当连续一系列查询发生的时候，怎么处理查询失败情况

## imperative way

```js
function getCountry(student) {
  let school = student.getSchool();
  if (school !== null) {
    let addr = school.getAddress();
    if (addr !== null) {
      let country = addr.getCountry();
      return country;
    }
  }
  throw new Error("Error extracting country info");
}
```

## FP

### Functor

#### wrapper( wrap :: A -> Wrapper(A))

```js
class Wrapper {
  constructor(value) {
    this._value = value;
  }
  //map :: (A -> B) -> A -> B
  map(f) {
    return f(this._value);
  }
  toString() {
    return `Wrapper(${this.value})`;
  }
}
// wrap  :: A -> Wrapper(A)
const wrap = (val) => new Wrapper(val);
```

#### fmap ( fmap :: (A -> B) -> Wrapper[A] -> Wraper[B] )

```js
Wrapper.prototype.fmap = function (f) {
  return wrap(f(this.val));
};
```

基于 container 的简单操作: 2 + 3 = 5

```js
const plus = R.curry((a, b) => a + b);
const plus2 = plus(2);
const three = wrap(3);
three
  .fmap(plus2) //-> Wrapper(5)
  .map(R.identity); // -> 5

//简化版
const plus = R.curry((a, b) => a + b);

wrap(3)
  .fmap(plus(2))
  .map((_) => _); // -> 5
```
