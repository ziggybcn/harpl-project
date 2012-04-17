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
			
		End select 
	End  	
End