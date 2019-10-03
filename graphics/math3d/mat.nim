type
  Matrix*[R, C: static int, T]{.explain.} = concept m, var v, type M
    M.Rows == R
    M.Cols == C
    m[int, int] is T
    v[int, int] = T
  
  Mat[N: static int] = object
    data: array[N * N, cfloat]


  

proc `-`[R, C: static int, T](a: Matrix[R, C, T]): Matrix[R, C, T] =
  for i in 0 ..< R:
    for j in 0 ..< C:
      result[i, j] = -a[i, j]