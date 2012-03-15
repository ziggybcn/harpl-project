Import Harpl
'Import reflection

#Rem
	This class should manage any Compiler Data Scope. Adding new subscopes.
#end
Class CompilerScopeStack

	Field dataScopes:List<CompilerDataScope>
	Field currentIndex:Int = 0
	
	Field compiler:Compiler
	
	Method New()
		Error("Need to use overload with parameter.")
	End
	
	Method New(compiler:Compiler)
		Self.compiler = compiler
		currentIndex = 0	'We're adding the GLOBAL scope!
		dataScopes = New List<CompilerDataScope>
		Local cds:=New CompilerDataScope
		dataScopes.AddLast(cds)
	End
	
	Method AddDataScope(compiler:Compiler)
		Local cds:=New CompilerDataScope
		dataScopes.AddLast(cds)
		currentIndex+=1
		
		'We add the required assembler here, and store the scope TOKEN so we can go back to it when closing the DataScope
		
	End
	Method CloseDataScope()
		'We should go back to the opener token (into the generated assembler) to add the variable names and types in the scope creation routine
		dataScopes.RemoveLast()
		currentIndex-=1	
	End
	
	Method AddVariable:Bool(compiler:Compiler, varName:Token, varKind:Int)
		Local scope:CompilerDataScope = dataScopes.Last()
		return scope.AddVariable(compiler, varName, varKind)
	End
	
	Method VariableExists:Bool(varname:String)
		For Local s:CompilerDataScope = EachIn self.dataScopes 
			if s.variables.Contains(varname) Return true
		Next
		Return false
	End
	
	Method FindVariable:CompVariable(name:String, nestNum:ByRefInt)
		Local var:CompVariable, counter:Int = 0, lastIndex:Int = -1000
		For Local s:CompilerDataScope = EachIn self.dataScopes 
			if s.variables.Contains(name) Then 	
				var = s.variables.ValueForKey(name)
				lastIndex = counter
			endif
			counter +=1
		Next
		if nestNum <>null Then nestNum.value = lastIndex
		Return var
	End
End

Class CompilerDataScope
	
	Field variables:=New StringMap< CompVariable>
	
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

Class CompVariable 
	Const vINT:Int = 1
	Const vSTRING:Int = 2
	Const vFLOAT:Int = 4
	Const vBOOL:Int = 8
	Const vOBJ:Int = 16
	Const vARRAY:Int = 32

	Field isBeingUsed:Bool = false
	
	Field Name:String
	Field Kind:Int
End
