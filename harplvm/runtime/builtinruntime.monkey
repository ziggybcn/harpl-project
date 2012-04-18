Import Harpl
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
				Print "Printing var: " + dynamicScope.Strings[varNum];
				bco.pos +=1	'We end in the next sentence.
		End select 
	End  	
End

Class Set_NewScope extends HarplFunction
	Method Run:void(vm:Hvm, bco:ByteCodeObj)
		Print "allocating new scope!"
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
				End
			Case expKinds.BC_ARRAYVAR 
				Error("Pending arrays implementation");
				
			Case expKinds.BC_BOOLVAR 'He de asignar una variable boolean a otra variable
				bco.pos+=1; Local boolVarIndex:int = bco.code[bco.pos]
				bco.pos+=1; Local boolVarScope:int = bco.code[bco.pos]
				Local SourceScope:DynamicDataScope = vm.dataScope.GetdynamicScope(boolVarScope)
				Select varType
					Case expKinds.BC_FLOATVAR 'Asignar una variable bool a un float
						Local value:Float = 0
						if SourceScope.Booleans[boolVarIndex] Then value = 1
						dynamicScope.Floats[varNum] = value 
					Case expKinds.BC_INTVAR   'Asignar una variable bool a un int
						Local value:Int = 0
						if SourceScope.Booleans[boolVarIndex] Then value = 1
						dynamicScope.Ints[varNum] = value 
					Case expKinds.BC_STRINGVAR 
						Error("Can't convert from Bool to String.")
					Case expKinds.BC_OBJVAR 
						Error("Can't convert from Bool to object")
					Case expKinds.BC_BOOLVAR 
						dynamicScope.Booleans[varNum] = SourceScope.Booleans[boolVarIndex]
					
					
				End
		End
		bco.pos+=1 'We end in the next sentence.
	End
End