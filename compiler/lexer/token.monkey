Import etoken
#Rem
	summary: This Class represents a Token for the Harpl compiler
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

	'summary: This property indicates the kind of token. All token kinds are defined in the eToken enumertor-like Class.
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

