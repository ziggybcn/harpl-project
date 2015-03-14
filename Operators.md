# Introduction #

This page explains how the basic Harpl operators are designed to work

# Details #

This is the list of currently supported operators:

| **Operator** | **Action** |
|:-------------|:-----------|
|`(` and `)` | Parenthesis |
|`As` | Unary data conversion operator |
|`+` | Numeric addition and unary plus |
|`-` | Numeric substraction and unary minus |
|`%` | Modulus |
|`^` | Power of |
|`&` | Bitwise and |
|`|` | Bitwise or |
|`~` | Bitwise xor and unary complement|
|`shl` | bitwise shift left |
|`shr` | signed bitwise shift |
|`++` | String concatenation |
|`=` | Equals |
|`<` | Less than |
|`>` | Greater than |
|`<=` | Less than or equals |
|`>=` | Greater than or equals |
|`<>` | Not equals |
| And | Logical/conditional "and" |
| Or | Logical/conditional "or"|

In the Harpl language, a single operator is used for each operation and for nothing more. This makes Harpl code easier to follow and much more predictable on what the program is doing.

There is one exception to this rule:

  * Unary operators and binary operators for plus and minus use the same symbol, so it reads as any human written maths expression.

The operators are calculated in the following order:
  * `(` `)` parenthesis
  * As Data conversion operator
  * `+`, `-`, `~` unnary
  * `^` Power of
  * `*`, `/`, `%` Multiplication, division and modulus, in order from left to right
  * `+`, `-` Addition and substraction in order from left to right
  * `+``+` String concatenation in order from left to right
  * shl, shr Bitwise shift operators in order from left to right
  * `&` Bitwise AND operator
  * `|`, `~` Bitwise "or" and "exclusive or" operators in order from left to right
  * `=`, `>`, `<`, `>``=`, `<``=`, `<``>` Comparison operators in order from left to right
  * AND Logical "and" operator
  * OR Logical "or" operator