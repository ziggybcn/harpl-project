Import utils.byref 
Class AssemblerScope
	Field stringVars:StringMap<byref.IntByRef>
	Field intVars:StringMap<byref.IntByRef>
	Field floatVars:StringMap<byref.IntByRef>
	Field booleanVars:StringMap<byref.IntByRef>
	
	Method New()
		stringVars = New StringMap<byref.IntByRef>
		intVars = New StringMap<byref.IntByRef>
		floatVars = New StringMap<byref.IntByRef>
		booleanVars = New StringMap<byref.IntByRef>
	End
End