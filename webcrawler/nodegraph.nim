import tables, sets, uri

type
  Node = ref object
    uri: Uri
  Graph* = object
    nodes: HashSet[Node]
    incoming, outgoing: Table[Uri, HashSet[Node]]
