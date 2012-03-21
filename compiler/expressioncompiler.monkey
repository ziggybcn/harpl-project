Import Harpl
Import reflection
Class ExpressionCompiler

	Field compiler:Compiler

	Field intCounter:Int = 0
	Field stringCounter:Int = 0
	Field floatCounter:Int = 0
	Field booleanCounter:Int = 0
		
	Method CompileExpression:Token(scope:CompilerScopeStack )
	
		intCounter = 0
		stringCounter = 0
		floatCounter = 0
		booleanCounter = 0
	
		If compiler = Null Then Error "No compiler associated to the ExpressionCompiler!"

		'This function gets all tokens from the stack that conform the expression: 
				
		Local expression:= New List < Token >

		'We get the first token: 
		Local currentToken:Token = compiler.lexer.tokens.First() ;
		compiler.lexer.tokens.FirstNode.Remove()
		Local prevToken:Token = null
		Local done:Bool = false
		Local braces:Int = 0, lastBrace:String = ""
		While Not done
		
			if IsOpenBracket(currentToken) Then
				braces += 1
				lastBrace = currentToken.text
			ElseIf isCloseBracket(currentToken)
				braces -= 1
				if braces < 0 Then
					compiler.AddError("Malformed expression. Unexpected: " + currentToken.text, currentToken.sourceFile, currentToken.docX, currentToken.docY)
				EndIf
			Endif
			
			if braces = 0 then	'We ignore subexpressions (we'll work them out later!) 
				'We check next Token:
				Select currentToken.Kind
					'If it is an identifier, it's the end of the expression when it is precedded by something different than an operator:
					Case eToken.IDENTIFIER, eToken.NUMBER, eToken.STRINGLITERAL
						if prevToken <> null Then
							if prevToken.Kind <> eToken.OPERATOR Then
								compiler.lexer.tokens.AddFirst(currentToken)
								Exit
							Endif
						EndIf
					Case eToken.OPERATOR
						'We can't end with an operator, unless it is a coma: 
						if currentToken.text = "," Then
							compiler.lexer.tokens.AddFirst(currentToken)
							Exit														
						EndIf
					Case eToken.CARRIER
						if prevToken <> null Then
							if IsItem(prevToken) Then
								compiler.lexer.tokens.AddFirst(currentToken)
								Exit
							EndIf
						EndIf
					Case eToken.ENDSENTENCE 
						compiler.lexer.tokens.AddFirst(currentToken)
						Exit											
				End Select
			Else
				'We check for missing ")" or "]" to avoid getting the whole file as an expression when that happens:
				if currentToken.Kind = eToken.CARRIER
					if prevToken <> null Then
						if IsItem(prevToken) Then
							if lastBrace = "(" Then 
								compiler.AddError("Expecting a closing brace: )", prevToken.sourceFile, prevToken.docX + prevToken.text.Length, prevToken.docY)
							Else
								compiler.AddError("Expecting a closing brace: ]", prevToken.sourceFile, prevToken.docX + prevToken.text.Length, prevToken.docY)
							endif
							compiler.lexer.tokens.AddFirst(currentToken)
							Exit
						EndIf
					EndIf
				EndIf
			EndIf
			
			If currentToken.Kind <> eToken.CARRIER Then
				expression.AddLast(currentToken)
				prevToken = currentToken
			endif
			
			if compiler.lexer.tokens.IsEmpty = False Then
				currentToken = compiler.lexer.tokens.First() ;
				compiler.lexer.tokens.FirstNode.Remove()
			Else
				done = true
			endif
		Wend
		
