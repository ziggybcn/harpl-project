'Import Harpl
Method Run:Void(vm:Hvm,bco:ByteCodeObj)

Local Bool1:Bool, Int1:Int, Float1:Float, String1:String, opKind1:Int
'Local Bool2:Bool, Int2:Int, Float2:Float, String2:String, opKind2:Int

'GET FIRST OPERATOR
'LoadTemplate ./loadoperator.Monkey, boolean=Bool1, integer=Int1, string=String1, float=Float1, virtualmachine=vm, bytecodeobj=bco, opkind=opKind1
'endtemplate	

'PERFORM OPERATION:
Select opKind1
	Case expKinds.BC_FLOATVAR 
		'loadtemplate ./unaryperformoperation.Monkey, operation={%operation%}, resultkind = Float, operator1=Float1, bytecodeobj=bco, virtualmachine=vm
		'endtemplate
	Case expKinds.BC_INTVAR
		'loadtemplate ./unaryperformoperation.Monkey, operation={%operation%}, resultkind = Int, operator1=Int1, bytecodeobj=bco, virtualmachine=vm
		'endtemplate	
	Default
		Error("Invalid data type for arithmetic operation.")
	
End Select
bco.pos+=1
End