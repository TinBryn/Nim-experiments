proc min[T](x, y: T): T =
  if x < y: x else: y
#
echo min(2, 3)
echo min("foo", "bar")