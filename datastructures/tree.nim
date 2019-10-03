import strformat

type
  Node[T] = ref object
    item: T
    size: Natural
    le, ri: Node[T]

  Tree*[T] = object
    root: Node[T]

#construct and empty tree node
proc node*[T](): Node[T] = nil

#constructs a node from a value and 2 others which default to empty nodes
proc node*[T](value: T, left, right: Node[T] = nil): Node[T] =
  result = Node[T](item: value, le: left, ri: right, size: 1)
  if not left.isNil:
    result.size += left.size
  if not right.isNil:
    result.size += right.size

#constructs a Tree from a value
proc newTree*[T](value: T): Tree[T] =
    Tree[T](root: value.node)

#inserts a value into a tree, maintaining the BST property
proc insert[T](root: Node[T], value: T): Node[T] =
  if root == nil:
    value.node
  else:
    if value < root.item:
      root.le = insert(root.le, value)
    else:
      root.ri = insert(root.ri, value)
    root

proc insert*[T](tree: var Tree[T], value: T) =
    tree.root = tree.root.insert(value)

#inserts a value into a tree if it doesn't already exist
proc insert_distinct[T](root: Node[T], value: T): Node[T] =
  if root == nil:
    value.node
  else:
    if value < root.item:
      root.le = insert_distinct(root.le, value)
    elif value > root.item:
      root.ri = insert_distinct(root.ri, value)
    root

proc push_left[T](stack: var seq[Node[T]], root: Node[T]) =
    if root != nil:
        stack.add(root)
        stack.push_left(root.le)

proc `>`[T](stack: seq[T], size: Natural): bool =
    stack.len > size

iterator inorder[T](root: Node[T]): T =
    var stack: seq[Node[T]] = @[]
    stack.push_left(root)
    while stack.len > 0:
        let tree = stack.pop()
        yield tree.item
        stack.push_left(tree.ri)

proc inorder_iter*[T](root: Tree[T]): iterator(): T =
    iterator _(root: Node[T]): T {.closure.} =
        var stack: seq[Node[T]] = @[]
        stack.push_left(root)
        while stack > 0:
            let tree = stack.pop()
            yield tree.item
            stack.push_left(tree.ri)

iterator inorder*[T](tree: Tree[T]): T =
    for i in tree.root.inorder:
        yield i

proc `$`[T](root: Node[T]): string =
    if root == nil:
        "()"
    else:
        if root.le.isNil and root.ri.isNil:
            fmt"{root.item}"
        else:
            fmt"({root.le}<-{root.item}->{root.ri})"

proc `$`*[T](tree: Tree[T]): string =
    $tree.root

when isMainModule:
  var tree = 4.newTree
  tree.insert(2)
  tree.insert(1)
  tree.insert(3)
  tree.insert(6)
  tree.insert(5)
  tree.insert(7)

  echo tree