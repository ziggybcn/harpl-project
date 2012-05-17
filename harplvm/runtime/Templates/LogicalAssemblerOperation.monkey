Method Run:Void(vm:Hvm,bco:ByteCodeObj)

	Local Bool1:Bool, Int1:Int, Float1:Float, String1:String, opKind1:Int
	Local Bool2:Bool, Int2:Int, Float2:Float, String2:String, opKind2:Int
	
	'GET FIRST OPERATOR
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool1, integer=Int1, string=String1, float=Float1, virtualmachine=vm, bytecodeobj=bco, opkind=opKind1
	'endtemplate	
	
	'GET SECOND OPERATOR:
	'LoadTemplate ./loadoperator.Monkey, boolean=Bool2, integer=Int2, string=String2, float=Float2, virtualmachine=vm, bytecodeobj=bco, opkind=opKind2
	'endtemplate	

	'Convert data to booleans:
	'LoadTemplate ./ConvertAsBoolean.Monkey, opKind=opKind1, BoolVar=Bool1, FloatVar=Float1, IntVar=Int1, StringVar=String1
	'endtemplate

	'LoadTemplate ./ConvertAsBoolean.Monkey, opKind=opKind2, BoolVar=Bool2, FloatVar=Float2, IntVar=Int2, StringVar=String2
	'endtemplate

				
	'PERFORM OPERATION:
	'loadtemplate ./booleanperformoperation.monkey, operation={%operation%}, resultkind = Bool, operator1=Bool1, operator2=Bool2, bytecodeobj=bco, virtualmachine=vm
	'endtemplate
	bco.pos+=1
End