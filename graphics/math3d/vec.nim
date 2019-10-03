type Vec*[N: static int] = object
  data: array[N, cfloat]

#
proc makeVec3(x, y, z: cfloat = 0): Vec[3] =
  Vec[3](data: [x, y, z])

#
proc `[]`*[N: static int](vec: Vec[N], i: int): cfloat =
  vec.data[i]

#
proc `[]=`*(vec: var Vec, i: int, value: cfloat) =
  vec.data[i] = value

#
proc `$`*[N: static int](vec: Vec[N]): string =
  when N == 0:
    "[]"
  else:
    result = "["
    for i in 0..<N-1:
      result.add($vec[i] & ", ")
    result.add($vec[N-1] & "]")

when isMainModule:
  import vectorops
  let v1 = makeVec3(0, 0, 1)
  let v2 = makeVec3(1, 1, 0)
  let v3 = v1 * v2
  echo v3
