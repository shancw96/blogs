function new_polyfill(father, ...args) {
  if(!typeof father === "function") throw new TypeError('constructor must be function');
  let result = Object.create(father.prototype);
  const result2 = father.apply(result, args);
  // 构造函数返回了非空对象
  if (
    (typeof result2 === "object" || typeof result2 === "function") &&
    result2 !== null
  ) {
    return result2;
  }
  return result;
}

function People(name, age) {
  this.name = name,
  this.age = age
}
const peo = new People('sh', 25)
const ceo = new_polyfill(People, 'sh', 25)
console.log(peo, ceo)
ttttttt