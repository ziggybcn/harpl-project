Method Run:Void(vm:Hvm,bco:ByteCodeObj)

	Local Bool1:Bool, Int1:Int, Float1:Float, String1:String, opKind1:Int
	Local Bool2:Bool, Int2:Int, Float2:Float, String2:String, opKind2:Int
	
	'GET FIRST OPERATOR
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool1, integer=Int1, string=String1, float=Float1, virtualmachine=vm, bytecodeobj=bco, opkind=opKind1
	'endtemplate	
	
	'GET SECOND OPERATOR:
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool2, integer=Int2, string=String2, float=Float2, virtualmachine=vm, bytecodeobj=bco, opkind=opKind2
	'endtemplate	
	
	'PERFORM OPERATION:
	If opKind1<>opKind2 or opKind1<>expKinds.BC_INTVAR Error ("Bitwise operation requires integer values.")
	'loadtemplate ./numericperformoperation.Monkey, operation={%operation%}, resultkind = Int, operator1=Int1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
	'endtemplate
	bco.pos+=1
End