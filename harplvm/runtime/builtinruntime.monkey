Import Harpl
Import binaryops

Class IO_Output Extends HarplFunction 
	Method Run:Void(vm:Hvm,bco:ByteCodeObj )
		bco.pos+=1	'We get the Variable KIND
		Select bco.code[bco.pos] 
			Case expKinds.BC_STRINGLITERAL 
				Print bco.literals[bco.code[bco.pos+1]]
				bco.pos+=1 'We consume the literal pointer
				bco.pos+=1 'We end in the next sentence
				
			Case expKinds.BC_INTPREFIX 
				Print bco.code[bco.pos+1]
				bco.pos+=1 'We consume the literal pointer
				bco.pos+=1 'We end in the next sentence
				
			Case expKinds.BC_FLOATPREFIX 
				Print bco.floats[bco.code[bco.pos+1]]
				bco.pos+=1 'We consume the literal pointer
				bco.pos+=1 'We end in the next sentence
				
			Case expKinds.BC_STRINGVAR 
				'Var number:
				bco.pos+=1;	Local varNum:Int = bco.code[bco.pos]
				'Var scope:
				bco.pos+=1; Local scopeIndex:Int = bco.code[bco.pos]
				Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeIndex)
				Print dynamicScope.Strings[varNum];
				bco.pos +=1	'We end in the next sentence.

			Case expKinds.BC_FLOATVAR 
				'Var number:
				bco.pos+=1;	Local varNum:Int = bco.code[bco.pos]
				'Var scope:
				bco.pos+=1; Local scopeIndex:Int = bco.code[bco.pos]
				Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeIndex)
				Print dynamicScope.Floats[varNum];
				bco.pos +=1	'We end in the next sentence.

			Case expKinds.BC_INTVAR 
				'Var number:
				bco.pos+=1;	Local varNum:Int = bco.code[bco.pos]
				'Var scope:
				bco.pos+=1; Local scopeIndex:Int = bco.code[bco.pos]
				Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeIndex)
				Print dynamicScope.Ints[varNum];
				bco.pos +=1	'We end in the next sentence.

			Case expKinds.BC_BOOLVAR
				'Var number:
				'bco.pos+=1;	Local varNum:Int = bco.code[bco.pos]
				'Var scope:
				'bco.pos+=1; Local scopeIndex:Int = bco.code[bco.pos]
				'Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(scopeIndex)
				'Local value:Bool = dynamicScope.Booleans[varNum];
				'if value Print "True" Else Print "False"
				'bco.pos +=1	'We end in the next sentence.
				Error("Can't convert from Boolean to string")
				
			Case expKinds.BC_ARRAYVAR 
				Error("Can't output an array")

			Case expKinds.BC_ERRORUNKNOWNVAR 
				Error("Unknown bar reached bytecode!")

			Case expKinds.BC_OBJVAR 
				Error("Objects not implemented by I'm pretty sure they won't be compatible with output without a string conversion or the like.")

			Case expKinds.BC_TMPBOOL 
				'Var number:
				'bco.pos+=1;	Local varNum:Int = bco.code[bco.pos]
				'Local value:Bool = vm.tmpBool[varNum];
				'if value Print "True" else Print "False"
				'bco.pos +=1	'We end in the next sentence.
				Error("Can't convert from Boolean to String")
				
			Case expKinds.BC_TMPFLOAT 
				bco.pos+=1;	Print vm.tmpFloat[bco.code[bco.pos]]
				bco.pos +=1	'We end in the next sentence.
			
			Case expKinds.BC_TMPINTEGER 
				bco.pos+=1;	Print vm.tmpInt[bco.code[bco.pos]]
				bco.pos +=1	'We end in the next sentence.

			Case expKinds.TMPSTRING 
				bco.pos+=1;	Print vm.tmpStrings[bco.code[bco.pos]]
				bco.pos +=1	'We end in the next sentence.

			Default
				Error("Unknown output data kind requested.")

		End select 
	End  	
End

