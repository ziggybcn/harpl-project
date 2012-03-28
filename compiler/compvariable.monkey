#Rem
	summary: This class represents a variable in a CompilerDataScope. 
#End
Class CompVariable 
	'summary: This constant is used to identify a Integer variable
	Const vINT:Int = 1
	'summary: This constant is used to identify a String variable
	Const vSTRING:Int = 2
	'summary: This constant is used to identify a Float variable
	Const vFLOAT:Int = 4
	'summary: This constant is used to identify a Boolean variable
	Const vBOOL:Int = 8
	'summary: This constant is used to identify a Object variable
	Const vOBJ:Int = 16
	'summary: This constant is used to identify a Array variable
	Const vARRAY:Int = 32

	'summary: This flag is set to true when the variable is used into an expression on the compilation process.
	Field isBeingUsed:Bool = false
	
	'summary: This string contains the name lowercase name of this variable on source code
	Field Name:String

	'summary: This field identifies the kind of variable (using one of the already existing consts)
	Field Kind:Int
End
