Import Harpl
Import reflection
Class ExpressionCompiler

	Field compiler:Compiler

	Field IntCounter:Int = 0
	Field StringCounter:Int = 0
	Field FloatCounter:Int = 0
	Field BooleanCounter:Int = 0
	
	Method CompileExpression()
	
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
		
			'TO DO: BRACKETS AND COMA!!!!
			
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
		return WriteAsm(expression)
	End
	
	Private
	
	Field result:Token
		
	Method WriteAsm:Bool(expression:List<Token>)
		
		'Pending Braces!!
		
		'Unnary operators
		
		'Addition as a simple example:
		if ProcessBinaryOperator("+","SUM",expression) = False Then Return false
	End
	
	Method ProcessBinaryOperator?(op:String, pref:String, expression:List<Token>)
		Local node:list.Node<Token>
		node = expression.FirstNode()
		While node.NextNode<>null
			Local curT:Token = node.Value()
			'WE HAVE AN OPERATION
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

				compiler.generatedAsm.code.AddLast(pref+TellPrefix(Prev)+TellPrefix(Post))
				'TODO: Missing scope info!!!
				compiler.generatedAsm.code.AddLast(Prev.text)
				'TODO: Missing scope info!!!
				compiler.generatedAsm.code.AddLast(Post.text)

				'MIRAMOS EN QUE TIPO DE TEMP HAY QUE GUARDARLO: NECESITAMOS SCOPE!!
				Select op
					Case "+"
						
					Case "-"
					
				End Select
			EndIf
			node = node.NextNode
		Wend
	End
	
	Function TellPrefix:String(t:Token)
		Select t.Kind
			Case eToken.STRINGLITERAL 
				Return "ST"	'STRINGLITERAL
			Case eToken.IDENTIFIER 
				if t.text.StartsWith("!N") Then
					Return "TN"	'TEMP INTEGER
				elseif t.text.StartsWith("!F") Then
					Return "TF" 'TEMP FLOAT
				elseif t.text.StartsWith("!S") Then
					Return "TS" 'TEMP STRING
				elseif t.text.StartsWith("!B") Then
					Return "TB" 'TEMP BOOLEAN
				Else
					'TODO: Need to know the identifier kind SCOPE INFO!!
					Return "VN"	'VARIABLE INTEGER
				EndIf
			Case eToken.NUMBER 
				If t.text.Contains(".") = False Then
					Return "IN"	'INTEGER NUMBER	
				Else
					Return "FN" 'FLOAT NUMBER
				EndIf
				
		End Select
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
		End Select
	End
	
End
