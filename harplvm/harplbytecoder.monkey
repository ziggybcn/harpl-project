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
	
	Method GenerateByteCode:ByteCodeObj(harplAsm:AssemblerObj)
		
		Local result:= New ByteCodeObj

		'We add compatibility information:
		result.tmpCode.AddLast(BC_VERSION)
		result.tmpCode.AddLast(BC_REVISION)
		
		If harplAsm.code = null Then Return null
		
		local node:list.Node<String> = harplAsm.code.FirstNode()
		Local done:Bool = false
		While (node <>null) and not done
			local Sentence:String = node.Value()
			Select Sentence
				Case AssemblerObj.SET_NEWSCOPE 
				compileNewScope(node, result)
			End
			node = node.NextNode()
		Wend
		result.code = result.tmpCode.ToArray()
		result.tmpCode = null
		Return result
		
	End Method
	
	Method compileNewScope(node:list.Node<String>,result:ByteCodeObj)
		result.tmpCode.AddLast(AssemblerObj.BC_SET_NEWSCOPE )
		local scope:Int = assemblerScopeStack.AddDataScope()

		node = node.NextNode() 
		Local intCounter:Int = 0, strCounter:Int = 0, boolCounter:Int = 0, floatCounter:Int = 0
		While node <> null and IsParameter(node)
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
			End
			node = node.NextNode
		wend
		'That's the order on wich scope operators are informed!
		result.tmpCode.AddLast(intCounter)
		result.tmpCode.AddLast(strCounter)
		result.tmpCode.AddLast(boolCounter)
		result.tmpCode.AddLast(floatCounter)
		
	end
	
	Method IsParameter:Bool(node:list.Node<String>)
		return node.Value.StartsWith("~t")
	end
End