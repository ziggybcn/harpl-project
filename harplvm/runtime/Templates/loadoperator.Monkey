	
'GET OPERATOR: 
{%bytecodeobj%}.pos+=1; 
if true
	Local varKind:Int = {%bytecodeobj%}.code[{%bytecodeobj%}.pos]
	Select varKind
	
		Case expKinds.BC_ARRAYVAR
			Error("Arrays are not implemented")
			
		Case expKinds.BC_BOOLVAR 
			'LOADTEMPLATE ./accessvar.Monkey,bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result={%boolean%}, datasource=Booleans, opkind = {%opkind%}, opvalue = expKinds.BC_BOOLVAR 
			'endtemplate
			
		Case expKinds.BC_ERRORUNKNOWNVAR 
			Error("Unknown var accessed binary operator!")
			
		Case expKinds.BC_FLOATPREFIX 
			{%bytecodeobj%}.pos+=1; {%float%} = {%bytecodeobj%}.floats[{%bytecodeobj%}.code[{%bytecodeobj%}.pos]];
			{%opkind%} = expKinds.BC_FLOATVAR 
		Case expKinds.BC_FLOATVAR 
			'LOADTEMPLATE ./accessvar.Monkey,bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result={%boolean%}, datasource=Booleans, opkind = {%opkind%}, opvalue = expKinds.BC_FLOATVAR
			'endtemplate
			
		Case expKinds.BC_INTPREFIX
			{%bytecodeobj%}.pos+=1; {%integer%} = {%bytecodeobj%}.code[{%bytecodeobj%}.pos];			
		
		Case expKinds.BC_INTVAR 
			Local Result:Int 
			'LOADTEMPLATE ./accessvar.Monkey,bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result={%boolean%}, datasource=Booleans, opkind = {%opkind%}, opvalue = expKinds.BC_INTVAR
			'endtemplate
			
		Case expKinds.BC_OBJVAR 
			Error("Object address can't be used as part of an arithmetic expression.")
			
		Case expKinds.BC_STRINGLITERAL 
			{%bytecodeobj%}.pos+=1; {%string%} = {%bytecodeobj%}.literals[{%bytecodeobj%}.code[{%bytecodeobj%}.pos]];

		Case expKinds.BC_STRINGVAR 
			'LOADTEMPLATE ./accessvar.Monkey,bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result={%boolean%}, datasource=Booleans, opkind = {%opkind%}, opvalue = expKinds.BC_STRINGVAR
 			'endtemplate 

		Case expKinds.BC_TMPBOOL
			'LoadTemplate ./accestmp.Monkey, bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result = {%boolean%}, source=tmpBool, opkind = {%opkind%}, opvalue = expKinds.BC_TMPBOOL
			'endtemplate
		Case expKinds.BC_TMPFLOAT 
			'LoadTemplate ./accestmp.Monkey, bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result = {%float%}, source=tmpFloat, opkind = {%opkind%}, opvalue = expKinds.BC_TMPFLOAT
			'endtemplate
		Case expKinds.BC_TMPINTEGER 
			'LoadTemplate ./accestmp.Monkey, bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result = {%integer%}, source=tmpInt, opkind = {%opkind%}, opvalue = expKinds.BC_TMPINTEGER
			'endtemplate
		Case expKinds.BC_TMPSTRING 
			'LoadTemplate ./accestmp.Monkey, bytecode={%bytecodeobj%}, virtualmachine = {%virtualmachine%}, result = {%string%}, source=tmpStrings, opkind = {%opkind%}, opvalue = expKinds.BC_TMPSTRING
			'endtemplate
	End
endif