# Kind of identifiers #

Current language version accept this kind of identifiers:
  * Regular identifiers
  * Numeric literals
  * String literals
  * Operators
  * Comments
  * Instruction separator


# Details #
**Regular identifiers**

A regular identifier does start always by a letter from "a" to "z" or from "A" to "Z", and can it can contain letters, numbers, and the underscore character.

Some examples of valid regular identifiers:<pre>
Function, Graphics, Var, variable,NewName, This_Is_Me, User34</pre>

Some examples of invalid identifiers:<pre>
_myvariable, 56name, pe%fd, marçañ</pre>

**Numeric Literals**

A numeric literal is a number directly written on the source code, in decimal or hexadecimal form.
Numbers written in hexadecimal form have to start with the # character.

Examples of valid numerical literals:
<pre>234, -34.45, #FF000AA</pre>
Any numerical literal that does not have a decimal fraction is considered an integer value, so if you want to specify that a literal number has to be treatened as a Float value, even if it does not have a fractional part, you'll have to add a dot and a zero to inform the compiler of your intentions:
  * 4   = This is an Integer literal value
  * 4.0 = This is a Float literal value
This Float/Integer different notations can be useful to prevent innecesary data conversions while evealuating expressions. Also notice that an hexadecimal notated number is always considered a literal integer (it is converted to it in the lexing phase, so literally the compiler does not even handle them)

**String literals**

A string literal is text written between quotes, and it is usually part of an expression. Harpl accept string literals to be written using both double or single quotes.

Also, a string literal does accept the following scape chars:

  * ~n :This represent a new line character

  * ~r :This represent a carrier return character

  * ~t :This represent a tab character

  * ~q :This represent a single quote character

  * ~d :This represent a double quote character

  * `~``~` :This represent a middle tilde character

**Comments**

A comment is a piece of text written in the source code that is ignored by the compiler. This seccions of text are very usefull to add remarks to algorithms and programs, so the source code documents are easier to follow, understand and maintain in the long therm.

A Harpl comment is marked with the character **!** and ends with the end of the line. So a multiline comment in Harpl has to be marked with the ! char at every line.

<pre>
Function Main()<br>
!This is a comment inside a function.<br>
EndFunction<br>
</pre>

**Operators**

Harpl understand the following characters as valid operators:

`+`, `-`, `*`, `/`, `%`, `^`, `&`, `|`, `>`, `<`, `=`, `(`, `)`, `[`, `]`, `.`, `,`, and, or, not, >`=`, <`=`, <>

The usage of this characters in the Harpl compiler is yet to be determined. We're still on the lexing phase!!

**Instruction separator**

All Harpl instructions can be ended with the ; character (ala C or Java). However, this is optional at the end of a line.
So this is valid Harpl source code:

<pre>Var MyName as String = "Manel";</pre>
The same as:
<pre>Var MyName as String = "Manel"</pre>
However, if you're writing more than one instruction on a single line of text, then you'll have to separate them using the ; operator
<pre>Var MyName as String = "Hello"; Print MyName</pre>