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
if opKind1 = expKinds.BC_FLOATVAR 
	if opKind2 = expKinds.BC_FLOATVAR 
		'loadtemplate ./numericperformoperation.Monkey, operation={%operation%}, resultkind = Float, operator1=Float1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_INTVAR
		'loadtemplate ./numericperformoperation.Monkey, operation={%operation%}, resultkind = Float, operator1=Float1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	endif
ElseIf opKind1 = expKinds.BC_INTVAR
	if opKind2 = expKinds.BC_FLOATVAR 
		'loadtemplate ./numericperformoperation.Monkey, operation={%operation%}, resultkind = Float, operator1=Int1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_INTVAR
		'loadtemplate ./numericperformoperation.Monkey, operation={%operation%}, resultkind = Int, operator1=Int1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	endif
Else
	Error("Invalid data type for arithmetic operation.")
EndIf
bco.pos+=1
End
