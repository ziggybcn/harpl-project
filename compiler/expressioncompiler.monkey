Import Harpl
Import lexer.etmptokens
 
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
	
	Method CompileUnary(expression:List < Token >, compiler:Compiler, Item:list.Node<Token>)
		
		'"Item" es el TOKEN sobre el que se aplicará la operación unaria.
		
		if Item.PrevNode = null Then Return 	'No unnary operator!!!

		'"Operator" es el operador que precede a Item:
		Local operator:Token = Item.PrevNode.Value()

		If operator.Kind <> eToken.OPERATOR Then Return 'No valid operator
		If operator.text = "+" Then
			'This unnary operator is neutral, no need to compile anything
			Item.PrevNode.Remove
			
		ElseIf operator.text = "-"
			if Item.Value.Kind = eToken.NUMBER Then
				Item.PrevNode.Remove()
				if Item.Value.text.Contains(".") = False Then
					Local newval:Int = -int(Item.Value.text)
					Item.Value.text = newval
				Else
					Local newval:Float = -Float(Item.Value.text)
					Item.Value.text = newval
				EndIf
			else
				compiler.generatedAsm.AddInstruction(AssemblerObj.UNNARY_SUB)
				compiler.WriteIdentParameter(Item.Value)
				Item.PrevNode.Remove
				Local store:String = eTmpTokens.TMPINT + intCounter
				intCounter+=1
				Item.Value.text = store
				Item.Value.Kind = eToken.IDENTIFIER 
				'compiler.generatedAsm.AddParameter(store)
				Local tmpToken:Token = new Token
				tmpToken.Kind = eToken.IDENTIFIER 
				tmpToken.text  = store
				compiler.WriteIdentParameter(tmpToken)

			EndIf
		
		ElseIf operator.text = "~"
			if Item.Value.Kind = eToken.NUMBER Then
				Item.PrevNode.Remove()
				Local newval:Int = -int(Item.Value.text)
				Item.Value.text = newval
			else
				compiler.generatedAsm.AddInstruction(AssemblerObj.UNNARY_COMPLEMENT )
				compiler.WriteIdentParameter(Item.Value)
				Item.PrevNode.Remove
				Local store:String = eTmpTokens.TMPINT + intCounter
				intCounter+=1
				Item.Value.text = store
				Item.Value.Kind = eToken.IDENTIFIER 
				Local tmpToken:Token = new Token
				tmpToken.Kind = eToken.IDENTIFIER 
				tmpToken.text  = store
				compiler.WriteIdentParameter(tmpToken)
				
			endif
		EndIf
	End method
	
	
	Method CompileUnaries(expression:List < Token >, compiler:Compiler)
		'We iterate the expression looking for potential unaries
		Local done:Bool = False
		Local tokenNode:list.Node<Token> = expression.FirstNode()
		
		'Possible optimization on chains of ----. this is a nice TODO.
		
		While Not done
			Local readNext:Bool = True
			Select tokenNode.Value.Kind
				Case eToken.IDENTIFIER, eToken.NUMBER 
					Local Prev:list.Node<Token> = tokenNode.PrevNode 
					'There is a Prev node that is an operator that can be a unnary operator:
					if Prev <> Null And  Prev.Value.Kind = eToken.OPERATOR And (Prev.Value.text = "-" or Prev.Value.text = "~" or Prev.Value.text = "+")
						'we check if it is a "initial" unary operation:
						Local GrandPa:list.Node<Token> = Prev.PrevNode()
						'We have a starting unary operation:
						if GrandPa = Null or GrandPa.Value.Kind = eToken.OPERATOR Then
							CompileUnary(expression,compiler,tokenNode)
							readNext = false	'We want to process chained unary operators.
						EndIf
					EndIf
				Default
			End
			if readNext then tokenNode = tokenNode.NextNode( )
			if tokenNode = null Then done = true
		Wend
	End
	
	Method WriteAsm:Bool(expression:List < Token >, compilerScopeStack:CompilerScopeStack)
		
	
		Local firstToken:Token
		if expression.FirstNode() <> null Then firstToken = expression.FirstNode().Value()

		'TODO: Pending Braces!!
		
		'Unnary operators
		CompileUnaries(expression,compilerScopeStack.compiler)
		
		'Binary operators:
		if ProcessBinaryOperator(
			["^", AssemblerObj.POW],
			expression) = False Then Return false

		if ProcessBinaryOperator(
			["*", AssemblerObj.MUL,
			 "/", AssemblerObj.DIV,
			 "%", AssemblerObj.MODULUS], expression) = False Then Return false
			
		if ProcessBinaryOperator(
			["+", AssemblerObj.SUM,
			 "-", AssemblerObj.SUB], expression) = False Then Return false
		
		if ProcessBinaryOperator([
		"shl",AssemblerObj.BC_BIT_SHL, "shr",AssemblerObj.BC_BIT_SHR ], expression) = False Then Return false
		
			  
		if ProcessBinaryOperator(["&", AssemblerObj.BIT_AND], expression) = False Then Return false
		if ProcessBinaryOperator(["~", AssemblerObj.BC_BIT_XOR], expression) = False Then Return false
		
		if ProcessBinaryOperator(["|", AssemblerObj.BIT_OR], expression) = False Then Return false
				
		if ProcessBinaryOperator(
			["++", AssemblerObj.CONCAT],
			  expression) = False Then Return false
			  
		'COMPARISON OPERATORS PENDING:
		if ProcessBinaryOperator([
			"<", AssemblerObj.MINOR,
			">", AssemblerObj.MAJOR,
			"=", AssemblerObj.EQUALS,
			"<=", AssemblerObj.MINOR_EQUAL,
			">=", AssemblerObj.MAJOR_EQUAL],
			 expression) = False Then Return false		

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
	
	Method ProcessBinaryOperator:Bool(opItems:String[], expression:List < Token >)', compilerScopeStack:CompilerScopeStack)
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
	
					Local prefix1:String = TellPrefix(Prev, compiler)
					Local prefix2:String = TellPrefix(Post, compiler)
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
						compiler.WriteIdentParameter(Prev)
						compiler.WriteIdentParameter(Post)
		
						Local Store:String
						
						Select op
						
							'Returning Int or String:
							Case "|", "%", "&", "~", "shr", "shl"
								Store = eTmpTokens.TMPINT + intCounter 
								Self.intCounter +=1
							
							'Returning Float:
							Case "+","-","*","/", "^"
								if IsIntPrefix(prefix1) And IsIntPrefix(prefix2) then
									Store = eTmpTokens.TMPINT + intCounter 
									Self.intCounter +=1
								else
									Store = eTmpTokens.TMPFLOAT + floatCounter
									Self.floatCounter +=1
								EndIf
							
							'Returning Bool:
							Case "=",">=", "<=", ">", "<"
								Store = eTmpTokens.TMPBOOL  + booleanCounter
								Self.booleanCounter += 1
							Case "++"
								Store = eTmpTokens.TMPSTRING + stringCounter
								Self.stringCounter += 1
							Default
								'Error("Operator unknown:" + op)
								compiler.AddError("Uknown operator",curT)
							End Select
							If Store<> "" then
							
								'curT.Kind = eToken.IDENTIFIER '--> There's no need to tell the result kind, as it is known by the operatos kind.
								'curT.text = Store
								'Local ResultPrefix:String = TellPrefix( curT,scope,compiler)
								'compiler.generatedAsm.AddParameter(ResultPrefix) 

								'PROPER RESULT COMPILATION REQUIRED HERE!!!!!
								'compiler.generatedAsm.AddParameter(Store)  
								Local tmpToken:Token = new Token
								tmpToken.Kind = eToken.IDENTIFIER 
								tmpToken.text  = Store
								compiler.WriteIdentParameter(tmpToken)

								
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
							Case "^"; result = math.Pow(float(Prev.text) ,float(Post.text))
							Case "%"; result = float(Prev.text) mod float(Post.text)
							Case "&"; result = Int(Prev.text) & Int(Post.text)
							Case "|"; result = Int(Prev.text) | Int(Post.text)
							Case "~"; result = Int(Prev.text) ~ Int(Post.text)
							Case "shl"; result = Int(Prev.text) shl Int(Post.text)
							Case "shr"; result = Int(Prev.text) shr Int(Post.text)
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
	
	Function IsOpenBracket:Bool(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = "(" or token.text = "[" Then Return True
		Return false
	End
	
	Function isCloseBracket:Bool(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = ")" or token.text = "]" Then Return True
		Return false
	End
	
	Function IsItem:Bool(token:Token)
		Select token.Kind
			Case eToken.NUMBER, eToken.STRINGLITERAL, eToken.IDENTIFIER
				Return True
			Default
				Return False 
		End 
	End
	
	Function IsIntPrefix:Bool(prefix:String)
		Select prefix
			Case expKinds.INTPREFIX, expKinds.INTVAR, expKinds.TMPINTEGER
				Return true
			Default
				Return false
		end
	End
	
End

Function TellPrefix:String(t:Token, compiler:Compiler) 'compilerScopeStack:CompilerScopeStack) ', compiler:Compiler)
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
				if compiler.compilerScopeStack.VariableExists(t.text) = False Then
					compiler.AddError("Unknown identifier: " + t.text,t.sourceFile, t.docX, t.docY )
					'For local v:CompVariable = EachIn scope.variables.Values
					'	Print "Available variable:" + v.Name
					'Next
					Return expKinds.ERRORUNKNOWNVAR 
				Else
					Local vari:CompVariable = compiler.compilerScopeStack.FindVariable (t.text, null)
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











