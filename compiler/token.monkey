
#Rem
	summary: This class represents a Token for the Harpl compiler
#End
Class Token

	'summary: This string contains a string representation of the token's source code document location in disk. The complete path, in an absolute form.
	Field sourceFile:String

	'summary: This Int contains the zero-based character offset (X position) of this token in the document.
	Field docX:Int

	'summary: This Int contains the zero-based line (Y position) of this token in the document.
	Field docY:Int

	'summary: This String contains the token text. This text can be optimized during the lexing process. As instance HEX notation of numbers is converted to decimal notation during the lexing.
	Field text:String
	Private
	Field _kind:Int 
	Public

	'summary: This property indicates the kind of token. All token kinds are defined in the eToken enumertor-like class.
	Method Kind:Int() property 
		Return _kind
	End

	Method Kind:void(value:Int) property
		_kind = value
	End

	Method New(sourceDocument:String, x:Int, y:Int, text:String, kind:Int)
		Self.sourceFile = sourceDocument
		Self.Kind = kind
		Self.docX = x
		Self.docY = y
		Self.text = text
	End
End

'Summary: This class contains all available token kinds, in the form of constants.
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
