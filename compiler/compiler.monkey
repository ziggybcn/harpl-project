Import Harpl
Import lexer
Import expressioncompiler
Import datascopes.compilerscopestack
Import compileerror
Import harplkeywords
Import expkinds

#Rem
	header:The Harpl compiler module contains the Classes that are required to perform and handle compilation of Harpl source code.
#end

#rem
	summary: This is the compiler Class. This Class allows the compilation of Harpl source code.
#end
Class Compiler
	'summary: This field contains a list of any compiletion errors that may have happened during the compilation process.
	Field compileErrors:=New List<CompileError>

	#rem
	summary: This field contains the lexer used to make the first tokenixing phase of the compilation process. 
	This is a low-lever part of the compiler, you should not access it unless you know really what you're doing.
	#end
	Field lexer:=New Lexer

	Field originalFile:String
	
	
	Field compilerScopeStack:CompilerScopeStack 
	
	#rem
	summary: This function gets a filename as a parameter and performs compilation. 
	If the compilation process is completed properly and without errors, this function returns TRUE, otherwise returns FALSE
	To get the lsit of all compilation errors, you can access the field compileErrors of the Class instance.
	#end
	Method CompileFile:Bool (filename:String)
		If FileType(filename) <> 1 Then 'file does not exist
			AddError("File " + filename + " was not found.", "", -1, -1)
			Return False
		EndIf
		generatedAsm = New AssemblerObj
		compilerScopeStack = New CompilerScopeStack(Self) 
		
		Local txtStream:String = LoadString(filename)
		
		If txtStream = "" Then AddError("File " + filename + " is empty.", filename, 0, 0)
		
		lexer=New Lexer
		'If the lexing fails, can't make second compiler pass!
		If lexer.Tokenize(txtStream, self, filename ) = False Then Return false
		
		generatedAsm = New AssemblerObj 
	
		Local EE := New ExpressionCompiler
		
		if lexer.tokens.IsEmpty() Then
			Print "Warining: source code did not contain any valid Harpl code, or source code was invalid."
			Return true
		EndIf
		originalFile = filename
		Print "Compiling..."
		'We add the global data scope:
		compilerScopeStack.AddDataScope()
		
		'Add True and False identifiers to the compiler global scope:
		Local tmpToken:Token = new Token
		tmpToken.text = HarplKeywords._True 
		tmpToken.Kind = eToken.IDENTIFIER 
		compilerScopeStack.AddVariable(Self,tmpToken , CompVariable.vBOOL)
		generatedAsm.AddInstruction(AssemblerObj.SET_TRUE)
		WriteIdentParameter(tmpToken)

		tmpToken = New Token
		tmpToken.text = HarplKeywords._False
		tmpToken.Kind = eToken.IDENTIFIER 
		compilerScopeStack.AddVariable(Self,tmpToken, CompVariable.vBOOL)		

		
		Local tokenNode:list.Node<Token> = lexer.tokens.FirstNode()
		
		Local done:Bool = false, iterations:Int = 0
		While Not done 'And tokenNode.Value <> null
		
			if iterations > 200000 Then
				Print "Ended due possible infitite loop."
				done = True
				Continue
			EndIf
			iterations+=1
			
			Local token:Token = tokenNode.Value()
			Select token.Kind 
				Case eToken.CARRIER, eToken.EMPTY, eToken.ENDSENTENCE 
					lexer.tokens.RemoveFirst()
					if lexer.tokens.IsEmpty = true Then
						tokenNode = null
						done = true
					else
						tokenNode = lexer.tokens.FirstNode()
					EndIf

				Case eToken.IDENTIFIER 
					Select token.text
						case HarplKeywords.Define 	'Add a local variable
							CompileVar()
							if lexer.tokens.IsEmpty = false
								tokenNode = lexer.tokens.FirstNode()
							Else
								tokenNode = null
								done = True 
								Continue
							endif
						Case HarplKeywords.Output
							CompileOutput()
							if lexer.tokens.IsEmpty = false
								tokenNode = lexer.tokens.FirstNode()
							Else
								tokenNode = null
								done = True 
								Continue
							endif
						Default 

							'check for methods or selft defined functinos, etc and if it fails:
							AddError("Unknown identifier " + token.text, token)
							ConsumeSentence()
							if lexer.tokens.IsEmpty = False then
								tokenNode = lexer.tokens.FirstNode()
							Else
								done = true
							endif
					End select
					
				Case eToken.NUMBER, eToken.OPERATOR, eToken.STRINGLITERAL 
					Self.AddError("Unexpected token: " + token.text, token)
					done = true
			End Select
		Wend

		'We close the global data scope:
		compilerScopeStack.CloseDataScope()
		
		For local s:String = EachIn Self.generatedAsm.code
			WriteInConsole( s)
		Next
		
		if lexer.tokens.IsEmpty = false then
			Print "Compilation process was not completed properly. There are pending tokens to be processed."
			Return false
		else
			if Self.compileErrors.IsEmpty = False then
				Print "There were " + self.compileErrors.Count() + " errors during compilation."
				Return False
			Else
				Print "Compilation without errors"
				Return True
			endif
		endif
	End
	
	Method CompileOutput:Bool()
		local outputToken:Token = Self.lexer.tokens.RemoveFirst()
		
		If outputToken.text <> HarplKeywords.Output Then
			Error "Output compilation requested without Output identifier. Found: " + outputToken.text
		EndIf
		Local EC:ExpressionCompiler = new ExpressionCompiler
		EC.compiler = self
		local resultToken:Token = EC.CompileExpression(compilerScopeStack)
		if resultToken <> null Then
			generatedAsm.AddInstruction(AssemblerObj.IO_OUTPUT)			
			WriteIdentParameter(resultToken)
		Else
			'Error already added on the expression compiler. No need to put it twice!
			'AddError("Error processing expression.", nextToken)
			ConsumeSentence
		EndIf
		CheckSentenceEnd()
	End
	
	Method CheckSentenceEnd()
		if Self.lexer.tokens.IsEmpty() = False
			if Self.lexer.tokens.First().Kind <> eToken.CARRIER And Self.lexer.tokens.First().Kind <> eToken.ENDSENTENCE Then
				AddError("Expecting end of instruction.",Self.lexer.tokens.First())
			EndIf
		EndIf 
		
	End
	Method CompileVar:Bool()
		'We eat the VAR token:
		local varToken:Token = Self.lexer.tokens.RemoveFirst()
		if varToken.text <> HarplKeywords.Define Then
			Error "Var compilation requested without Var identifier. Found: " + varToken.text
		EndIf
		Local done:Bool = false, firstRound:bool = true
		While (done=false and lexer.tokens.IsEmpty = false)
			'We get the variable name:
			if Self.lexer.tokens.IsEmpty Then 
				AddError("Expecting variable name",varToken)
				ConsumeSentence
				Continue
			endif
			Local varname:Token = self.lexer.tokens.RemoveFirst()
			if Not firstRound then
				While varname <>null And varname.Kind = eToken.CARRIER 'We allow carrier after a coma
					varname = self.lexer.tokens.RemoveFirst()
				Wend
			else
				firstRound = false
			endif
			if IsValidVarName(varname) = False Then 
				AddError("Define could not be processed. ~q" + varname.text + "~q is not a valid variable name.", varname)
				ConsumeSentence
				return False		
			EndIf
			'We get the AS clause:
			if Self.lexer.tokens.IsEmpty Then 
				AddError("Expecting As clause when declaring " + varname.text, varname)
				ConsumeSentence
				Continue 
			endif
			Local as:Token = self.lexer.tokens.RemoveFirst()
			if (as.Kind<>eToken.OPERATOR or as.text <> HarplKeywords.As) Then
				AddError("As clause was expected. Syntax error delcaring " + varname.text + "[" + varname.docX +", " + varname.docY,as)
				ConsumeSentence()
				Return false
			EndIf
			Local dataType:Token = self.lexer.tokens.RemoveFirst()
