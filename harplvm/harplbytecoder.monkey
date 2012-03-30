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
			local Sentence:String = node.Value()
			Select Sentence
				'Add/Remove half-dynamic scopes:
				Case AssemblerObj.SET_NEWSCOPE 
					compileNewScope( result)
				Case AssemblerObj.EXIT_SCOPE 
					CompileExitScope(result)
				
				Case AssemblerObj.BIT_AND, AssemblerObj.BIT_OR, 
					AssemblerObj.BIT_SHL , AssemblerObj.BIT_SHR , 
					AssemblerObj.BIT_XOR , AssemblerObj.CONCAT , 
					AssemblerObj.DIV , AssemblerObj.MODULUS  , 
					AssemblerObj.MUL , AssemblerObj.POW  , 
					AssemblerObj.SUB , AssemblerObj.SUM   
					CompileBynaryOp(result)
			Default
				Print "Unknown sentence in the Assembler object: " + node.Value
				Return null
			End
			node = node.NextNode()
		Wend
		result.code = result.tmpCode.ToArray()
		result.tmpCode = null
		Return result
		
	End Method
	
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
		Local dataType:String = node.Value
		Select dataType
			Case expKinds.BOOLVAR 
				result.tmpCode.AddLast(expKinds.BC_BOOLVAR)
			Case expKinds.FLOATVAR  
				result.tmpCode.AddLast(expKinds.BC_FLOATVAR )
			Case expKinds.INTVAR  
				result.tmpCode.AddLast(expKinds.BC_INTVAR)
			Case expKinds.STRINGVAR 
				result.tmpCode.AddLast(expKinds.BC_STRINGVAR)
		End
		Return true
	end
	
	Method compileNewScope:Bool(result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_NEWSCOPE )
		local scope:Int = assemblerScopeStack.AddDataScope()

		node = node.NextNode() 
		Local intCounter:Int = 0, strCounter:Int = 0, boolCounter:Int = 0, floatCounter:Int = 0
		While node <> null and IsParameter()
			'READ ALL VARS AND WORK ACCORDINGLY
			'node process... etc.
			Local integer:IntByRef = new IntByRef
			Local varKind:String = node.Value
			Select varKind
				Case "~t" + expKinds.INTVAR 
					integer.value = intCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value,integer)
					intCounter+=1
					node = node.NextNode

				Case "~t" + expKinds.STRINGVAR  
					integer.value = strCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value,integer)
					strCounter+=1
					node = node.NextNode

				Case "~t" + expKinds.BOOLVAR 
					integer.value = boolCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value,integer)
					boolCounter+=1
					node = node.NextNode
				Case "~t" + expKinds.FLOATVAR 
					integer.value = floatCounter
					assemblerScopeStack.dataScopes.Last().intVars.Add(node.NextNode.Value,integer)
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
		return node.Value.StartsWith("~t")
	end
End