Import Harpl
Import compvariable

#Rem
	summary: This class represent a compiler data scope. A variables declaration level. 
#End
Class CompilerDataScope
	
	#Rem
		summary: This is the list of generated variables. 
	#End
	Field variables := New StringMap < CompVariable >
	
	Field newScopeToToken:list.Node < String >
	
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

