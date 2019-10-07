from httpcore import HttpMethod, HttpCode
import graph, uri, tables, hashes

type
  Status* = enum None, Enqueued, Success, Failure
  PageNode* = object
    request*: HttpMethod
    status*: Status
    error*: string
    response*: HttpCode
  
  PageGraph* = object
    graph: Graph[Uri]
    ret: Table[Uri, PageNode]

#
proc hash*(uri: Uri): Hash =
  result = 
    hash(uri.hostname) !&
    hash(uri.scheme) !&
    hash(uri.anchor) !&
    hash(uri.query) !&
    hash(uri.path) !&
    hash(uri.port)
  result = !$result

#
proc newPageNode*(): PageNode =
  PageNode(status: None, response: HttpCode(0))

#
proc add_node*(self: var PageGraph, uri: Uri): bool =
  result = not self.graph.containsOrIncl(uri)
  if result:
    self.ret[uri] = PageNode(status: Enqueued)

#
proc add_edge*(self: var PageGraph, fr, to: Uri) =
  self.graph.add_edge(fr, to)

#
iterator parents*(self: PageGraph, uri: Uri): PageNode =
  for i in self.graph.parents(uri):
    yield self.ret[i]

#
var defaultPageNode = newPageNode()

#
proc `[]`*(self: PageGraph, uri: Uri): PageNode =
  self.ret.getOrDefault(uri, defaultPageNode)

#
proc `[]=`*(self: var PageGraph, uri: Uri, node: PageNode) =
  self.ret[uri] = node
