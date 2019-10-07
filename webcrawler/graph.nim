import tables, sets

type
  Graph*[T] = object
    nodes: HashSet[T]
    incoming, outgoing: Table[T, HashSet[T]]

#
proc newGraph*[T](): Graph[T] =
  Graph[T]()

#
proc containsOrIncl*[T](self: var Graph[T], value: T): bool =
  self.nodes.containsOrIncl(value)

#
proc add_edge*[T](self: var Graph[T], fr, to: T) =
  self.incoming.mgetOrPut(fr, initHashSet[T]()).incl(to)
  self.outgoing.mgetOrPut(to, initHashSet[T]()).incl(fr)

#
iterator parents*[T](self: Graph[T], t: T): T =
  if self.incoming.hasKey(t):
    let s: HashSet[T] = self.incoming[t]
    for i in s.items:
      yield i

#
when isMainModule:
  var g = newGraph[int]()
  echo g