'			if not(as.Kind=eToken.IDENTIFIER)  Then
'				AddError("Data type expected. Syntax error",dataType)
'				ConsumeSentence()
'				Return False
'			EndIf

			Select dataType.text

				Case HarplKeywords._Float 
					compilerScopeStack.AddVariable(Self, varname, CompVariable.vFLOAT)
					
				Case HarplKeywords._String 
					compilerScopeStack.AddVariable(Self, varname, CompVariable.vSTRING )
				
				Case HarplKeywords.Boolean 
					compilerScopeStack.AddVariable(Self, varname, CompVariable.vBOOL )
				
				Case HarplKeywords.Integer 
					compilerScopeStack.AddVariable(Self, varname, CompVariable.vINT )
				Default
					Print "error data type for variable is not known."
				
			End Select
			if Self.lexer.tokens.IsEmpty Then Continue
			Local nextToken:Token = self.lexer.tokens.RemoveFirst()
			'If the Var instruction ends:
			if nextToken.Kind <> eToken.OPERATOR Then
				if nextToken.Kind = eToken.CARRIER or nextToken.Kind = eToken.ENDSENTENCE Then
					'Print "End sentence!"
					SetDefaultValueVar(varname)
					done = true
					Continue
				endif
			EndIf
			'If the Var instruction does not end:
			Select nextToken.text
				Case "="
					Local EC:ExpressionCompiler = new ExpressionCompiler
					EC.compiler = self
					local resultToken:Token = EC.CompileExpression(compilerScopeStack)
					if resultToken <> null Then
						'Print "Var " + varname.text + " has to be set to: " + resultToken.text 
						generatedAsm.AddInstruction(AssemblerObj.SET_VAR)
						WriteIdentParameter(varname)
						WriteIdentParameter(resultToken)
					Else
						AddError("Error processing expression.", nextToken)
						ConsumeSentence
						done = True
						Continue
					EndIf
					Local continueToken:Token 
					if Self.lexer.tokens.IsEmpty = False then
						continueToken = self.lexer.tokens.RemoveFirst()
					Else
						done =True
						Continue
					endif
					if continueToken.Kind = eToken.CARRIER or continueToken.Kind = eToken.ENDSENTENCE Then 
						done = true
						Continue
					endif
					
					if continueToken.Kind <> eToken.OPERATOR or continueToken.text <> "," Then
						AddError("Expected end of variable declaration",continueToken)
						ConsumeSentence 
						done = True
						Continue 
					endif
				Case ","
					SetDefaultValueVar(varname)
					Continue
				
				Default
					AddError("Unexpected operator: " + nextToken.text,nextToken)
					ConsumeSentence 
					done = True
					Continue 
			End Select
		Wend
	End

	Method SetDefaultValueVar(varname:Token)
		generatedAsm.AddInstruction(AssemblerObj.SET_DEFVAR)
		WriteIdentParameter(varname)
	End
	
	Method WriteIdentParameter(token:Token)
		local prefix1:String = TellPrefix(token, self)
		generatedAsm.AddParameter(prefix1)
		generatedAsm.AddParameter(token.text)   '.code.AddLast(Prev.text)
		Local nestingLevel:IntByRef = new IntByRef
		if prefix1 = expKinds.BOOLVAR or prefix1 = expKinds.FLOATVAR or prefix1 = expKinds.INTVAR or prefix1 = expKinds.STRINGVAR Then
			compilerScopeStack.FindVariable(token.text, nestingLevel)
			generatedAsm.AddParameter(nestingLevel.value)
		EndIf
	End
	
	Method ConsumeSentence()
		Local done:Bool = false, prev:Token
		While Not done And lexer.tokens.IsEmpty = false
			Local t:Token = lexer.tokens.RemoveFirst()
			if t.Kind = eToken.ENDSENTENCE Then
				done = true
			ElseIf t.Kind = eToken.CARRIER Then
				IF prev = null Then 
					done = True
				ElseIf prev.Kind <> eToken.OPERATOR Then
					done = True
				EndIf
			EndIf
			prev = t
		Wend		
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
	
	Method IsValidVarName:Bool(varname:Token)
		if varname.Kind <> eToken.IDENTIFIER Then Return False
		Select varname.text
			Case HarplKeywords._Float, HarplKeywords._String, HarplKeywords.As, HarplKeywords.Boolean, 
			HarplKeywords._False, HarplKeywords._True,	HarplKeywords.Integer,HarplKeywords.Output,
			HarplKeywords.Define
				Return False
			Default
				Return true
		End
	End
	
	Field generatedAsm:AssemblerObj 
	
End

