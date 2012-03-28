#rem
	summary: This Class represents a compilation error
#end
Class CompileError
	#rem
		summary: This field contains a string with information about the compiler error. Typical contents are "Syntax error" and the like.
	#end
	Field description:String 
	#rem
		summary: This field contains the filename in disk of the source of the compilation error
	#end
	Field file:String
	#rem
		summary: This field contains the X location of the error in the given file
		This coordinate is the zero based char offset of the error source in the document. If the error has been reported to happen on the fourth character of the fiveteenth line, this field will contain a 4 (first character of the line is 0, second is 1, third is 2, etc.)
	#end
	Field posX:Int
	#rem
		summary: This field contains the Y location of the error in the given file
		This coordinate is the zero based line number of the error source in the document. If the error has been reported to happen on the fourth character of the fiveteenth line, this field will contain a 14 (first line of source code is 0, second is 1, third is 2, etc.)
	#end
	Field posY:Int 
End
