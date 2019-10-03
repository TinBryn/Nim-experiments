proc fib(n, a, b: int): int = 
  if n == 0: a
  else: fib(n-1, b, a+b)