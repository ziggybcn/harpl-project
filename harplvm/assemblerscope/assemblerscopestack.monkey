Import assemblerscope
Class AssemblerScopeStack

	Field dataScopes:List<AssemblerScope>
	Field currentIndex:Int = 0
	
	
	
	#rem
 		summary: This is the CompilerScopeStack constructor.
	#end
	Method New()
		currentIndex = 0	'We're adding the GLOBAL scope!
		dataScopes = New List<AssemblerScope>
	End
	
	#rem
		summary: Adds a new nest data scope, where variables can be created.
	#end
	Method AddDataScope:int()'compiler:Compiler)
		Local cds:=New AssemblerScope
		dataScopes.AddLast(cds)
		currentIndex+=1	
		Return currentIndex-1	
	End
	
	#rem
		summary: closes current compiler data scope, and writes the required assembler code. It also removes the scope from the stack.
	#end
	Method CloseDataScope:CompilerDataScope()
		Local currentDataScope:AssemblerScope = dataScopes.RemoveLast()
		currentIndex -= 1
		Return currentDataScope
	End
	
End