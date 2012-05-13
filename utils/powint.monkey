Function PowInt:Int(base:Int, exp:Int)
	if exp<0 Then Return 0
	Select exp
		Case 0
			Return 1
		Case 1
			Return base 
		Case 2
			Return base*base
		Case 3
			Return base*base*base
		Case 4
			Return base*base*base*base
		Case 5
			Return base*base*base*base*base
		default
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
End