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
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Float1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_INTVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Float1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_STRINGVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Float1, operator2=String2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	Else
		Error("Wrong data type for String operation.")
	
	endif
ElseIf opKind1 = expKinds.BC_INTVAR
	if opKind2 = expKinds.BC_FLOATVAR 
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Int1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_INTVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Int1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_STRINGVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=Int1, operator2=String2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	Else
		Error("Wrong data type for String operation.")
	endif
ElseIf opKind1 = expKinds.BC_STRINGVAR
	if opKind2 = expKinds.BC_FLOATVAR 
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=String1, operator2=Float2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_INTVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=String1, operator2=Int2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	ElseIf opKind2 = expKinds.BC_STRINGVAR
		'loadtemplate ./stringperformoperation.Monkey, operation={%operation%}, resultkind = String, operator1=String1, operator2=String2, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	Else
		Error("Wrong data type for String operation.")
	endif

Else
	Error("Invalid data type for string operation.")
EndIf
bco.pos+=1
End