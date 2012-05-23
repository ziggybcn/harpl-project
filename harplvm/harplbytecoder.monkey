Import Harpl
Import assemblerscope.assemblerscopestack 

#Rem  
	summary: This is the Harpl Byte Code assembler.
	This Class will provide all methods required to convert Harpl Assembler to bytecode that the Harpl Virtual Machine can run.
#end
Class HarplByteCoder
	Const BC_VERSION:Int = 0
	Const BC_REVISION:Int = 0
	Field assemblerScopeStack:AssemblerScopeStack = new AssemblerScopeStack 
	Field node:list.Node<String>
	Method GenerateByteCode:ByteCodeObj(harplAsm:AssemblerObj)
		
		Local result:= New ByteCodeObj

		'We add compatibility information:
		result.tmpCode.AddLast(BC_VERSION)
		result.tmpCode.AddLast(BC_REVISION)
		
		If harplAsm.code = null Then Return null
		
		'local node:list.Node<String> = harplAsm.code.FirstNode()
		node = harplAsm.code.FirstNode()
		Local done:Bool = false
		While (node <>null) and not done
			'Local consumeNext:Bool = True
			local Sentence:String = node.Value()
			WriteInConsole  "Processing : " + Sentence
			Select Sentence
				'Add/Remove half-dynamic scopes:
				Case AssemblerObj.SET_NEWSCOPE 
					compileNewScope( result)

				Case AssemblerObj.EXIT_SCOPE 
					CompileExitScope(result)
				
				'VAR ALOCATION:
				Case AssemblerObj.SET_DEFVAR 
					CompileDefVar(result)
					
				Case AssemblerObj.SET_VAR 
					CompileSetVar(result)
					
				Case AssemblerObj.IO_OUTPUT 
					CompileIoOutput(result)
					
				'ARITHMETICS:
				
				Case AssemblerObj.UNARY_COMPLEMENT, AssemblerObj.UNARY_SUB, AssemblerObj.AS_BOOLEAN,
				AssemblerObj.AS_FLOAT, AssemblerObj.AS_INTEGER, AssemblerObj.AS_STRING 
					CompileUnaryOp(result)
				
				Case AssemblerObj.BIT_AND, AssemblerObj.BIT_OR, 
					AssemblerObj.BIT_SHL , AssemblerObj.BIT_SHR , 
					AssemblerObj.BIT_XOR , AssemblerObj.CONCAT , 
					AssemblerObj.DIV , AssemblerObj.MODULUS  , 
					AssemblerObj.MUL , AssemblerObj.POW  , 
					AssemblerObj.SUB , AssemblerObj.SUM, 
					AssemblerObj.EQUALS, AssemblerObj.MAJOR,
					AssemblerObj.MAJOR_EQUAL, AssemblerObj.MINOR,
					AssemblerObj.MINOR_EQUAL, AssemblerObj.NOT_EQUALS,
					AssemblerObj.LOGICAL_AND, AssemblerObj.LOGICAL_OR 
					CompileBynaryOp(result)
				
				Case AssemblerObj.SET_TRUE
					result.tmpCode.AddLast(AssemblerObj.BC_SET_TRUE)
					CompileVarAccess(result)

					
			Default
				Print "Unknown sentence in the Assembler object: " + node.Value
				'Return null
			End
			if IsLastSentence() Then 
				done = true
			else
				GetNextSentence()
			endif
		Wend
		result.code = result.tmpCode.ToArray()
		result.literals = result.tmpLiterals.ToArray()
		result.floats = result.tmpFloats.ToArray()
		result.requiredBooleanSize = harplAsm.requiredBoolSize 
		result.RequiredFloatSize = harplAsm.requiredFloatSize 
		result.RequiredIntegerSize = harplAsm.requiredIntSize 
		result.requiredStringsSize = harplAsm.requiredStringSize 

		result.tmpCode = null
		Return result
		
	End Method
	
	Method CompileDefVar(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_DEFVAR )
		CompileVarAccess(result)
		
	End
	
	Method CompileSetVar(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_VAR)
		'node = node.NextNode
		CompileVarAccess(result)
		CompileVarAccess(result)
	End
	
	Method CompileIoOutput(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_IO_OUTPUT )
		CompileVarAccess(result)
	End
	
	Method CompileUnaryOp:Bool(result:ByteCodeObj )
		Local instruct:Int = 0
		Select node.Value
			Case AssemblerObj.UNARY_COMPLEMENT 
				instruct = AssemblerObj.BC_UNARY_COMPLEMENT 
			Case AssemblerObj.UNARY_SUB 
				instruct = AssemblerObj.BC_UNARY_SUB 
			Case AssemblerObj.AS_BOOLEAN 
				instruct = AssemblerObj.BC_AS_BOOLEAN 
			Case AssemblerObj.AS_FLOAT 
				instruct = AssemblerObj.BC_AS_FLOAT 
			Case AssemblerObj.AS_INTEGER 
				instruct = AssemblerObj.BC_AS_INTEGER 
			Case AssemblerObj.AS_STRING 
				instruct = AssemblerObj.BC_AS_STRING
			Default
				Error("Unknown unary operator was found.")
				Return false
		End Select
		result.tmpCode.AddLast(instruct)
		CompileVarAccess(result) 'The target of the operation
		CompileVarAccess(result) 'The place to store the result
		
	End
	
	
	Method CompileBynaryOp:Bool(result:ByteCodeObj)
		Local instruct:Int
		Select node.Value
			Case AssemblerObj.BIT_AND
				instruct = AssemblerObj.BC_BIT_AND 
			case AssemblerObj.BIT_OR 
				instruct = AssemblerObj.BC_BIT_OR
			case AssemblerObj.BIT_SHL 
				instruct = AssemblerObj.BC_BIT_SHL
			case AssemblerObj.BIT_SHR  
				instruct = AssemblerObj.BC_BIT_SHR  
			case AssemblerObj.BIT_XOR 
				instruct = AssemblerObj.BC_BIT_XOR 
			case AssemblerObj.CONCAT  
				instruct = AssemblerObj.BC_CONCAT
			case AssemblerObj.DIV 
				instruct = AssemblerObj.BC_DIV 
			case AssemblerObj.MODULUS  
				instruct = AssemblerObj.BC_MODULUS  
			case AssemblerObj.MUL 
				instruct = AssemblerObj.BC_MUL 
			case AssemblerObj.POW   
				instruct = AssemblerObj.BC_POW   
			case AssemblerObj.SUB 
				instruct = AssemblerObj.BC_SUB 
			case AssemblerObj.SUM   
				instruct = AssemblerObj.BC_SUM
			Case AssemblerObj.EQUALS 
				instruct = AssemblerObj.BC_EQUALS 
			Case AssemblerObj.MAJOR 
				instruct = AssemblerObj.BC_MAJOR
			Case AssemblerObj.MAJOR_EQUAL 
				instruct = AssemblerObj.BC_MAJOR_EQUAL 
			Case AssemblerObj.MINOR 
				instruct = AssemblerObj.BC_MINOR
			Case AssemblerObj.MINOR_EQUAL 
				instruct = AssemblerObj.BC_MINOR_EQUAL 
			Case AssemblerObj.NOT_EQUALS
				instruct = AssemblerObj.BC_NOT_EQUALS 
			Case AssemblerObj.LOGICAL_AND
				instruct = AssemblerObj.BC_LOGICAL_AND 
			Case AssemblerObj.LOGICAL_OR
				instruct = AssemblerObj.BC_LOGICAL_OR 
			Default
				Print "Unknown bynary operator found!"
		End
		if instruct = 0 Then Return false

		if node = null Then Return false
		
		result.tmpCode.AddLast(instruct)
		
		'Compile first operator:
		CompileVarAccess(result)
		'Compile second operator:
		CompileVarAccess(result)
		'Compie result TMP:
		CompileVarAccess(result)
		
		Return true		
	End
	Method CompileVarAccess:Bool(result:ByteCodeObj)
		Local dataType:String = GetNextSentence() 'node.Value.Trim()
		'Local scope:AssemblerScope 
		Select dataType
			Case expKinds.BOOLVAR 
				result.tmpCode.AddLast(expKinds.BC_BOOLVAR)
				Local varName:String = self.GetNextSentence() 'node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(self.GetNextSentence()) 'node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).booleanVars.ValueForKey(varName)				
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				return true				
				
			Case expKinds.FLOATVAR  
				result.tmpCode.AddLast(expKinds.BC_FLOATVAR )
				Local varName:String = GetNextSentence ' node.NextNode().Value().Trim()
				Local scopeIndex:Int = Int(GetNextSentence) 'node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).floatVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				return true				
				
			Case expKinds.INTVAR  
				result.tmpCode.AddLast(expKinds.BC_INTVAR)
				Local varName:String = GetNextSentence 'node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(GetNextSentence)
				'Print "Getting scope: " + scopeIndex + " for var: " + varName
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).intVars.ValueForKey(varName)
				'Print "Scope was found."
				result.tmpCode.AddLast(varNumber.value)
				result.tmpCode.AddLast(scopeIndex)
				return true							
				
			Case expKinds.STRINGVAR 
				result.tmpCode.AddLast(expKinds.BC_STRINGVAR)
				Local varName:String = GetNextSentence 'node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(GetNextSentence())  'node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).stringVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value)
				result.tmpCode.AddLast(scopeIndex)
				'node = node.NextNode.NextNode.NextNode()
				return true
				
			Case expKinds.ARRAYVAR 
				result.tmpCode.AddLast(expKinds.BC_ARRAYVAR )
				Local varName:String = GetNextSentence()  'node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int( GetNextSentence())  'node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).arrayVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value)
				result.tmpCode.AddLast(scopeIndex)
				'node = node.NextNode.NextNode.NextNode()
				return true

			Case expKinds.OBJVAR 
				result.tmpCode.AddLast(expKinds.BC_OBJVAR )
				Local varName:String = GetNextSentence() 'node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(GetNextSentence())  'node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).objVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				'node = node.NextNode.NextNode.NextNode()
				return true

			Case expKinds.ERRORUNKNOWNVAR 
				Print ("Error var was sent to the bytecoder generator!!!!")
				Return false
				
			Case expKinds.FLOATPREFIX 
				result.tmpCode.AddLast(expKinds.BC_FLOATPREFIX  )
				Local text:String = GetNextSentence() 'node.NextNode.Value().Trim()
				'Print "Text is: " + text
				result.tmpFloats.AddLast(float(text))
				result.tmpCode.AddLast(result.tmpFloatCount)
				result.tmpFloatCount +=1
				'node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.INTPREFIX  
				result.tmpCode.AddLast(expKinds.BC_INTPREFIX )
				Local text:String = GetNextSentence() 'node.NextNode.Value().Trim()
				result.tmpCode.AddLast(int(text))
				'node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.STRINGLITERAL 
				'Print "Accessing string literal..."
				result.tmpCode.AddLast(expKinds.BC_STRINGLITERAL)
				Local text:String = GetNextSentence 'Mid(node.NextNode.Value(), AssemblerObj.ParameterPrefix.Length() + 1 )
				result.tmpLiterals.AddLast(text)
				result.tmpCode.AddLast(result.tmpLiteralsCount )
				result.tmpLiteralsCount +=1
				'Print "String literals done..."
				'node = node.NextNode.NextNode()
				Return true

			Case expKinds.TMPBOOL 
				result.tmpCode.AddLast(expKinds.BC_TMPBOOL)
				Local index:Int = Int(GetNextSentence) 'Int(Mid(node.NextNode.Value.Trim() , eTmpTokens.TMPBOOL.Length+1))
				result.tmpCode.AddLast(index)
				'node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.TMPFLOAT 
				result.tmpCode.AddLast(expKinds.BC_TMPFLOAT )
				Local index:Int = Int(Mid(GetNextSentence(), eTmpTokens.TMPFLOAT.Length+1))
				result.tmpCode.AddLast(index)
				'node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.TMPINTEGER  
				result.tmpCode.AddLast(expKinds.BC_TMPINTEGER )
				Local index:Int = Int(Mid(GetNextSentence() , eTmpTokens.TMPINT.Length+1))
				result.tmpCode.AddLast(index)
				'node = node.NextNode.NextNode()
				Return true

			Case expKinds.TMPSTRING 
				result.tmpCode.AddLast(expKinds.BC_TMPSTRING )
				Local index:Int = Int(Mid(GetNextSentence() , eTmpTokens.TMPSTRING.Length + 1))
				result.tmpCode.AddLast(index)
				'node = node.NextNode.NextNode()
				Return true
				
			Default
				Print "Error variable kind!!! " + node.Value()
		End
	end
	
	Method compileNewScope:Bool(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_NEWSCOPE )
		local scope:Int = assemblerScopeStack.AddDataScope()
		'Print "Scope created and has " + assemblerScopeStack.GetIndexedScope(-1).intVars.Count() + " integer variables"
		'node = node.NextNode() 
		GetNextSentence()
		Local intCounter:Int = 0, strCounter:Int = 0, boolCounter:Int = 0, floatCounter:Int = 0
		While node <> null and IsParameter()
			'READ ALL VARS AND WORK ACCORDINGLY
			'node process... etc.
			Local integer:IntByRef = new IntByRef
			Local varKind:String = node.Value
			Select varKind
				Case AssemblerObj.ParameterPrefix + expKinds.INTVAR 
					integer.value = intCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value.Trim(),integer)
					intCounter+=1
					node = node.NextNode

				Case AssemblerObj.ParameterPrefix + expKinds.STRINGVAR  
					integer.value = strCounter
					assemblerScopeStack.dataScopes.Last().stringVars.Add(node.NextNode.Value.Trim(),integer)
					strCounter+=1
					node = node.NextNode

				Case AssemblerObj.ParameterPrefix + expKinds.BOOLVAR 
					integer.value = boolCounter
					assemblerScopeStack.dataScopes.Last().booleanVars.Add(node.NextNode.Value.Trim(),integer)
					boolCounter+=1
					node = node.NextNode
				Case AssemblerObj.ParameterPrefix + expKinds.FLOATVAR 
					integer.value = floatCounter
					assemblerScopeStack.dataScopes.Last().floatVars.Add(node.NextNode.Value.Trim(),integer)
					floatCounter+=1
					node = node.NextNode
				Default
					Print "Error in the bytecode generation process. Unknown NEW_SCOPE parameter."
					return false
			End
			'node = node.NextNode
			GetNextSentence()
		wend
		if node <> null Then GetPrevSentence() 'node = node.PrevNode()
		'That's the order on wich scope operators are informed!
		result.tmpCode.AddLast(intCounter)
		result.tmpCode.AddLast(strCounter)
		result.tmpCode.AddLast(boolCounter)
		result.tmpCode.AddLast(floatCounter)
		result.tmpCode.AddLast(0) ' Arrays
		result.tmpCode.AddLast(0) ' Objects
		
		Return true
	end
	
	Method CompileExitScope(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_EXIT_SCOPE )
	End
	
	Method IsParameter:Bool()
		return node.Value.StartsWith(AssemblerObj.ParameterPrefix)
	end
	
	Method GetNextSentence:String()
		if node = null Then Return ""
		if node.NextNode = null Then Return ""
		Local value:String = node.NextNode.Value()
		node = node.NextNode()
		if value.StartsWith(AssemblerObj.ParameterPrefix ) Then
			Return Mid(value,AssemblerObj.ParameterPrefix.Length+1)
		Else
			Return value
		EndIf
	End
	
	Method IsLastSentence:Bool()
		if node = null Then Return True
		if node.NextNode = null Then Return True
		Return false
	End
	
	Method GetPrevSentence:String()
		if node = null Then Return ""
		if node.PrevNode  = null Then Return ""
		Local value:String = node.PrevNode.Value()
		node = node.PrevNode()
		if value.StartsWith(AssemblerObj.ParameterPrefix ) Then
			Return Mid(value,AssemblerObj.ParameterPrefix.Length+1)
		Else
			Return value
		EndIf
	End
End