'		Print "Expression is:"
'		For local t:Token = EachIn expression
'			Print("." + t.text + ".")
'		Next
'		Print("--Done--")

		local result:Bool = WriteAsm(expression, scope)

		'We addapt the temporal arrays for internal calculations to the whole program needs, not more, not less. We can determine this at compilation time:
		if compiler.generatedAsm.requiredBoolSize < booleanCounter Then compiler.generatedAsm.requiredBoolSize = booleanCounter
		if compiler.generatedAsm.requiredFloatSize < floatCounter Then compiler.generatedAsm.requiredFloatSize = floatCounter
		if compiler.generatedAsm.requiredStringSize < stringCounter Then compiler.generatedAsm.requiredStringSize = stringCounter
		if compiler.generatedAsm.requiredIntSize < intCounter Then compiler.generatedAsm.requiredIntSize = intCounter
		if expression.IsEmpty Then 
			Return null 
		Else
			if result = True Then 
				if expression.Count=1 Then 	Return expression.First() Else Return null
			Else 
				Return null	
			endif
		endif
	End
	
	Private
	
	Field result:Token
		
	
	Method WriteAsm:Bool(expression:List < Token >, compilerScopeStack:CompilerScopeStack)
		
	
		Local firstToken:Token
		if expression.FirstNode() <> null Then firstToken = expression.FirstNode().Value()

		'Pending Braces!!
		
		
		'Unnary operators
	
		
		'Binary operators:
		if ProcessBinaryOperator(
			["^", AssemblerObj.POW],
			expression, compilerScopeStack) = False Then Return false

		if ProcessBinaryOperator(
			["*", AssemblerObj.MUL,
			 "/", AssemblerObj.DIV,
			 "%", AssemblerObj.MODULUS], expression, compilerScopeStack) = False Then Return false
			
		if ProcessBinaryOperator(
			["+", AssemblerObj.SUM,
			 "-", AssemblerObj.SUB], expression, compilerScopeStack) = False Then Return false
		if ProcessBinaryOperator(["&", AssemblerObj.BIT_AND], expression, compilerScopeStack) = False Then Return false
		if ProcessBinaryOperator(["|", AssemblerObj.BIT_OR], expression, compilerScopeStack) = False Then Return false
				
'		Print "And then it is:"
'		For local t:Token = EachIn expression
'			Print("." + t.text + ".")
'		Next
'		Print("--Done--")
'		
'		Print("")
'		Print("ASM:")
'		For Local s:String = EachIn compiler.generatedAsm.code
'			Print s
'		Next
'		Print ("---END---")
		'return WriteAsm(expression, scope )
		if expression.IsEmpty = True Then
			if firstToken <> null then
				compiler.AddError("Error in expression", firstToken.sourceFile, firstToken.docX, firstToken.docY)
				Return false
			Else
				compiler.AddError("Error in expression in unknown location. That's very weird.", "", 0, 0)
			endif
			Return false
		ElseIf expression.FirstNode.NextNode <> null Then
			compiler.AddError("Error in expression. Expression could not be assembled.", firstToken.sourceFile, firstToken.docX, firstToken.docY)
		Else
			Return true
		EndIf

		
	End
	
	Method ProcessBinaryOperator?(opItems:String[], expression:List<Token>, compilerScopeStack:CompilerScopeStack)
		Local node:list.Node < Token >
		node = expression.FirstNode()
		While node <> null
			Local curT:Token = node.Value()
			if curT.Kind <> eToken.OPERATOR Then
				node = node.NextNode()
				Continue
			EndIf
			
			'WE HAVE AN OPERATION
			For Local i:Int = 0 until opItems.Length step 2
				local op:String = opItems[i]
				Local pref:String = opItems[i + 1]
				if curT.Kind = eToken.OPERATOR And curT.text = op Then
					'IF IT'S MALFORMED:	 
					if node.PrevNode = null or node.NextNode = null Then
						compiler.AddError("Malformed expression", curT.sourceFile, curT.docX, curT.docY)
						Return false					
					EndIf
					
					Local Prev:Token = node.PrevNode.Value
					Local Post:Token = node.NextNode.Value
					
					if IsItem(Prev) = False or IsItem(Post) = False Then
						compiler.AddError("Malformed expression. Expecting identifier.", curT.sourceFile, curT.docX, curT.docY)
						Return false										
					EndIf
	
					Local prefix1:String = TellPrefix(Prev, compilerScopeStack, compiler)
					Local prefix2:String = TellPrefix(Post, compilerScopeStack, compiler)
					Local operateNum:Bool = false
					if prefix1 = expKinds.INTPREFIX or prefix1 = expKinds.FLOATPREFIX then
						If prefix2 = expKinds.INTPREFIX Then
							operateNum = true
						ElseIf prefix2 = expKinds.FLOATPREFIX
							operateNum = true
						EndIf
					EndIf
					if operateNum = False then
						compiler.generatedAsm.AddInstruction(pref) '.code.AddLast(pref)
