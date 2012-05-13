Function PowInt:Int(base:Int, exp:Int)
	if exp<0 Then Return 0
	Local result:Int = 1
	While exp
		If exp & 1
			result *= base
		End
		exp Shr= 1
		base *= base
	Wend
	Return result
End