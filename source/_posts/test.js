function fib_memo(n) {
  let table = [];
  table[0] = 0
  table[1] = 1
  return fib_core(n)
  function fib_core(n) {
    if(typeof table[n] === 'number') return table[n]
    table[n] = fib_core(n - 1) + fib_core(n - 2)
    return table[n]
  }
}

function fib_table(n) {
  const table = [0, 1]
  for(let i = 2;i<=n;i++) {
    table[i] = table[i - 1] + table[i-2]
  }
  return table[n]
}
console.log(fib_memo(4), fib_table(4))