Class Set_NewScope extends HarplFunction
	Method Run:void(vm:Hvm, bco:ByteCodeObj)
		WriteInConsole "allocating new scope!"
		bco.pos+=1; Local ints:Int = bco.code[bco.pos];
		bco.pos+=1; local strings:Int = bco.code[bco.pos];
		bco.pos+=1; local booleans:Int = bco.code[bco.pos];
		bco.pos+=1; local floats:Int = bco.code[bco.pos];
		bco.pos+=1; local arrays:Int = bco.code[bco.pos];
		bco.pos+=1; local objects:int = bco.code[bco.pos];
		vm.dataScope.AddScope(ints,strings,floats,booleans,arrays,objects)
		bco.pos+=1	'We end in the next sentence
		'Print "Next sentence is:" + bco.code[bco.pos] + " at position " + bco.pos
	End
End

Class Set_SetVar extends HarplFunction
	Method Run:void(vm:Hvm, bco:ByteCodeObj)
		bco.pos+=1; Local varType:int = bco.code[bco.pos]
		bco.pos+=1; Local varNum:int = bco.code[bco.pos]
		bco.pos+=1; Local varScope:int = bco.code[bco.pos]
		Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(varScope)
		bco.pos+=1; Local valueKind:int = bco.code[bco.pos]
		Select valueKind
			Case expKinds.BC_STRINGLITERAL 
				bco.pos+=1; Local literalIndex:int = bco.code[bco.pos]
				Select varType
					Case expKinds.BC_STRINGVAR 
						dynamicScope.Strings[varNum] = bco.literals[literalIndex];
					Default
						Error("Can't convert a string literal to a non string data kind.")
				End
			Case expKinds.BC_ARRAYVAR 
				Error("Arrays not implemented");
				
			Case expKinds.BC_BOOLVAR 'He de asignar una variable boolean a otra variable
				Select varType
					Case expKinds.BC_FLOATVAR 'Asignar una variable bool a un float
						Error("Can't convert Bool to Float.")
					Case expKinds.BC_INTVAR   'Asignar una variable bool a un int
						Error("Can't convert Bool to Int.")
					Case expKinds.BC_STRINGVAR 
						Error("Can't convert from Bool to String.")
					Case expKinds.BC_OBJVAR 
						Error("Can't convert from Bool to object")
					Case expKinds.BC_BOOLVAR 
						bco.pos+=1; Local boolVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local boolVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(boolVarScope)
						dynamicScope.Booleans[varNum] = SourceScope.Booleans[boolVarIndex]
				End
			Case expKinds.BC_ERRORUNKNOWNVAR 
				Error("Unknown data kind reached the generated bytecode.")
				
			Case expKinds.BC_FLOATPREFIX 
				bco.pos+=1; Local literalIndex:int = bco.code[bco.pos]
				Select varType
					Case expKinds.BC_STRINGVAR 
						dynamicScope.Strings[varNum] = bco.floats[literalIndex];
					Case expKinds.BC_BOOLVAR 
						Error("Can't convert a float value to a boolean value.");
					Case expKinds.BC_FLOATVAR 
						dynamicScope.Floats[varNum] = bco.floats[literalIndex];
					Case expKinds.BC_INTVAR 
						dynamicScope.Ints[varNum] = bco.floats[literalIndex];
					Case expKinds.BC_ARRAYVAR 
						Error("Arrays not implemented")
					Case expKinds.BC_OBJVAR 
						Error("can't convert from float identifier to an object.")
				End
				
			Case expKinds.BC_FLOATVAR 
				Select varType

					Case expKinds.BC_FLOATVAR 'Asignar una variable Float a una float
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Floats[varNum] = SourceScope.Floats[floatVarIndex]

					Case expKinds.BC_INTVAR   'Asignar una variable Float a una variable int
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Ints[varNum] = SourceScope.Floats[floatVarIndex]
						
					Case expKinds.BC_STRINGVAR 'Asignar una variable FLOAT a una variable String
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Strings[varNum] = SourceScope.Floats[floatVarIndex]

					Case expKinds.BC_OBJVAR 
						Error("Can't convert from Float to object")
						
					Case expKinds.BC_BOOLVAR 'Asignar una variable Float a una variable Bool
						Error("Can't convert from float to bool")
					
					Case expKinds.ARRAYVAR 
						Error("Arrays not implemented.")
						
				End
				
			Case expKinds.BC_INTPREFIX 
				bco.pos+=1; Local number:int = bco.code[bco.pos]
				Select varType
					Case expKinds.BC_STRINGVAR 
						dynamicScope.Strings[varNum] = number;
					Case expKinds.BC_BOOLVAR 
						Error("Can't convert a Integer value to a Boolean value.");
					Case expKinds.BC_FLOATVAR 
						dynamicScope.Floats[varNum] = number
					Case expKinds.BC_INTVAR 
						dynamicScope.Ints[varNum] = number;
					Case expKinds.BC_ARRAYVAR 
						Error("Arrays not implemented")
					Case expKinds.BC_OBJVAR 
						Error("can't convert from float identifier to an object.")
				End

			Case expKinds.BC_INTVAR 
			
				Select varType

					Case expKinds.BC_FLOATVAR 'Asignar una variable Int a una float
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Floats[varNum] = SourceScope.Ints[floatVarIndex]

					Case expKinds.BC_INTVAR   'Asignar una variable Int a una variable int
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Ints[varNum] = SourceScope.Ints[floatVarIndex]
						
					Case expKinds.BC_STRINGVAR 'Asignar una variable Int a una variable String
						bco.pos+=1; Local floatVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local floatVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(floatVarScope)
						dynamicScope.Strings[varNum] = SourceScope.Ints[floatVarIndex]

					Case expKinds.BC_OBJVAR 
						Error("Can't convert from Int to object")
						
					Case expKinds.BC_BOOLVAR 'Asignar una variable Float a una variable Bool
						Error("Can't convert from Int to Boolean")
					
					Case expKinds.ARRAYVAR 
						Error("Arrays not implemented.")
				End
			
			Case expKinds.BC_OBJVAR 
				Error("Objects not implemented.")
			Case expKinds.BC_STRINGVAR 
				Select varType
				
					Case expKinds.BC_FLOATVAR 'Asignar una variable String a una float
						Error("Can't convert from String to float")
						
					Case expKinds.BC_INTVAR   'Asignar una variable String a una variable int
						Error("Can't convert from String to float")
						
					Case expKinds.BC_STRINGVAR 'Asignar una variable String a una variable String
						bco.pos+=1; Local stringVarIndex:int = bco.code[bco.pos]
						bco.pos+=1; Local stringVarScope:int = bco.code[bco.pos]
						Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(stringVarScope)
						dynamicScope.Strings[varNum] = SourceScope.Strings[stringVarIndex]

					Case expKinds.BC_OBJVAR 
						Error("Can't convert from String to object")
						
					Case expKinds.BC_BOOLVAR 'Asignar una variable Float a una variable Bool
						Error("Can't convert from String to Boolean")
					
					Case expKinds.ARRAYVAR 
						Error("Arrays not implemented.")
				End
			
			Case expKinds.BC_TMPBOOL 
			Case expKinds.BC_TMPFLOAT 
			Case expKinds.BC_TMPINTEGER 
			Case expKinds.BC_TMPSTRING 

		End
		bco.pos+=1 'We end in the next sentence.
	End
End

Class Set_DefVar extends HarplFunction 
	Method Run:void(vm:Hvm, bco:ByteCodeObj)
			bco.pos+=1; Local varType:int = bco.code[bco.pos]
			bco.pos+=1; Local varNum:int = bco.code[bco.pos]
			bco.pos+=1; Local varScope:int = bco.code[bco.pos]
			Local dynamicScope:DynamicDataScope = vm.dataScope.GetdynamicScope(varScope)
			Select varType
				Case expKinds.BC_ARRAYVAR 
					Error("Arrays not implemented!")
				Case expKinds.BC_BOOLVAR 
					dynamicScope.Booleans[varNum] = False;
				Case expKinds.BC_FLOATVAR 
					dynamicScope.Floats[varNum] = 0.0
				Case expKinds.BC_INTVAR 
					dynamicScope.Floats[varNum] = 0
				Case expKinds.BC_OBJVAR 
					dynamicScope.Floats[varNum] = 0 'This is the Null object
				Case expKinds.BC_STRINGVAR 
					dynamicScope.Strings[varNum] = ""
				Default
					Error("Unkown variable kind on DEF_VAR");
			End
			bco.pos+=1; 'We leave it in the next sentece
	End	
End