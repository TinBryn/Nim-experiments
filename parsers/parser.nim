import sequtils, sugar, strformat

import parser_input

type
  ParseResult*[T] = object
    rest: Input
    case success: bool:
    of true: item: T
    of false: message: string
  Parser*[T] = object
    p: (Input) -> ParseResult[T]

#This is what actually runs the parser
proc parse*[T](self: Parser[T], input: Input): ParseResult[T] =
  self.p(input)

#Wrapper method to parse strings directly
proc parse*[T](self: Parser[T], input: string): ParseResult[T] =
  self.parse(newInput(input))

#Result constructors
proc newSuccess[T](
  rest: Input, item: T, advance: Natural = 0): ParseResult[T] =
    ParseResult[T](rest: rest.substr(advance), success: true, item: item)

proc newFailure[T](rest: Input, message: string): ParseResult[T] =
  ParseResult[T](rest: rest, success: false, message: message)


# Functor like map methods

#Result map
proc map*[T, U](
  self: ParseResult[T], f: (proc (t: T): U)): ParseResult[U] =
    if self.success:
      newSuccess[U](self.rest, f(self.item))
    else:
      newFailure[U](self.rest, self.message)

#Parser map
proc map*[T, U](self: Parser[T], f: (proc (t: T): U)): Parser[U] =
  result.p = proc (input: Input): ParseResult[U] =
    self.parse(input).map(f)

#
proc flatMap*[T, U](
  self: Parser[T], f: (proc(t: T): Parser[U])): Parser[U] =
  result.p =
    proc (input: Input): ParseResult[U] =
      let r1 = self.parse(input)
      if r1.success:
        let p2 = f(r1.item)
        let r2 = p2.parse(r1.rest)
        if r2.success:
          newSuccess(r2.rest, r2.item)
        else:
          newFailure[U](input, r2.message)
      else:
        newFailure[U](input, r1.message)

# applies both parsers sequentially and combines the results
# into a tuple
proc `~`*[T, U](self: Parser[T], that: Parser[U]): Parser[(T, U)] =
  self
  .flatMap do (t: T) -> Parser[(T, U)]: that
  .map do (u: U) -> (T, U): (t, u)

#parse first then second keeping only the first
proc `!~`*[T, U](self: Parser[T], that: Parser[U]): Parser[T] =
  self
  .flatMap do (t: T) -> Parser[T]: that
  .map do (_: U) -> T: t

#parse first then second keeping only the second
proc `~!`*[T, U](self: Parser[T], that: Parser[U]): Parser[U] =
  self
  .flatMap do (_: T) -> Parser[U]: that
  .map do (u: U) -> U: u

proc makeParser*[T](p: (proc (i: Input): ParseResult[T])): Parser[T] =
  result.p = p

proc parseChar(input: Input, c: char): ParseResult[char] =
  if input[0] == c:
    newSuccess(input, c, 1)
  else:
    newFailure[char](input, '"' & $input & "\" does not start with '" & c & "'")

proc pChar*(c: char): Parser[char] =
  result.p = proc(i: Input): ParseResult[char] = i.parseChar(c)

#
proc `$`*[T](res: ParseResult[T]): string =
  if res.success:
    fmt"Success({res.item}, {res.rest})"
  else:
    fmt"Failure({res.message}, {res.rest})"
