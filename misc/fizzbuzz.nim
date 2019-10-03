iterator fizz_buzz(min, max: int): string =
  proc _(n: int): string =
    if n mod 3 == 0: result.add("fizz")
    if n mod 5 == 0: result.add("buzz")
    if result.len == 0: result.add($n)
  for i in min .. max:
    yield i._

for i in fizz_buzz(1, 100):
  echo i
