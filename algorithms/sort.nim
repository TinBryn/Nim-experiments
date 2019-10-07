type
  Comparable* = concept c
    cmp(c, c) is int
  Swappable* = concept s, var v
    swap(v, v)
  Sortable*[T] = concept s, var v
    s[Natural] is T
    v[Natural] = T
    s.len is Ordinal
    T is Comparable
    T is Swappable

proc insertionSort*[T](arr: var Sortable[T]) =
  for i in 1 ..< arr.len:
    let k = arr[i]
    var j = i
    while j > 0 and arr[j-1] > k:
      arr[j] = arr[j-1]
      j.dec
    arr[j] = k



proc quickSort*[T](arr: var Sortable[T]) =

  proc partition(arr: var Sortable[T], start, after: Natural): Natural =
    let pivot = arr[after-1]
    var i = start
    for j in start ..< after-1:
      if arr[j] < pivot:
        swap(arr[i], arr[j])
        i.inc
    swap(arr[i], arr[after-1])
    result = i
  
  proc quickSort(arr: var Sortable[T], start, after: Natural) =
    if after - start > 1:
      let part = arr.partition(start, after)
      arr.quickSort(start, part)
      arr.quickSort(part, after)
      
  arr.quickSort(0, arr.len)

when isMainModule:
  var arr = [5, 4, 1, 3, 6, 7, 2]
  arr.quickSort()
  echo arr
