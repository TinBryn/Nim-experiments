proc hash*(i: int): int = i

type
  Comparable* = concept c
    cmp(c, c) is int
  Show* = concept s
    $s is string
  Swappable* = concept sw, var v
    swap(v, v)
  Equality* = concept eq
    eq == eq is bool
  Hashable* = concept h
    h == h is bool
    hash(h) is int
  Iterable*[T] = concept it
    for i in it.items:
      i is T
  Indexable*[T] = concept i, var v
    i[int] is T
    i[int] = T
    i.len is Ordinal
  Findable*[T] = concept f
    f == f is bool
    for i in f:
      i is T


assert int is Comparable
assert int is Show
assert int is Swappable
assert int is Hashable
assert array[5, int] is Indexable
assert array[5, int] is Iterable
assert array[5, int] is Findable
