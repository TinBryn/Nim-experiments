import tree, macros

proc turnArrayIntoTree(arr: NimNode): NimNode{.compileTime.} =
  case arr.kind
  of nnkBracket:
    result = newNimNode(nnkBracket)
    for i in 0 ..< arr.len:
      result.add(turnArrayIntoTree(arr[i]))
  else:
    result = arr



macro arrayToTree(arr: untyped): untyped =
  result = turnArrayIntoTree(arr)
  echo result.repr

dumpTree:
  Tree[int](root: node(4, node(2, node(1), node(3)), node(6, node(5), node(7))))

dumpTree:
  [[[1], 2, [3]], 4, [[5], 6, [7]]]

let a = arrayToTree([[[1], 2, [3]], 4, [[5], 6, [7]]])

