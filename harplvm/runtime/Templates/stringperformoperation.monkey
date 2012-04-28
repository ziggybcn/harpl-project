
local result:String = {%operator1%} {%operation%} {%operator2%}
{%bytecodeobj%}.pos+=1; Local varKind:Int = {%bytecodeobj%}.code[{%bytecodeobj%}.pos]
Select varKind
	Case expKinds.BC_ARRAYVAR 
		Error("Can't convert from Array to Float")
	Case expKinds.BC_BOOLVAR 
		Error("Can't convert from Bool to Float")
	Case expKinds.BC_FLOATVAR 
		Error("Can't convert from String to Float")
	Case expKinds.BC_INTVAR 
		Error("Can't convert from String to Int")
	Case expKinds.BC_OBJVAR 
		Error("Can't convert from String to Object")
	Case expKinds.BC_STRINGVAR 
		'LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Strings
		'endtemplate
	Case expKinds.BC_TMPBOOL
		Error("Can't convert from Bool to Float")
	Case expKinds.BC_TMPFLOAT 
		Error("Can't convert from String to Float")
	Case expKinds.BC_TMPINTEGER 
		Error("Can't convert from String to Integer")
	Case expKinds.BC_TMPSTRING 
		 'LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpStrings
		 'endtemplate
End select