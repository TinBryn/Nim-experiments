type
  List*[T] = object
    root: Node[T]
  Node[T] = ref object
    item: T
    next: Node[T]

proc newNode[T](item: T, next: Node[T] = nil): Node[T] =
  Node[T](item: item, next: next)

proc newList*[T](item: T): List[T] =
  List[T](root: item.newNode)

proc newList*[T](): List[T] =
  List[T](root: nil)

proc createList*[T](): List[T] =
  List[T](root: nil)

proc createList*[T](first: T, values: varargs[T]): List[T] =
  result.root = newNode(first)
  var curr = result.root
  for value in values:
    curr.next = newNode(value)
    curr = curr.next


proc isEmpty*[T](list: List[T]): bool =
  list.root == nil

proc map*[T, U](list: List[T], f: proc(t: T): U): List[U] =
  discard


proc nonEmpty*[T](list: List[T]): bool = not list.isEmpty

iterator items*[T](list: List[T]): T =
  var node = list.root
  while node != nil:
    yield node.item
    node = node.next

proc append*[T](list: var List[T], item: T) =
  var curr = list.root
  if curr != nil:
    while curr.next != nil:
      curr = curr.next
      curr.next = item.newNode
  else:
    list = item.newList

proc prepend*[T](list: var List[T], item: T) =
  list.root = item.newNode(list.root)

proc push*[T](list: var List[T], item: T) =
  list.prepend(item)

proc pop*[T](list: var List[T]): T =
  assert(list.root != nil)
  result = list.root.item
  list.root = list.root.next

import macros

proc fold[T, U](list: List[T], zero: U, fun: (proc(t: T, u: U): U)): U =
  result = zero
  for t in list:
    result = fun(t, result)

let a = 1
let b = 2

let list = createList(1, 2, 3)

echo list.fold(0) do (t: int, u: int) -> int:
   t + u

