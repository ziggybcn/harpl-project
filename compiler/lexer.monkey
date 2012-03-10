Import Harpl
Import token
#rem
	header: This is the lexer module. This module has all the required resources to split the Harpl source code into tokens.
	A token is the minimum significative unit of Harpl source code. Like words on a natural language.
#end

#rem
	summary: The Lexer class handles the lexing of Harpl source code.
#end
Class Lexer
	'summary: This field contains the list of tokens after a Lexing process
	Field tokens:=New List<Token>
	#Rem
		summary: This method processes all source code from a txtStream (a string) and fills in an ordererd tokens list, ready to be semanted.
		The required parameters for this process are:
		[list]
		[*]The txtStream that contains the source code. This is the source code to be compiled in the form of a String.
		[*]The Harpl compiler associated to this process, so any lexing syntax error can be notified to the compiler.
		[*]The complete path of the source code document on disk, from where the txtstream has been read. This information is required to fill properly any compilation error details
		[/list]
	#End
	Method Tokenize(txtStream:String, compiler:Compiler, sourceFile:string)

		Local boolRef:BoolByRef = New BoolByRef 'Used to retrieve results from "byref" boolean parameters
		If tokens=null Then tokens = New List<Token>
		
		tokens.Clear()
		
		Local i:Int = 0, lastOffset:Int = 0, lineNum:Int = 0
		Print "Tokenizing..."
		While i<txtStream.Length
			'We begin an Identifier:
			Local char:Int = txtStream[i] 
			
			'If it is a regular identifier:
			If (char>="a"[0] And char<="z"[0]) or (char>="A"[0] And char<="Z"[0]) Then
				Local done:Bool 
				done = False
				Local tokenInit:Int = i
				While i<txtStream.Length And done = False
					if IsAValidIdentifierChar(txtStream[i]) = false Then done = True else i+=1
				wend
				Local identifierText:String = txtStream[tokenInit..i].ToLower()	'Remove ToLower for a case sensitive language. Harpl is not.
				Local token:=New Token(sourceFile, tokenInit-lastOffset, lineNum ,identifierText,eToken.IDENTIFIER)
				IsATextualOperator(token)
				tokens.AddLast(token)
				i-=1	'Correct i offset, not nice.
				
			'Check for numeric decimal literals:
			ElseIf char>="0"[0] And char<="9"[0]
				Local done:Bool, hasdot:Bool = false
				done = False
				Local tokenInit:Int = i
				While i<txtStream.Length And done = False
					if (txtStream[i]>="0"[0] And txtStream[i]<="9") Then 
						i+=1
					ElseIf txtStream[i] = "."[0]
						if hasdot = False Then 
							hasdot = True
							i+=1
						Else 
							compiler.AddError("Malformed numeric literal",sourceFile,tokenInit-lastOffset,lineNum)
							done = true
						EndIf
					Else
						done = true
					endif
				wend
				Local token:=New Token(sourceFile, tokenInit-lastOffset, lineNum ,txtStream[tokenInit..i],eToken.NUMBER )
				tokens.AddLast(token)
				i-=1	'Correct i offset, not nice.
			
			'Check for hexadecimal numbers, ala HTML #FFFFFF, and so on...
			ElseIf char = "#"[0]
				Local done:Bool
				done = False
				Local tokenInit:Int = i
				i=i+1
				While i<txtStream.Length And done = False
					if (txtStream[i]>="0"[0] And txtStream[i]<="9") or (txtStream[i]>="A" And txtStream[i]<="Z") or (txtStream[i]>="a" And txtStream[i]<="z") Then 
						i+=1
					Else
						done = true
					endif
				wend
				'TODO: Convert HEX to regular decimal. This can be done while lexing (why not?)
				Local newtext:string = HexToInteger(txtStream[tokenInit+1 ..i], boolRef )
				if boolRef.value = False Then	'conversion from Hex to regular Int has failed:
					 compiler.AddError("Malformed HEX identifier: " + txtStream[tokenInit ..i], sourceFile,tokenInit-lastOffset-1,lineNum)
				EndIf
				Local token:=New Token(sourceFile, tokenInit-lastOffset, lineNum ,newtext,eToken.NUMBER )
				tokens.AddLast(token)
				i-=1	'Correct i offset, not nice.
			
				
			'If it is a string literal with double quotes:
			ElseIf char = "~q"[0]
				Local done:Bool 
				done = False
				Local tokenInit:Int = i+1
				i+=1;
				While i<txtStream.Length And done = False
					if (txtStream[i] = "~q"[0]) Then done = True else i+=1
				wend
				if done=False Then
					compiler.AddError("Expecting ~q",sourceFile,tokenInit-lastOffset-1,lineNum)
				EndIf
				Local token:=New Token(sourceFile, tokenInit -lastOffset-1 ,lineNum,txtStream[tokenInit..i],eToken.STRINGLITERAL)
				token.text = ScapeChars (token.text)
				tokens.AddLast(token)

			'If it is a string literal with single quotes:
			ElseIf char = "'"[0]
				Local done:Bool 
				done = False
				Local tokenInit:Int = i+1
				i+=1;
				While i<txtStream.Length And done = False
					if (txtStream[i] = "'"[0]) Then done = True else i+=1
				wend
				if done=False Then
					compiler.AddError("Expecting '",sourceFile,tokenInit-lastOffset-1,lineNum)
				EndIf
				Local token:=New Token(sourceFile,tokenInit - lastOffset-1, lineNum,txtStream[tokenInit..i],eToken.STRINGLITERAL)
				token.text = ScapeChars (token.text)
				tokens.AddLast(token)

			'If it is a End Of Sentence (wich can be a linefeed or a ; )
			ElseIf char = "~n"[0] or char = "~r"[0]
				Local token:=New Token(sourceFile,i-lastOffset, lineNum, "~~N",eToken.CARRIER)
				tokens.AddLast(token)
				if char = "~n"[0] then
					lastOffset = i+1	'we have to add the CR in the offset
					lineNum+= 1
				endif
			
			elseif char = ";"[0]
				Local token:=New Token(sourceFile,i-lastOffset, lineNum, txtStream[i..i+1],eToken.ENDSENTENCE)
				tokens.AddLast(token)
				if char = "~n"[0] then
					lastOffset = i+1	'we have to add the CR in the offset
					lineNum+= 1
				endif
			
				
			'If it is an operator:
			ElseIf char = "+"[0] or char = "-"[0] or char = "*"[0] or char = "/"[0] or char = "%"[0] or char = "^"[0] or char = "&"[0] or char = "|"[0] or 
				char = ">"[0] or char = "<"[0] or char = "="[0] or char = "("[0] or char = ")"[0] or char = "["[0] or char = "]"[0] or char="."[0] or char=","[0] then
				Local token:=New Token(sourceFile, i-lastOffset, lineNum,txtStream[i..i+1],eToken.OPERATOR)
				tokens.AddLast(token)
			
			'valid separators:
			ElseIf char = " "[0] or char = "~t"[0]
			
			'If it is a Comment
			ElseIf char = "!"[0]
				Local done:Bool 
				done = False
				i+=1;
				While i<txtStream.Length And done = False
					if (txtStream[i] = "~n"[0] or txtStream[i] = "~r"[0]) Then done = True else i+=1
				wend

			'Otherwise SYNTAX ERROR!!
			Else
				compiler.AddError("Syntax error. Unexpected character: " + String.FromChar(char),sourceFile,i-lastOffset,lineNum)

			EndIf
			i+=1;
		Wend

		'TOKEN MERGING UPSIDE DOWN:
		Local node:list.Node<Token> = tokens.FirstNode()
		Repeat 
			Local skipNext:Bool = false
			Local token:Token = node.Value()
			Select token.Kind
				Case eToken.OPERATOR 
					'We join a dot + a numeral in a single identifier .5 means 0.5, we should accept this. :
					if token.text = "." Then
						Local nextnode:list.Node<Token> = node.NextNode()
						if nextnode<>null Then
							if nextnode.Value.Kind = eToken.NUMBER and nextnode.Value.text.Contains(".") = False Then
								token.text = "0" + token.text + nextnode.Value.text
								token.Kind = eToken.NUMBER 
								nextnode.Remove()
							EndIf
						endif
						
						'We joining >= and <= and <> and ><
					ElseIf token.text = ">" or token.text = "<" Then
						Local nextnode:list.Node<Token> = node.NextNode()
						if nextnode<>null Then
							if (nextnode.Value.text = "=" or nextnode.Value.text = ">" or nextnode.Value.text = "<") And 
							nextnode.Value.Kind = eToken.OPERATOR and 
							nextnode.Value.text <> node.Value.text then
								token.text = token.text + nextnode.Value.text 
								nextnode.Remove()
							EndIf
						endif
					
					EndIf
				Case eToken.NUMBER 
					Local prevNode:list.Node<Token> = node.PrevNode()
					if prevNode <> null And prevNode.Value.Kind = eToken.OPERATOR Then
						Local grandpaNode:list.Node<Token> = prevNode.PrevNode()
						if (grandpaNode <> null And grandpaNode.Value.Kind = eToken.OPERATOR) or grandpaNode = null
							if prevNode.Value.text = "-" then
								if token.text[0] <> "-"[0] Then 
									token.text = "-" + token.text
								Else
									token.text = Mid(token.text,2)
								EndIf
								prevNode.Remove()
								'node = node.PrevNode()	'Just to chain iterations properly!
								skipNext = True;
							ElseIf prevNode.Value.text = "+" then 'We can just ignore expresions of kind a = 45 * +7, and considere them 45 * 7
								prevNode.Remove()
								'node = node.PrevNode()	'Just to chain iterations properly!							
								skipNext = True;
							endif

						EndIf
					EndIf
				Default
			End
			if Not skipNext Then node = node.NextNode()
		Until node = null 
'
		For Local t:Token = EachIn tokens
			Print t.Kind + " at (" + t.docX + "," + t.docY + ") = ~q" + t.text + "~q"
		Next

		'returns TRUE if there are no compiler errors after the whole thing.
		Return compiler.compileErrors.IsEmpty()
		
	End method
End

Private
Function IsAValidIdentifierChar:Bool(char:Int)
	if (char>="a"[0] And char<="z"[0]) or (char>="A"[0] And char<="Z"[0]) or char = "_"[0] or (char>="0"[0] And char<="9"[0])
		Return true
	Else
		Return false
	EndIf
End

Function ScapeChars:String(text:String)
	Return text.Replace("~~n","~n").Replace("~~q","'").Replace("~~d","~q").Replace("~~~~","~~").Replace("~~t","~t").Replace("~~r","~r")
End

Function IsATextualOperator:Bool(token:Token)
	Select token.text
		Case "and", "or", "not"
			token.Kind = eToken.OPERATOR 
			Return true
		default
			Return false
	End
End