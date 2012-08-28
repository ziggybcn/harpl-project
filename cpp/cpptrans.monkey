Import Harpl
Class CppTrans
	Field source:Compiler
	Method Translate()
	
		Local asm:= source.generatedAsm.code

		Local node:list.Node<String> = asm.FirstNode()
		
		While node <> null  
			Select node.Value
			
				Case AssemblerObj.SET_NEWSCOPE
				'We can expect a number of variablez here, we'll have to diferenciate between a Global scope or a Local scope here.	
			End Select
		
			node = node.NextNode
		Wend

	End
	
End