type
  Queue*[T] = object
    data: seq[T]
    front, count: Natural

proc newQueue*[T](size: int): Queue[T]
proc len*[T](queue: Queue[T]): Natural
proc back[T](queue: Queue[T]): Natural
proc index[T](queue: Queue[T], idx: Natural): Natural
proc `[]`*[T](queue: Queue[T], idx: Natural): T
proc `[]=`*[T](queue: var Queue[T], idx: Natural, item: T)
proc enqueue*[T](queue: var Queue[T], item: T): var Queue[T]{.discardable.}
proc dequeue*[T](queue: var Queue[T]): T

proc newQueue*[T](size: int): Queue[T] =
  Queue[T](data: newSeq[T](size))

proc len*[T](queue: Queue[T]): Natural =
  queue.count

proc index[T](queue: Queue[T], idx: Natural): Natural =
  assert(idx < queue.len)
  (queue.front + idx) mod queue.data.len

proc back[T](queue: Queue[T]): Natural =
  (queue.front + queue.len) mod queue.data.len

proc `[]`*[T](queue: Queue[T], idx: Natural): T =
  queue.data[queue.index(idx)]

proc `[]=`*[T](queue: var Queue[T], idx: Natural, item: T) =
  queue.data[queue.index(idx)] = item

proc enqueue*[T](queue: var Queue[T], item: T): var Queue[T]{.discardable.} =
  assert(queue.len < queue.data.len)
  queue.data[queue.back] = item
  queue.count += 1
  queue

proc dequeue*[T](queue: var Queue[T]): T =
  assert(queue.len > 0)
  result = queue.data[queue.front]
  queue.count -= 1
  queue.front += 1

proc `<<`*[T](queue: var Queue[T], value: T): var Queue[T]{.discardable.} =
  queue.enqueue(value)

iterator items*[T](queue: Queue[T]): T =
  for i in 0 ..< queue.len:
    yield queue[i]
