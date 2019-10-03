import parser_input, parser

type ParseResult*[T] = object
  rest*: Input
  case success: bool:
  of true: item*: T
  of false: message*: string

#sets the error message in the case of a failure
proc with_error*[T](self: var ParseResult[T], error: string) =
  if not self.success:
    self.message = error

proc newSuccess*[T](rest: Input, value: T, advance: Natural = 0): ParseResult[T] =
  ParseResult[T](rest: rest.substr(advance), success: true, item: value)

proc newFailure*[T](rest: Input, message: string): ParseResult[T] =
  ParseResult[T](rest: rest, success: false, message: message)

proc success*[T](self: ParseResult[T]): bool =
  self.success

#
proc `$`*[T](res: ParseResult[T]): string =
  if res.success:
    result = "success: " & $res.item
  else:
    result = "failure: " & res.message

#in the case of a success, applies the function to the value
proc map*[T, U](
  self: ParseResult[T], f: (proc(t: T): U)): ParseResult[U] =
    if self.success:
      result = newSuccess(self.rest, f(self.item))
    else:
      result = newFailure[U](self.rest, self.message)

#if it failed, try an alternative parser
proc orElse*[T](
  self: ParseResult[T], parser: Parser[T]): ParseResult[T] =
    discard