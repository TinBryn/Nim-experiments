import typetraits

type
  AnyMatrix*[R, C: static int; T] = concept m, var v, type M
    M.ValueType is T
    M.Rows == R
    M.Cols == C

    m[int, int] is T
    v[int, int] = T

    type TransposedType = stripGenericParams(M)[C, R, T]

proc transposed*(m: AnyMatrix): m.TransposedType =
  for row in 0 ..< m.R:
    for col in 0 ..< m.C:
      result[row, col] = m[col, row]