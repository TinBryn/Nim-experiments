import algebraic, strformat

type
  ExprTp = enum exAdd, exSub, exDiv, exMul, exNeg, exVal
  Expr* = ref object
    case kind: ExprTp:
    of exAdd, exSub, exDiv, exMul:
      left, right: Expr
    of exNeg:
      ex: Expr
    of exVal:
      val: mInt

proc ev(ex: Expr): mInt

template binOp(ex: Expr, op: proc(a, b: mInt): mInt): mInt =
  op(ev(ex.left), ev(ex.right))

proc ev(ex: Expr): mInt =
  case ex.kind:
    of exAdd: binOp(ex, `+`)
    of exSub: binOp(ex, `-`)
    of exMul: binOp(ex, `*`)
    of exDiv: binOp(ex, `/`)
    of exNeg: -ev(ex.ex)
    of exVal: ex.val

proc eval*(exp: Expr): int =
  ev(exp).int

proc `$`*(exp: Expr): string =
  case exp.kind:
    of exAdd: fmt"({exp.left} + {exp.right})"
    of exSub: fmt"({exp.left} - {exp.right})"
    of exMul: fmt"({exp.left} * {exp.right})"
    of exDiv: fmt"({exp.left} / {exp.right})"
    of exNeg: fmt"-({exp.ex})"
    of exVal: fmt"{exp.val.int}"


proc `+`*(a, b: Expr): Expr =
  Expr(kind: exAdd, left: a, right: b)

proc `-`*(a, b: Expr): Expr =
  Expr(kind: exSub, left: a, right: b)

proc `*`*(a, b: Expr): Expr =
  Expr(kind: exMul, left: a, right: b)

proc `/`*(a, b: Expr): Expr =
  Expr(kind: exDiv, left: a, right: b)

proc `-`*(a: Expr): Expr =
  Expr(kind: exNeg, ex: a)

proc ex*(n: int): Expr =
  Expr(kind: exVal, val: mInt(n mod prime))
