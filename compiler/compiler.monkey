Import Harpl
Import lexer
Import reflection 
Class Compiler
	Field compileErrors:=New List<CompileError>
	Field lexer:=New Lexer
	Method CompileFile:Bool (filename:String)
		if FileType(filename) <> 1 Then 
			AddError("File " + filename + " was not found.","",-1,-1)
			Return False
		EndIf
		
		Local txtStream:String = LoadString(filename)
		
		If txtStream = "" Then AddError("File " + filename + " is empty.", filename, 0, 0)
		
		lexer=New Lexer
		'If the lexing fails, can't make second compiler pass!
		If lexer.Tokenize(txtStream, self, filename ) = False Then Return false
		
		if Self.compileErrors.IsEmpty = False then
			Return False
		Else
			Return True
		endif
	End
	
	Method AddError(description:String, file:String, posX:Int, posY:Int)
		If compileErrors = null Then compileErrors = New List<CompileError>
		Local err:CompileError = new CompileError
		err.description = description 
		err.file = file
		err.posX = posX 
		err.posY = posY 
		compileErrors.AddLast(err)
	End
	
	Method ResetCompiler:Void()
		compileErrors = New List<CompileError>
	End

End

Class CompileError
	Field description:String 
	Field file:String
	Field posX:Int
	Field posY:Int 
End