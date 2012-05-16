local result:Bool = (Int({%operator1%}) {%operation%} Int({%operator2%}))<>0
{%bytecodeobj%}.pos+=1; Local varKind:Int = {%bytecodeobj%}.code[{%bytecodeobj%}.pos]
Select varKind
	Case expKinds.BC_ARRAYVAR 
		'Error("Can't convert from Array to {%resultkind%}")
	Case expKinds.BC_BOOLVAR 
		'LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Booleans
		'endtemplate
	Case expKinds.BC_FLOATVAR 
		''LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Floats
		''endtemplate
	Case expKinds.BC_INTVAR 
		''LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Ints
		''endtemplate
	Case expKinds.BC_OBJVAR 
		'Error("Can't set from Object to {%resultkind%}")
	Case expKinds.BC_STRINGVAR 
		''LoadTemplate ./settovar.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, datasource=Strings
		''endtemplate
	Case expKinds.BC_TMPBOOL
		'LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpBool
		'endtemplate
	Case expKinds.BC_TMPFLOAT 
		 ''LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpFloat
		 ''endtemplate
	Case expKinds.BC_TMPINTEGER 
		 ''LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpInt
		 ''endtemplate
	Case expKinds.BC_TMPSTRING 
		 ''LoadTemplate ./settotmp.monkey, bytecode={%bytecodeobj%}, virtualmachine={%virtualmachine%}, result= result, source=tmpStrings
		 ''endtemplate
End select