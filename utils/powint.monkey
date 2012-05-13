Function PowInt:Int(value1:Int, value2:Int)
	Local result:Int
	if value2>0 Then
		result = value1
		For Local i:Int = 2 to value2
			result*=result
		Next
		Return result
	ElseIf value2 = 0 Then Return 1
	
	Else
		Return 0
	EndIf
End