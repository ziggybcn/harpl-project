'Summary: This Class contains all available token kinds, in the form of constants.
Class eToken abstract
	'Summary: This represents an empty token. Reserved for future use.
	Const EMPTY:Int = 0
	#rem
	Summary: This represents a regular identifier.
	A regular identifier does start always by a letter from "a" to "z" or from "A" to "Z", and can contains letters, numbers, and the underscore character.
	#end
	Const IDENTIFIER:Int = 1 
	#rem
	Summary: This represents a string literal.
	A string literal is text written between quotes (Harpl accept both double or single quotes).
	Also, a string literal does accept the following scape chars:
	[list]
	[*]~n :This represent a new line character
	[*]~r :This represent a carrier return character
	[*]~t :This represent a tab character
	[*]~q :This represent a single quote character
	[*]~d :This represent a double quote character
	[*]~~ :This represent a middle tile character
	[/list]
	#end
	Const STRINGLITERAL:Int = 2
	
	#rem
	Summary: This represents a numeric literal.
	A numeric literal is a number directly written on the source code, in decimal or hexadecimal form.
	Numbers written in hexadecimal form have to start with the # character.
	Examples of valid numerical literals:
	234, -34.45, #FF000AA
	#End
	Const NUMBER:Int = 4

	'summary:This represents a language operator
	Const OPERATOR:Int = 8

	'summary:This represents an end-sentence or sentence separator
	Const ENDSENTENCE:Int = 16

	'summary:This represents a new line operator
	Const CARRIER:Int = 32
End
