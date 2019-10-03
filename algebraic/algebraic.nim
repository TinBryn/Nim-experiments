const prime* = 1_000_000_007

type
  mInt* = distinct int32


proc `+`*(a, b: mInt): mInt =
  mInt((int32(a) + int32(b) ) mod prime)

proc `-`*(a, b: mInt): mInt =
  mInt((int32(a) - int32(b) + prime) mod prime)

proc `*`*(a, b: mInt): mInt =
  mInt((int64(a) * int64(b)) mod prime)

proc `-`*(a: mInt): mInt =
  mInt(prime - int32(a))

proc `div`(a: mInt, b: int32): mInt =
  mInt(int32(a) div b)

proc pow(a, b, c: mInt): mInt =
  case int32(b):
    of 0: c
    of 1: a * c
    else:
      case int32(b) and 1:
        of 0: pow(a * a, b div 2, c)
        else: pow(a * a, b div 2, a * c)

proc `**`(a, b: mInt): mInt =
  pow(a, b, 1.mInt)

proc inv(a: mInt): mInt = a ** mInt(prime - 2)

proc `/`*(a, b: mInt): mInt = a * b.inv
