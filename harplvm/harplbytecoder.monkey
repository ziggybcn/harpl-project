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
			Local consumeNext:Bool = True
			local Sentence:String = node.Value()
			Print "Processing : " + Sentence
			Select Sentence
				'Add/Remove half-dynamic scopes:
				Case AssemblerObj.SET_NEWSCOPE 
					compileNewScope( result)
					'consumeNext = false
				Case AssemblerObj.EXIT_SCOPE 
					CompileExitScope(result)
				
				'VAR ALOCATION:
				Case AssemblerObj.SET_DEFVAR 
					CompileDefVar(result)
				Case AssemblerObj.SET_VAR 
					CompileSetVar(result)
					Print "Node value after SET VAR = " + node.Value
				'ARITHMETICS:
				Case AssemblerObj.BIT_AND, AssemblerObj.BIT_OR, 
					AssemblerObj.BIT_SHL , AssemblerObj.BIT_SHR , 
					AssemblerObj.BIT_XOR , AssemblerObj.CONCAT , 
					AssemblerObj.DIV , AssemblerObj.MODULUS  , 
					AssemblerObj.MUL , AssemblerObj.POW  , 
					AssemblerObj.SUB , AssemblerObj.SUM   
					CompileBynaryOp(result)
			Default
				Print "Unknown sentence in the Assembler object: " + node.Value
				'Return null
			End
			if consumeNext then node = node.NextNode()
		Wend
		result.code = result.tmpCode.ToArray()
		result.tmpCode = null
		Return result
		
	End Method
	
	Method CompileDefVar(result:ByteCodeObj)
		
	End
	
	Method CompileSetVar(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_VAR)
		node = node.NextNode
		CompileVarAccess(result)
		CompileVarAccess(result)
		Print "Node value just before leaving Set Var= " + node.Value()
	End
	Method CompileBynaryOp:Bool(result:ByteCodeObj)
		Local Instruct:Int
		Select node.Value
			Case AssemblerObj.BIT_AND
				Instruct = AssemblerObj.BC_BIT_AND 
			case AssemblerObj.BIT_OR 
				Instruct = AssemblerObj.BC_BIT_OR
			case AssemblerObj.BIT_SHL 
				Instruct = AssemblerObj.BC_BIT_SHL
			case AssemblerObj.BIT_SHR  
				Instruct = AssemblerObj.BC_BIT_SHR  
			case AssemblerObj.BIT_XOR 
				Instruct = AssemblerObj.BC_BIT_XOR 
			case AssemblerObj.CONCAT  
				Instruct = AssemblerObj.BC_CONCAT
			case AssemblerObj.DIV 
				Instruct = AssemblerObj.BC_DIV 
			case AssemblerObj.MODULUS  
				Instruct = AssemblerObj.BC_MODULUS  
			case AssemblerObj.MUL 
				Instruct = AssemblerObj.BC_MUL 
			case AssemblerObj.POW   
				Instruct = AssemblerObj.BC_POW   
			case AssemblerObj.SUB 
				Instruct = AssemblerObj.BC_SUB 
			case AssemblerObj.SUM   
				Instruct = AssemblerObj.BC_SUM
			Default
				Print "Unknown bynary operator found!"
		End
		if Instruct = 0 Then Return false

		node = node.NextNode
		if node = null Then Return false
		'Compile first operator:
		CompileVarAccess(result)
		'Compile second operator:
		CompileVarAccess(result)
		'Compie result TMP:
		'PENDING
		Return true		
	End
	Method CompileVarAccess:Bool(result:ByteCodeObj)
		Local dataType:String = node.Value.Trim()
		'Local scope:AssemblerScope 
		Print "Data type for Compile Var Access: " + dataType
		Select dataType
			Case expKinds.BOOLVAR 
				result.tmpCode.AddLast(expKinds.BC_BOOLVAR)
				Local varName:String = node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).booleanVars.ValueForKey(varName)				
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				node = node.NextNode.NextNode.NextNode()
				return true				
				
			Case expKinds.FLOATVAR  
				result.tmpCode.AddLast(expKinds.BC_FLOATVAR )
				Local varName:String = node.NextNode().Value().Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).floatVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				node = node.NextNode.NextNode.NextNode()
				return true				
				
			Case expKinds.INTVAR  
				result.tmpCode.AddLast(expKinds.BC_INTVAR)
				Local varName:String = node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Print "Getting scope: " + scopeIndex + " for var: " + varName
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).intVars.ValueForKey(varName)
				Print "Scope was found."
				if varNumber = Null Then
					Print "Varnumber is not valid!"
					Return False
				Else
					result.tmpCode.AddLast(varNumber.value)
					result.tmpCode.AddLast(scopeIndex)
					node = node.NextNode.NextNode.NextNode()
					return true							
				EndIf
				
			Case expKinds.STRINGVAR 
				result.tmpCode.AddLast(expKinds.BC_STRINGVAR)
				Local varName:String = node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).stringVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				node = node.NextNode.NextNode.NextNode()
				return true
				
			Case expKinds.ARRAYVAR 
				result.tmpCode.AddLast(expKinds.BC_ARRAYVAR )
				Local varName:String = node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).arrayVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value)
				result.tmpCode.AddLast(scopeIndex)
				node = node.NextNode.NextNode.NextNode()
				return true

			Case expKinds.OBJVAR 
				result.tmpCode.AddLast(expKinds.BC_OBJVAR )
				Local varName:String = node.NextNode().Value.Trim()
				Local scopeIndex:Int = Int(node.NextNode.NextNode.Value().Trim())
				Local varNumber:IntByRef = assemblerScopeStack.GetIndexedScope(scopeIndex).objVars.ValueForKey(varName)
				result.tmpCode.AddLast(varNumber.value )
				result.tmpCode.AddLast(scopeIndex)
				node = node.NextNode.NextNode.NextNode()
				return true

			Case expKinds.ERRORUNKNOWNVAR 
				Print ("Error var was sent to the bytecoder generator!!!!")
				Return false
				
			Case expKinds.FLOATPREFIX 
				result.tmpCode.AddLast(expKinds.BC_FLOATPREFIX  )
				Local text:String = node.NextNode.Value().Trim()
				result.tmpFloats.AddLast(float(text))
				result.tmpCode.AddLast(result.tmpFloatCount)
				result.tmpFloatCount +=1
				node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.INTPREFIX  
				result.tmpCode.AddLast(expKinds.BC_INTPREFIX )
				Local text:String = node.NextNode.Value().Trim()
				result.tmpCode.AddLast(int(text))
				node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.STRINGLITERAL 
				result.tmpCode.AddLast(expKinds.BC_STRINGLITERAL)
				Local text:String = Mid(node.NextNode.Value(), AssemblerObj.ParameterPrefix.Length() + 1 )
				result.tmpLiterals.AddLast(text)
				result.tmpCode.AddLast(result.tmpLiteralsCount )
				result.tmpLiteralsCount +=1
				node = node.NextNode.NextNode()
				Return true

			Case expKinds.TMPBOOL 
				result.tmpCode.AddLast(expKinds.BC_TMPBOOL)
				Local index:Int = Int(Mid(node.NextNode.Value.Trim() , eTmpTokens.TMPBOOL.Length+1))
				result.tmpCode.AddLast(index)
				node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.TMPFLOAT 
				result.tmpCode.AddLast(expKinds.BC_TMPFLOAT )
				Local index:Int = Int(Mid(node.NextNode.Value.Trim() , eTmpTokens.TMPFLOAT.Length+1))
				result.tmpCode.AddLast(index)
				node = node.NextNode.NextNode()
				Return true
				
			Case expKinds.TMPINTEGER  
				result.tmpCode.AddLast(expKinds.BC_TMPINTEGER )
				Local index:Int = Int(Mid(node.NextNode.Value.Trim() , eTmpTokens.TMPINT.Length+1))
				result.tmpCode.AddLast(index)
				node = node.NextNode.NextNode()
				Return true

			Case expKinds.TMPSTRING 
				result.tmpCode.AddLast(expKinds.BC_TMPSTRING )
				Local index:Int = Int(Mid(node.NextNode.Value.Trim() , eTmpTokens.TMPSTRING.Length + 1))
				result.tmpCode.AddLast(index)
				node = node.NextNode.NextNode()
				Return true
				
			Default
				Print "Error variable kind!!! " + node.Value()
		End
	end
	
	Method compileNewScope:Bool(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_NEWSCOPE )
		local scope:Int = assemblerScopeStack.AddDataScope()
		Print "Scope created and has " + assemblerScopeStack.GetIndexedScope(-1).intVars.Count() + " integer variables"
		node = node.NextNode() 
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
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value.Trim(),integer)
					strCounter+=1
					node = node.NextNode

				Case AssemblerObj.ParameterPrefix + expKinds.BOOLVAR 
					integer.value = boolCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value.Trim(),integer)
					boolCounter+=1
					node = node.NextNode
				Case AssemblerObj.ParameterPrefix + expKinds.FLOATVAR 
					integer.value = floatCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value.Trim(),integer)
					floatCounter+=1
					node = node.NextNode
				Default
					Print "Error in the bytecode generation process. Unknown NEW_SCOPE parameter."
					return false
			End
			node = node.NextNode
		wend
		if node <> null Then node = node.PrevNode()
		'That's the order on wich scope operators are informed!
		result.tmpCode.AddLast(intCounter)
		result.tmpCode.AddLast(strCounter)
		result.tmpCode.AddLast(boolCounter)
		result.tmpCode.AddLast(floatCounter)
		Return true
	end
	
	Method CompileExitScope(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_EXIT_SCOPE )
	End
	
	Method IsParameter:Bool()
		return node.Value.StartsWith(AssemblerObj.ParameterPrefix)
	end
End