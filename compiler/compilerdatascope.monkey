Import Harpl
'Import reflection

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
		Local cds:=New CompilerDataScope
		dataScopes.AddLast(cds)
	End
	
	#rem
		summary: Adds a new nest data scope, where variables can be created.
	#end
	Method AddDataScope(compiler:Compiler)
		Local cds:=New CompilerDataScope
		dataScopes.AddLast(cds)
		currentIndex+=1
		
		'We add the required assembler here, and store the scope TOKEN so we can go back to it when closing the DataScope
		
	End
	
	#rem
		summary: closes current compiler data scope, and writes the required assembler code. It also removes the scope from the stack.
	#end
	Method CloseDataScope:compilerDataScope()
		'We should go back to the opener token (into the generated assembler) to add the variable names and types in the scope creation routine
		currentIndex-=1	
		Return dataScopes.RemoveLast()
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
			if nestNum.value =0 Then nestNum.value = -1 'GLOBAL SCOPE.
		endif
		Return var
	End
End

#Rem
	summary: This class represent a compiler data scope. A variables declaration level. 
#End
Class CompilerDataScope
	
	#Rem
		summary: This is the list of generated variables. 
	#End
	Field variables:=New StringMap< CompVariable>
	
	#Rem
		summary: This method allows you to add a variable to the CompilerDataScope. 
	#End
	Method AddVariable:Bool(compiler:Compiler,name:Token,Kind:Int)
		if variables.Contains(name.text)
			compiler.AddError("Duplicate variable definition: " + name.text, name)
			Return False
		EndIf
		
		'TODO CHECK HERE FOR LOCAL ENCLOSING BLOCKS
		
		'TODO CHECK HERE FOR GLOBAL ENCLOSING BLOCK
		Local variable:= New CompVariable
		variable.Name = name.text
		variable.Kind = Kind
		
		variables.Add(name.text,variable)
		
	End
	
		
End

#Rem
	summary: This class represents a variable in a CompilerDataScope. 
#End
Class CompVariable 
	'summary: This constant is used to identify a Integer variable
	Const vINT:Int = 1
	'summary: This constant is used to identify a String variable
	Const vSTRING:Int = 2
	'summary: This constant is used to identify a Float variable
	Const vFLOAT:Int = 4
	'summary: This constant is used to identify a Boolean variable
	Const vBOOL:Int = 8
	'summary: This constant is used to identify a Object variable
	Const vOBJ:Int = 16
	'summary: This constant is used to identify a Array variable
	Const vARRAY:Int = 32

	'summary: This flag is set to true when the variable is used into an expression on the compilation process.
	Field isBeingUsed:Bool = false
	
	'summary: This string contains the name lowercase name of this variable on source code
	Field Name:String

	'summary: This field identifies the kind of variable (using one of the already existing consts)
	Field Kind:Int
End
