import parser

proc char_pair_to_string(t: (char, char)): string = t[0] & t[1]
let p_ab = (pChar('a') ~ pChar('b')).map(char_pair_to_string)

let r = p_ab.parse("abc")

echo r