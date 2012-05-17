Select {%opKind%}
	Case expKinds.BC_ARRAYVAR 
		Error("Can't convert from Array to a boolean value")
	Case expKinds.BC_BOOLVAR 
		'Nothing to convert
	Case expKinds.BC_FLOATVAR 
		{%BoolVar%} = {%FloatVar%}<>0
	Case expKinds.BC_INTVAR 
		{%BoolVar%} = {%IntVar%}<>0
	Case expKinds.BC_STRINGVAR 
		{%BoolVar%} = {%StringVar%}<>""
End Select
{%opKind%} = expKinds.BC_BOOLVAR