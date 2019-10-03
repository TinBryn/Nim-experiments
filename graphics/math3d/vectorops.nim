import vec

#
proc `+`*[N: static int](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = a[i] + b[i]
#
proc `-`*[N: static int](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = a[i] - b[i]
#
proc `-`*[N: static int](a: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = -a[i]

proc `*`*(a, b: Vec[3]): Vec[3] =
  ## c_i = e_ijk * a_j * b_k
  for i in 0..2:
    result[i] = a[(i+1) mod 3] * b[(i+2) mod 3] - a[(i+2) mod 3] * b[(i+1) mod 3]