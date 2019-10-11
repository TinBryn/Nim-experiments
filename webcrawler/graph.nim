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
proc add_edge[T](self: var Graph[T], fr, to: T) =
  self.incoming.mgetOrPut(fr, initHashSet[T]()).incl(to)
  self.outgoing.mgetOrPut(to, initHashSet[T]()).incl(fr)

#
proc add_edges*[T](self: var Graph[T], edges: varargs[(T, T)]) =
  for edge in edges:
    self.add_edge(edge[0], edge[1])

#
iterator parents*[T](self: Graph[T], t: T): T =
  if self.incoming.hasKey(t):
    for i in self.incoming[t]:
      yield i

#
when isMainModule:
  var g = newGraph[int]()
  echo g