'						compiler.generatedAsm.AddParameter(prefix1)  '.code.AddLast(prefix1)  ' + prefix2)
'						compiler.generatedAsm.AddParameter(Prev.text)   '.code.AddLast(Prev.text)
'						Local nestingLevel:ByRefInt = new ByRefInt
'						if prefix1 = expKinds.BOOLVAR or prefix1 = expKinds.FLOATVAR or prefix1 = expKinds.INTVAR or prefix1 = expKinds.STRINGVAR Then
'							'We get nesting level for current var:
'							compiler.compilerScopeStack.FindVariable(Prev.text, nestingLevel)
'							compiler.generatedAsm.AddParameter(nestingLevel.value)
'						EndIf
						compiler.WriteIdentParameter(Prev)
'						compiler.generatedAsm.AddParameter(prefix2)  '  .code.AddLast(prefix2)  ' + prefix2)						
'						compiler.generatedAsm.AddParameter(Post.text)  '.code.AddLast(Post.text)
'						if prefix2 = expKinds.BOOLVAR or prefix2 = expKinds.FLOATVAR or prefix2 = expKinds.INTVAR or prefix2 = expKinds.STRINGVAR Then
'							compiler.compilerScopeStack.FindVariable(Post.text, nestingLevel)
'							compiler.generatedAsm.AddParameter(nestingLevel.value)
'						EndIf
						compiler.WriteIdentParameter(Post)
		
						Local Store:String
						
						Select op
						
							'Returning Int or String:
							Case "&"
							if prefix1 = expKinds.STRINGLITERAL or prefix1 = expKinds.STRINGVAR or
								prefix2 = expKinds.STRINGLITERAL or prefix2 = expKinds.STRINGVAR or
								prefix1 = expKinds.TMPSTRING or prefix2 = expKinds.TMPSTRING								

								'WE STORE IN A TMP STRING
								Store = eTmpTokens.TMPSTRING + stringCounter
								Self.stringCounter +=1

							Else
								'WE STORE IN AN INTEGER
								Store = eTmpTokens.TMPINT + intCounter 
								Self.intCounter +=1
								
							endif
							'Returning Int:
							Case "|", "%"
								Store = eTmpTokens.TMPINT + intCounter 
								Self.intCounter +=1
							
							'Returning Float:
							Case "+","-","*","/", "^"
								Store = eTmpTokens.TMPFLOAT + floatCounter
								Self.floatCounter +=1
							
							'Returning Bool:
							Case "=",">=", "<=", ">", "<"
								Store = eTmpTokens.TMPBOOL  + booleanCounter
								Self.booleanCounter +=1
							Default
								'Error("Operator unknown:" + op)
								compiler.AddError("Uknown operator",curT)
							End Select
							If Store<> "" then
							
								'curT.Kind = eToken.IDENTIFIER '--> There's no need to tell the result kind, as it is known by the operatos kind.
								'curT.text = Store
								'Local ResultPrefix:String = TellPrefix( curT,scope,compiler)
								'compiler.generatedAsm.AddParameter(ResultPrefix) 
								compiler.generatedAsm.AddParameter(Store)  
							Else
								compiler.generatedAsm.AddParameter("?") 
							endif
							node.PrevNode.Remove()
							node.NextNode.Remove()
							curT.Kind = eToken.IDENTIFIER 
							curT.text = Store
					Else
						Local result:String 
						Select curT.text
							Case "+"; result = float(Prev.text) + float(Post.text)
							Case "-"; result = float(Prev.text) - float(Post.text)
							Case "*"; result = float(Prev.text) * float(Post.text)
							Case "/"; result = float(Prev.text) / float(Post.text)
							Case "^"; result = Pow(float(Prev.text) ,float(Post.text))
							Case "%"; result = float(Prev.text) mod float(Post.text)
							Case "&"; result = Int(Prev.text) & Int(Post.text)
							Case "|"; result = Int(Prev.text) | Int(Post.text)
						End
						if result="" Then
							compiler.AddError("Error evaluating expression",curT.sourceFile, curT.docX, curT.docY)
						Else
							curT.text = result
							curT.Kind = eToken.NUMBER 
							node.PrevNode.Remove
							node.NextNode.Remove
						EndIf
					endif
					Exit	'We do not re-parse the same token, we could, as it is not an operator any more but not nice.
				EndIf
			Next
			'if node.NextNode<>null then	node = node.NextNode
			node = node.NextNode
		Wend
		Return true
	End
	
	Method IsOpenBracket:Bool(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = "(" or token.text = "[" Then Return True
		Return false
	End
	
	Method isCloseBracket:Bool(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = ")" or token.text = "]" Then Return True
		Return false
	End
	
	Method IsItem:Bool(token:Token)
		Select token.Kind
			Case eToken.NUMBER, eToken.STRINGLITERAL, eToken.IDENTIFIER
				Return True
			Default
				Return False 
		End 
	End
	
End

Function TellPrefix:String(t:Token, compilerScopeStack:CompilerScopeStack, compiler:Compiler)
	Select t.Kind
		Case eToken.STRINGLITERAL
			Return expKinds.STRINGLITERAL 	'STRINGLITERAL
			
		Case eToken.IDENTIFIER 
			if t.text.StartsWith(eTmpTokens.TMPINT) Then  '"!N" etc.
				Return expKinds.TMPINTEGER 	'TEMP INTEGER
				
			elseif t.text.StartsWith(eTmpTokens.TMPFLOAT) Then
				Return expKinds.TMPFLOAT 'TEMP FLOAT
				
			elseif t.text.StartsWith(eTmpTokens.TMPSTRING) Then
				Return expKinds.TMPSTRING  'TEMP STRING
				
			elseif t.text.StartsWith(eTmpTokens.TMPBOOL) Then
				Return expKinds.TMPBOOL 'TEMP BOOLEAN
			Else
				'TODO: ITERATE THROUG PARENT SCOPES, AND GET POSSIBLE HIDING WARNINGS. ALSO MARK USED/UNUSED VAR.
				if compilerScopeStack.VariableExists(t.text) = False Then
					compiler.AddError("Unknown identifier: " + t.text,t.sourceFile, t.docX, t.docY )
					'For local v:CompVariable = EachIn scope.variables.Values
					'	Print "Available variable:" + v.Name
					'Next
					Return expKinds.ERRORUNKNOWNVAR 
				Else
					Local vari:CompVariable = compilerScopeStack.FindVariable (t.text, null)
					vari.isBeingUsed = true
					Select vari.Kind
						Case CompVariable.vINT 
							Return expKinds.INTVAR 
						Case CompVariable.vBOOL
							Return expKinds.BOOLVAR 
						Case CompVariable.vFLOAT 
							Return expKinds.FLOATVAR 
						Case CompVariable.vSTRING  
							Return expKinds.STRINGVAR 
					End
				EndIf
			EndIf
		Case eToken.NUMBER 
			If t.text.Contains(".") = False Then
				Return expKinds.INTPREFIX 	'INTEGER NUMBER	
			Else
				Return expKinds.FLOATPREFIX 'FLOAT NUMBER
			EndIf
	End
End


Class expKinds abstract
	Const INTPREFIX:String = "IN"	'Integer literak
	Const FLOATPREFIX:String = "FN"	'Float literal
	Const INTVAR:String = "IV"	'Integer variable
	Const BOOLVAR:String = "BV"	'Bool variable
	Const FLOATVAR:String = "FV"	'Float variable
	Const STRINGVAR:String = "SV"	'String variable
	Const ERRORUNKNOWNVAR:String = "ER"	'ERROR
	Const STRINGLITERAL:String = "ST"	'String literal
	Const TMPINTEGER:String = "TN"	'TEMP integer
	Const TMPFLOAT:String = "TF"	'TMP float
	Const TMPSTRING:String = "TS"	'TMP String
	Const TMPBOOL:String = "TB"		'TMPBool
End

Class eTmpTokens
	Const TMPSTRING:String = "!S"
	Const TMPINT:String = "!I"
	Const TMPFLOAT:String = "!F"
	Const TMPBOOL:String = "!B"
End







