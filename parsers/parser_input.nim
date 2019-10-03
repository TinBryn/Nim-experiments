type Input* = object
  data: string
  pos: Natural

proc newInput*(str: string): Input =
  Input(data: str, pos: 0)

proc substr*(self: Input, advance: Natural): Input =
  Input(data: self.data, pos: self.pos + advance)

proc `[]`*(self: Input, index: Natural): char =
  self.data[self.pos + index]

proc `$`*(self: Input): string =
  self.data[self.pos .. ^1]