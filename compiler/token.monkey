Class Token
	Field sourceFile:String
	Field docX:Int
	Field docY:Int
	Field text:String
	Private
	Field _kind:Int 
	Public
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

Class eToken abstract
	Const EMPTY:Int = 0
	Const IDENTIFIER:Int = 1
	Const STRINGLITERAL:Int = 2
	Const NUMBER:Int = 4
	Const OPERATOR:Int = 8
	Const ENDSENTENCE:Int = 16
	Const CARRIER:Int = 32
End
