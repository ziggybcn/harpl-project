Import Harpl
Import reflection
Class ExpressionCompiler

	Field compiler:Compiler

	Field IntCounter:Int = 0
	Field StringCounter:Int = 0
	Field FloatCounter:Int = 0
	Field BooleanCounter:Int = 0
	
	Method CompileExpression(scope:CompilerDataScope)
	
		IntCounter = 0
		StringCounter= 0
		FloatCounter= 0
		BooleanCounter= 0
	
		If compiler = Null  Then Error "No compiler associated to the ExpressionCompiler!"

		'This function gets all tokens from the stack that conform the expression:
				
		Local expression:= New List<Token>

		'We get the first token:
		Local currentToken:Token = compiler.lexer.tokens.First(); 
		compiler.lexer.tokens.FirstNode.Remove()		
		Local prevToken:Token = null
		Local done:Bool = false
		Local braces:Int = 0, lastBrace:String = ""
		While Not done 
		
			if IsOpenBracket( currentToken) Then
				braces+=1
				lastBrace = currentToken.text
			ElseIf isCloseBracket(currentToken) 
				braces-=1
				if braces<0 Then
					compiler.AddError("Malformed expression. Unexpected: " + currentToken.text,currentToken.sourceFile,currentToken.docX, currentToken.docY)
				EndIf
			Endif
			
			if braces=0 then	'We ignore subexpressions (we'll work them out later!)
				'We check next Token:
				Select currentToken.Kind
					'If it is an identifier, it's the end of the expression when it is precedded by something different than an operator:
					Case eToken.IDENTIFIER, eToken.NUMBER, eToken.STRINGLITERAL 
						if prevToken<>null Then
							if prevToken.Kind<> eToken.OPERATOR  Then 
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
						if prevToken<>null Then
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
				if currentToken.Kind= eToken.CARRIER 
					if prevToken<>null Then
						if IsItem(prevToken) Then
							if lastBrace = "(" Then 
								compiler.AddError("Expecting a closing brace: )"  ,prevToken.sourceFile,prevToken.docX+prevToken.text.Length,prevToken.docY)
							Else
								compiler.AddError("Expecting a closing brace: ]"  ,prevToken.sourceFile,prevToken.docX+prevToken.text.Length,prevToken.docY)
							endif
							compiler.lexer.tokens.AddFirst(currentToken)
							Exit
						EndIf
					EndIf
				EndIf
			EndIf
			if currentToken.Kind<>eToken.CARRIER Then
				expression.AddLast(currentToken )
				prevToken = currentToken 
			endif
			
			if compiler.lexer.tokens.IsEmpty = False Then
				currentToken = compiler.lexer.tokens.First(); 
				compiler.lexer.tokens.FirstNode.Remove()		
			Else
				done = true
			endif
		Wend
		
		Print "Expression is:"
		For local t:Token = EachIn expression
			Print("." + t.text + ".")
		Next
		Print("--Done--")
		return WriteAsm(expression, scope )
	End
	
	Private
	
	Field result:Token
		
	
	Method WriteAsm:Bool(expression:List<Token>, scope:CompilerDataScope)
		
	
		Local firstToken:Token 
		if expression.FirstNode() <>null Then firstToken= expression.FirstNode().Value()

		'Pending Braces!!
		
		'Unnary operators
		
	
		if ProcessBinaryOperator(["^"], AssemblerObj.POW		,expression, scope) = False Then Return false
		if ProcessBinaryOperator(["*","/","%"], AssemblerObj.MUL 		,expression, scope) = False Then Return false
		'if ProcessBinaryOperator("/", AssemblerObj.DIV  	,expression, scope) = False Then Return false
		'if ProcessBinaryOperator("%", AssemblerObj.MODULUS 	,expression, scope) = False Then Return false
		if ProcessBinaryOperator(["+","-"], AssemblerObj.SUM  	,expression, scope) = False Then Return false
		'if ProcessBinaryOperator("-", AssemblerObj.SUB  	,expression, scope) = False Then Return false
		if ProcessBinaryOperator(["&","|"], AssemblerObj.NUMAND   ,expression, scope) = False Then Return false
		'if ProcessBinaryOperator("|", AssemblerObj.NUMOR  	,expression, scope) = False Then Return false
				
		Print "And then it is:"
		For local t:Token = EachIn expression
			Print("." + t.text + ".")
		Next
		Print("--Done--")
		
		Print("")
		Print("ASM:")
		For Local s:String = EachIn compiler.generatedAsm.code 
			Print s
		Next
		Print ("---END---")
		'return WriteAsm(expression, scope )
		if expression.IsEmpty = True Then
			if firstToken<>null then
				compiler.AddError("Error in expression", firstToken.sourceFile,firstToken.docX, firstToken.docY)
				Return false
			Else
				compiler.AddError("Error in expression in unknown location. That's very weird.","",0,0)
			endif
			Return false
		ElseIf expression.FirstNode.NextNode<> null Then
			compiler.AddError("Error in expression. Expression could not be assembled.", firstToken.sourceFile,firstToken.docX, firstToken.docY)
		Else
			Return true
		EndIf

		
	End
	
	Method ProcessBinaryOperator?(opItems:String[], pref:String, expression:List<Token>, scope:CompilerDataScope)
		Local node:list.Node<Token>
		node = expression.FirstNode()
		While node.NextNode<>null
			Local curT:Token = node.Value()
			'WE HAVE AN OPERATION
			For Local i:Int = 0 until opItems.Length
				local op:String = opItems[i]
				if curT.Kind = eToken.OPERATOR And curT.text = op Then
					'IF IT'S MALFORMED:	
					if node.PrevNode = null or node.NextNode = null Then
						compiler.AddError("Malformed expression",curT.sourceFile,curT.docX, curT.docY)
						Return false					
					EndIf
					
					Local Prev:Token = node.PrevNode.Value
					Local Post:Token = node.NextNode.Value
					
					if IsItem(Prev) = False or IsItem(Post) = False Then
						compiler.AddError("Malformed expression. Expecting identifier.",curT.sourceFile,curT.docX, curT.docY)
						Return false										
					EndIf
	
					Local prefix1:String = TellPrefix(Prev,scope)
					Local prefix2:String =TellPrefix(Post,scope)
					Local operateNum:Bool = false
					if prefix1 = expKinds.INTPREFIX  or prefix1 = expKinds.FLOATPREFIX then
						If prefix2 = expKinds.INTPREFIX Then
							operateNum = true
						ElseIf prefix2 = expKinds.FLOATPREFIX 
							operateNum = true
						EndIf
					EndIf
					if operateNum = False then
						compiler.generatedAsm.code.AddLast(pref + prefix1 + prefix2)
						'TODO: Missing scope info!!!
						compiler.generatedAsm.code.AddLast(Prev.text)
						'TODO: Missing scope info!!!
						compiler.generatedAsm.code.AddLast(Post.text)
		
						'MIRAMOS EN QUE TIPO DE TEMP HAY QUE GUARDARLO: NECESITAMOS SCOPE!!
				
						
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
			if node.NextNode<>null then	node = node.NextNode
		Wend
		Return true
	End
	
	Method TellPrefix:String(t:Token, scope:CompilerDataScope)
		Select t.Kind
			Case eToken.STRINGLITERAL 
				Return expKinds.STRINGLITERAL 	'STRINGLITERAL
			Case eToken.IDENTIFIER 
				if t.text.StartsWith("!N") Then
					Return expKinds.TMPINTEGER 	'TEMP INTEGER
				elseif t.text.StartsWith("!F") Then
					Return expKinds.TMPFLOAT 'TEMP FLOAT
				elseif t.text.StartsWith("!S") Then
					Return expKinds.TMPSTRING  'TEMP STRING
				elseif t.text.StartsWith("!B") Then
					Return expKinds.TMPBOOL 'TEMP BOOLEAN
				Else
					'TODO: ITERATE THROUG PARENT SCOPES
					if scope.variables.Contains(t.text) = False Then
						compiler.AddError("Unknown identifier: " + t.text,t.sourceFile, t.docX, t.docY )
						For local v:CompVariable = EachIn scope.variables.Values
							Print "Available variable:" + v.Name
						Next
						Return expKinds.ERRORUNKNOWNVAR 
					Else
						Local vari:CompVariable = scope.variables.ValueForKey(t.text)
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

	
'	Method IsUnary?(token:Token)
'		if token.Kind <> eToken.OPERATOR Then Return False
'		if token.Kind = "not" or token.Kind = "+" or token.Kind = "-" then Return True
'		Return false
'	End
	
	Method IsOpenBracket?(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = "(" or token.text = "[" Then Return True
		Return false
	End
	
	Method isCloseBracket?(token:Token)
		if token.Kind<> eToken.OPERATOR Then Return False
		if token.text = ")" or token.text = "]" Then Return True
		Return false
	End
	
	Method IsItem?(token:Token)
		Select token.Kind
			Case eToken.NUMBER, eToken.STRINGLITERAL, eToken.IDENTIFIER
				Return True
			Default
				Return False 
		End 
	End
	
End

Class expKinds abstract
	Const INTPREFIX:String = "IN"
	Const FLOATPREFIX:String = "FN"
	Const INTVAR:String = "IV"
	Const BOOLVAR:String = "BV"
	Const FLOATVAR:String = "FV"
	Const STRINGVAR:String = "SV"
	Const ERRORUNKNOWNVAR:String = "ER"
	Const STRINGLITERAL:String = "ST"
	Const TMPINTEGER:String = "TN"
	Const TMPFLOAT:String = "TF"
	Const TMPSTRING:String = "TS"
	Const TMPBOOL:String = "TB"
End





