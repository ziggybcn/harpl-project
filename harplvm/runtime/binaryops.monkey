Import Harpl

Class SUB extends HarplFunction 

	Method Run:Void(vm:Hvm,bco:ByteCodeObj)
		
	'GET FIRST OPERATOR:
	bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
	Select varKind
		Case expKinds.BC_ARRAYVAR
		Case expKinds.BC_BOOLVAR 
			'LOADTEMPLATE: AccessVar datatype=Bool,datasource=Booleans
						
		Case expKinds.BC_ERRORUNKNOWNVAR 
		Case expKinds.BC_FLOATPREFIX 
		Case expKinds.BC_FLOATVAR 
		Case expKinds.BC_FLOATVAR 
		Case expKinds.BC_INTPREFIX 
		Case expKinds.BC_INTVAR 
		Case expKinds.BC_OBJVAR 
		Case expKinds.BC_STRINGLITERAL 
		Case expKinds.BC_STRINGVAR 
		Case expKinds.BC_TMPBOOL 
		Case expKinds.BC_TMPFLOAT 
		Case expKinds.BC_TMPINTEGER 
		Case expKinds.BC_TMPSTRING 
	End
	'GET SECOND OPERATOR:
	
	'GET RESULT TARGET:
	End
	
End

'Function AccessVar(vm:Hvm,bco:ByteCodeObj)
'	bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
'	bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
'	Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
'	Local Result1:{%datatype%} = localScope.{%datasource%}[varNum]
'End
