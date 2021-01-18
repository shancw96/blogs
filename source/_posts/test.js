function curry(fn) {
  let accArgs = [];
  return function curried(...args) {
    accArgs = [...accArgs, ...args];
    if (fn.length === accArgs.length) return fn(...accArgs);
    else return curried
  };
}

var abc = function(a, b, c) {
  console.log([a, b, c])
};
 
var curried = curry(abc);
 
curried(1)(2)(3);
// => [1, 2, 3]
 
curried(1, 2)(3);
// => [1, 2, 3]
 
curried(1, 2, 3);
// => [1, 2, 3]
 
// // Curried with placeholders.
// curried(1)(_, 3)(2);
// // => [1, 2, 3]