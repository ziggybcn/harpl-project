Import Harpl
Import compilerdatascope
#Rem
	summary: This class should manage any Compiler Data Scope. Adding new subscopes.
#end
Class CompilerScopeStack

	Field dataScopes:List<CompilerDataScope>
	Field currentIndex:Int = 0
	
	Field compiler:Compiler
	
	Method New()
		Error("ERROR IN HARPL SOURCE. A CompilerScopeStack has been created without a compiler parameter in the constructor.")
	End
	
	#rem
 		summary: This is the CompilerScopeStack constructor.
	#end
	Method New(compiler:Compiler)
		Self.compiler = compiler
		currentIndex = 0	'We're adding the GLOBAL scope!
		dataScopes = New List<CompilerDataScope>
	End
	
	#rem
		summary: Adds a new nest data scope, where variables can be created.
	#end
	Method AddDataScope()'compiler:Compiler)
		Local cds:=New CompilerDataScope
		dataScopes.AddLast(cds)
		currentIndex+=1
		
		'We add the required assembler here, and store the scope TOKEN so we can go back to it when closing the DataScope
		cds.newScopeToToken = compiler.generatedAsm.AddInstruction(AssemblerObj.SET_NEWSCOPE)
		
	End
	
	#rem
		summary: closes current compiler data scope, and writes the required assembler code. It also removes the scope from the stack.
	#end
	Method CloseDataScope:CompilerDataScope()
		WriteInConsole "Getting node:"
		Local currentDataScope:CompilerDataScope = dataScopes.RemoveLast()
		Local currentNode:list.Node < String >= currentDataScope.newScopeToToken
		
		if currentDataScope.variables.IsEmpty and currentIndex > 0 Then
			'We do not allocate empty scopes, to avoid extra allocation of data, except on empty global zone.
			compiler.generatedAsm.AddInstruction (currentNode, AssemblerObj.SET_EMPTYSCOPE)
			compiler.generatedAsm.AddInstruction(AssemblerObj.EXIT_SCOPE)
			currentNode.Remove()
			Return currentDataScope
		else
	
			For Local v:CompVariable = eachin currentDataScope.variables.Values
	
				Local node:list.Node < String >
				
				Select v.Kind
	
					Case CompVariable.vARRAY
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.ARRAYVAR)
	
					Case CompVariable.vBOOL
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.BOOLVAR)
	
					Case CompVariable.vFLOAT
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.FLOATVAR)
	
					Case CompVariable.vINT
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.INTVAR)
	
					Case CompVariable.vOBJ
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.OBJVAR)
	
					Case CompVariable.vSTRING				
						node = compiler.generatedAsm.AddParameter(currentNode, expKinds.STRINGVAR)
	
				End Select
	
				node = compiler.generatedAsm.AddParameter(node, v.Name)
	
			Next
			compiler.generatedAsm.AddInstruction(AssemblerObj.EXIT_SCOPE)
			currentIndex -= 1
			Return currentDataScope
		EndIf
		
	End
	
	#rem
		summary: Adds a vaariable to the latest item to the compiler variable stack. If no scpeficic stack has been declared, the variable is stored in the global scope.
	#end
	Method AddVariable:Bool(compiler:Compiler, varName:Token, varKind:Int)
		Local scope:CompilerDataScope = dataScopes.Last()
		return scope.AddVariable(compiler, varName, varKind)
	End
	
	#rem
		summary: This function returns TRUE if a variable with a given name exists on the comple CompilerDataScopeStack.
	#end
	Method VariableExists:Bool(varname:String)
		For Local s:CompilerDataScope = EachIn self.dataScopes 
			if s.variables.Contains(varname) Return true
		Next
		Return false
	End
	
	#rem
		summary: This function finds a variable in the complete CompilerDataScopeStack and also returns the offset from current scope where the variable is found.
		If the variable is found on the global scope (0), then the scope is marked as -1 to avoid problems on functions calling functions.
	#end
	Method FindVariable:CompVariable(name:String, nestNum:IntByRef)
		Local var:CompVariable, counter:Int = 0, lastIndex:Int = -1000
		For Local s:CompilerDataScope = EachIn self.dataScopes 
			if s.variables.Contains(name) Then 	
				var = s.variables.ValueForKey(name)
				lastIndex = counter
			endif
			counter +=1
		Next
		if nestNum <>null Then 
			
			nestNum.value = currentIndex - lastIndex 
			'If we rest as many items ans available, we're in the global scope:
			if nestNum.value = currentIndex then nestNum.value = -1
		endif
		Return var
	End
End
