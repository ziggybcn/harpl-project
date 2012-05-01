Import Harpl

Class MAJOR_EQUAL extends HarplFunction
	'loadtemplate ./Templates/booleanassembleroperation.monkey,operation= >=
	'#Region Code generated by the Harpl-Monkey template. Loaded from: ./Templates/booleanassembleroperation.monkey
	Method Run:Void(vm:Hvm,bco:ByteCodeObj)
	
	Local Bool1:Bool, Int1:Int, Float1:Float, String1:String, opKind1:Int
	Local Bool2:Bool, Int2:Int, Float2:Float, String2:String, opKind2:Int
	
	'GET FIRST OPERATOR
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool1, integer=Int1, string=String1, float=Float1, virtualmachine=vm, bytecodeobj=bco, opkind=opKind1
	If true	'Scope generated to avoid LOCALs clash.
		bco.pos+=1; 
		Local varKind:Int = bco.code[bco.pos]
		Select varKind
			Case expKinds.BC_ARRAYVAR
				Error("Arrays are not implemented")
			Case expKinds.BC_BOOLVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Bool1, datasource=Booleans, opkind = opKind1, opvalue = expKinds.BC_BOOLVAR 
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Bool1 = localScope.Booleans[varNum]
				opKind1 = expKinds.BC_BOOLVAR
				'endtemplate
			Case expKinds.BC_ERRORUNKNOWNVAR 
				Error("Unknown var accessed binary operator!")
			Case expKinds.BC_FLOATPREFIX 
				bco.pos+=1; Float1 = bco.floats[bco.code[bco.pos]];
				opKind1 = expKinds.BC_FLOATVAR 
			Case expKinds.BC_FLOATVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Float1, datasource=Floats, opkind = opKind1, opvalue = expKinds.BC_FLOATVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Float1 = localScope.Floats[varNum]
				opKind1 = expKinds.BC_FLOATVAR
				'endtemplate
			Case expKinds.BC_INTPREFIX
				bco.pos+=1; Int1 = bco.code[bco.pos];
				opKind1 = expKinds.BC_INTVAR
		
			Case expKinds.BC_INTVAR 
				Local Result:Int 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Int1, datasource=Ints, opkind = opKind1, opvalue = expKinds.BC_INTVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Int1 = localScope.Ints[varNum]
				opKind1 = expKinds.BC_INTVAR
				'endtemplate
			Case expKinds.BC_OBJVAR 
				Error("Object address can't be used as part of an arithmetic expression.")
			Case expKinds.BC_STRINGLITERAL 
				bco.pos+=1; String1 = bco.literals[bco.code[bco.pos]];
				opKind1 = expKinds.BC_STRINGVAR
				
			Case expKinds.BC_STRINGVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=String1, datasource=Strings, opkind = opKind1, opvalue = expKinds.BC_STRINGVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				String1 = localScope.Strings[varNum]
				opKind1 = expKinds.BC_STRINGVAR
	 			'endtemplate 
			Case expKinds.BC_TMPBOOL
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Bool1, source=tmpBool, opkind = opKind1, opvalue = expKinds.BC_BOOLVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Bool1 = vm.tmpBool[varNum]
				opKind1 = expKinds.BC_BOOLVAR
				'endtemplate
			Case expKinds.BC_TMPFLOAT 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Float1, source=tmpFloat, opkind = opKind1, opvalue = expKinds.BC_FLOATVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Float1 = vm.tmpFloat[varNum]
				opKind1 = expKinds.BC_FLOATVAR
				'endtemplate
			Case expKinds.BC_TMPINTEGER 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Int1, source=tmpInt, opkind = opKind1, opvalue = expKinds.BC_INTVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Int1 = vm.tmpInt[varNum]
				opKind1 = expKinds.BC_INTVAR
				'endtemplate
			Case expKinds.BC_TMPSTRING 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = String1, source=tmpStrings, opkind = opKind1, opvalue = expKinds.BC_STRINGVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				String1 = vm.tmpStrings[varNum]
				opKind1 = expKinds.BC_STRINGVAR
				'endtemplate
			Default 
				Error("Unknown operator!!")
		End
	EndIf
	'endtemplate	
	
	'GET SECOND OPERATOR:
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool2, integer=Int2, string=String2, float=Float2, virtualmachine=vm, bytecodeobj=bco, opkind=opKind2
	If true	'Scope generated to avoid LOCALs clash.
		bco.pos+=1; 
		Local varKind:Int = bco.code[bco.pos]
		Select varKind
			Case expKinds.BC_ARRAYVAR
				Error("Arrays are not implemented")
			Case expKinds.BC_BOOLVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Bool2, datasource=Booleans, opkind = opKind2, opvalue = expKinds.BC_BOOLVAR 
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Bool2 = localScope.Booleans[varNum]
				opKind2 = expKinds.BC_BOOLVAR
				'endtemplate
			Case expKinds.BC_ERRORUNKNOWNVAR 
				Error("Unknown var accessed binary operator!")
			Case expKinds.BC_FLOATPREFIX 
				bco.pos+=1; Float2 = bco.floats[bco.code[bco.pos]];
				opKind2 = expKinds.BC_FLOATVAR 
			Case expKinds.BC_FLOATVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Float2, datasource=Floats, opkind = opKind2, opvalue = expKinds.BC_FLOATVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Float2 = localScope.Floats[varNum]
				opKind2 = expKinds.BC_FLOATVAR
				'endtemplate
			Case expKinds.BC_INTPREFIX
				bco.pos+=1; Int2 = bco.code[bco.pos];
				opKind2 = expKinds.BC_INTVAR
		
			Case expKinds.BC_INTVAR 
				Local Result:Int 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=Int2, datasource=Ints, opkind = opKind2, opvalue = expKinds.BC_INTVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				Int2 = localScope.Ints[varNum]
				opKind2 = expKinds.BC_INTVAR
				'endtemplate
			Case expKinds.BC_OBJVAR 
				Error("Object address can't be used as part of an arithmetic expression.")
			Case expKinds.BC_STRINGLITERAL 
				bco.pos+=1; String2 = bco.literals[bco.code[bco.pos]];
				opKind2 = expKinds.BC_STRINGVAR
				
			Case expKinds.BC_STRINGVAR 
				'LOADTEMPLATE ./accessvar.Monkey,bytecode=bco, virtualmachine = vm, result=String2, datasource=Strings, opkind = opKind2, opvalue = expKinds.BC_STRINGVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
				Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
				String2 = localScope.Strings[varNum]
				opKind2 = expKinds.BC_STRINGVAR
	 			'endtemplate 
			Case expKinds.BC_TMPBOOL
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Bool2, source=tmpBool, opkind = opKind2, opvalue = expKinds.BC_BOOLVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Bool2 = vm.tmpBool[varNum]
				opKind2 = expKinds.BC_BOOLVAR
				'endtemplate
			Case expKinds.BC_TMPFLOAT 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Float2, source=tmpFloat, opkind = opKind2, opvalue = expKinds.BC_FLOATVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Float2 = vm.tmpFloat[varNum]
				opKind2 = expKinds.BC_FLOATVAR
				'endtemplate
			Case expKinds.BC_TMPINTEGER 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = Int2, source=tmpInt, opkind = opKind2, opvalue = expKinds.BC_INTVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				Int2 = vm.tmpInt[varNum]
				opKind2 = expKinds.BC_INTVAR
				'endtemplate
			Case expKinds.BC_TMPSTRING 
				'LoadTemplate ./accestmp.Monkey, bytecode=bco, virtualmachine = vm, result = String2, source=tmpStrings, opkind = opKind2, opvalue = expKinds.BC_STRINGVAR
				bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
				String2 = vm.tmpStrings[varNum]
				opKind2 = expKinds.BC_STRINGVAR
				'endtemplate
			Default 
				Error("Unknown operator!!")
		End
	EndIf
	'endtemplate	
	
	'PERFORM OPERATION:
	
	if opKind1 = opKind2 Then
		'We compare data of the same kind:
		Select opKind1
			Case expKinds.BC_ARRAYVAR 
				Error("Arrays not yet implemented")
			Case expKinds.BC_BOOLVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Bool1, operator2=Bool2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Bool1 {%operation%} Bool2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			Case expKinds.BC_ERRORUNKNOWNVAR 
				Error("Unknown var reached bytecode!")
			Case expKinds.BC_INTVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Int1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Int1 {%operation%} Int2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate		
			Case expKinds.BC_FLOATVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Float1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Float1 {%operation%} Float2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			Case expKinds.BC_STRINGVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=String1, operator2=String2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = String1 {%operation%} String2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
		End Select
		
	Else
		'We comapare data of different kind, we only allow numeric comparisons
		if opKind1 = expKinds.BC_FLOATVAR 
			if opKind2 = expKinds.BC_FLOATVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Float1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Float1 {%operation%} Float2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			ElseIf opKind2 = expKinds.BC_INTVAR
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Float1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Float1 {%operation%} Int2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			Else
				Error ("Can't compare imcompatible data types.")
			endif
		ElseIf opKind1 = expKinds.BC_INTVAR
			if opKind2 = expKinds.BC_FLOATVAR 
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Int1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Int1 {%operation%} Float2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			ElseIf opKind2 = expKinds.BC_INTVAR
				'loadtemplate ./booleanperformoperation.Monkey, operation={%operation%}, operator1=Int1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
				local result:Bool = Int1 {%operation%} Int2
				bco.pos+=1; Local varKind:Int = bco.code[bco.pos]
				Select varKind
					Case expKinds.BC_ARRAYVAR 
						Error("Can't convert from Boolean to array")
					Case expKinds.BC_BOOLVAR 
						'LoadTemplate ./settovar.monkey, bytecode=bco, virtualmachine=vm, result= result, datasource=Booleans
						bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						bco.pos+=1; Local scopeNum:Int = bco.code[bco.pos]
						Local localScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeNum)
						localScope.Booleans[varNum] = result
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
						 'LoadTemplate ./settotmp.monkey, bytecode=bco, virtualmachine=vm, result= result, source=tmpBool
						 bco.pos+=1; Local varNum:Int = bco.code[bco.pos]
						 vm.tmpBool[varNum] = result 
						 'endtemplate
					Case expKinds.BC_TMPFLOAT 
						Error("Can't convert from Boolean to Float")
					Case expKinds.BC_TMPINTEGER 
						Error("Can't convert from Boolean to Integer")
					Case expKinds.BC_TMPSTRING 
						Error("Can't convert from Boolean to String")
				End select
				'endtemplate
			Else
				Error ("Can't compare imcompatible data types.")
			endif
		Else
			Error("Invalid data type for comparison operation.")
		EndIf
	endif
	bco.pos+=1
	End
	
	'#End Region
	'endtemplate
End Class
 