Import Harpl
'Import reflection
Class CompilerDataScope
	'Null for entry-point scopes such as object-less Functions
	Field parentScope:CompilerDataScope	
	
	Field variables:=New StringMap< CompVariable>
	
	Method AddVariable:Bool(compiler:Compiler,name:Token,Kind:Int)
		if variables.Contains(name.text)
			compiler.AddError("Duplicate variable definition: " + name.text,name.sourceFile, name.docX, name.docY)
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
	
	Field Name:String
	Field Kind:Int
End