local result:Bool = {%operator1%} {%operation%} {%operator2%}
{%bytecodeobj%}.pos+=1; Local varKind:Int = {%bytecodeobj%}.code[{%bytecodeobj%}.pos]
Select varKind
	Case expKinds.BC_ARRAYVAR 
		Error("Can't convert from Boolean to array")
	Case expKinds.BC_BOOLVAR 
		'LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Booleans
		'endtemplate
	Case expKinds.BC_FLOATVAR 
		Error("Can't convert from Boolean to Float")
	Case expKinds.BC_INTVAR 
		Error("Can't convert from Boolean to Integer")
	Case expKinds.BC_OBJVAR 
		Error("Can't convert from Boolean to Object")
	Case expKinds.BC_STRINGVAR 
		Error("Can't convert from Boolean to String")
	Case expKinds.BC_TMPBOOL
		 'LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpBool
		 'endtemplate
	Case expKinds.BC_TMPFLOAT 
		Error("Can't convert from Boolean to Float")
	Case expKinds.BC_TMPINTEGER 
		Error("Can't convert from Boolean to Integer")
	Case expKinds.BC_TMPSTRING 
		Error("Can't convert from Boolean to String")
End select