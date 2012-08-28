Import Harpl
Class CppTrans
	Field source:Compiler
	Method Translate()
		Local code:= source.generatedAsm.code
		Local node:list.Node<String> = code.FirstNode()
		While node <> null  
			Select node.Value
				Case AssemblerObj.SET_NEWSCOPE
				
			End Select
		
		
			node = node.NextNode
		Wend
	End
End