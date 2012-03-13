Import Harpl
Import lexer
'Import reflection 
Import compiler.expressioncompiler 
Import compiler.compilerdatascope 

#Rem
	header:The Harpl compiler module contains the classes that are required to perform and handle compilation of Harpl source code.
#end

#rem
	summary: This is the compiler class. This class allows the compilation of Harpl source code.
#end
Class Compiler
	'summary: This field contains a list of any compiletion errors that may have happened during the compilation process.
	Field compileErrors:=New List<CompileError>

	#rem
	summary: This field contains the lexer used to make the first tokenixing phase of the compilation process. 
	This is a low-lever part of the compiler, you should not access it unless you know really what you're doing.
	#end
	Field lexer:=New Lexer

	#rem
	summary: This function gets a filename as a parameter and performs compilation. 
	If the compilation process is completed properly and without errors, this function returns TRUE, otherwise returns FALSE
	To get the lsit of all compilation errors, you can access the field compileErrors of the class instance.
	#end
	Method CompileFile:Bool (filename:String)
		If FileType(filename) <> 1 Then 'file does not exist
			AddError("File " + filename + " was not found.", "", -1, -1)
			Return False
		EndIf
		generatedAsm = New AssemblerObj
		Local txtStream:String = LoadString(filename)
		
		If txtStream = "" Then AddError("File " + filename + " is empty.", filename, 0, 0)
		
		lexer=New Lexer
		'If the lexing fails, can't make second compiler pass!
		If lexer.Tokenize(txtStream, self, filename ) = False Then Return false
		generatedAsm = New AssemblerObj 
	
		Local EE:= New ExpressionCompiler
		Local scope:= New CompilerDataScope
		Local t:Token = new Token
		t.Kind = eToken.IDENTIFIER 
		t.text = "myvariable"
		scope.AddVariable(Self,t,CompVariable.vINT )
		EE.compiler = self
		EE.CompileExpression(scope)
		if lexer.tokens.IsEmpty = false then
			Print "Next token:" + lexer.tokens.First().text
		Else
			Print "There is no next token."
		endif
		if Self.compileErrors.IsEmpty = False then
			Return False
		Else
			Return True
		endif

	End
	
	Field ErrorsCount:Int = 0
	
	Method AddError(description:String, file:String, posX:Int, posY:Int)
		If compileErrors = null Then compileErrors = New List<CompileError>
		If ErrorsCount>100 Then return
		Local err:CompileError = new CompileError
		err.description = description 
		err.file = file
		err.posX = posX 
		err.posY = posY 
		compileErrors.AddLast(err)
	End
	
	Method AddError(description:String, token:Token)
		AddError(description,token.sourceFile,token.docX,token.docY)
	End
	
	Method ResetCompiler:Void()
		compileErrors = New List < CompileError >
		lexer = New Lexer
		ErrorsCount = 0
	End
	
	Field generatedAsm:AssemblerObj 
	

End

#rem
	summary: This class represents a compilation error
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