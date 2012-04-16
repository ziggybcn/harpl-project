Import utils.byref 
Class AssemblerScope
	Field stringVars:StringMap<byref.IntByRef>
	Field intVars:StringMap<byref.IntByRef>
	Field floatVars:StringMap<byref.IntByRef>
	Field booleanVars:StringMap<byref.IntByRef>
	Field arrayVars:StringMap<byref.IntByRef>
	Field objVars:StringMap<byref.IntByRef>
	
	Method New()
		stringVars = New StringMap<byref.IntByRef>
		intVars = New StringMap<byref.IntByRef>
		floatVars = New StringMap<byref.IntByRef>
		booleanVars = New StringMap<byref.IntByRef>
	End
	
	Method AddStringVar(Name:String)
		Local ibr:IntByRef = New IntByRef
		ibr.value = stringVars.Count-1
		stringVars.Add(Name,ibr)
	End

	Method AddIntVar(Name:String)
		Local ibr:IntByRef = New IntByRef
		ibr.value = intVars.Count-1
		intVars.Add(Name,ibr)
	End
	Method AddFloatVar(Name:String)
		Local ibr:IntByRef = New IntByRef
		ibr.value = floatVars.Count-1
		floatVars.Add(Name,ibr)
	End
	Method AddBooleanVar(Name:String)
		Local ibr:IntByRef = New IntByRef
		ibr.value = intVars.Count-1
		intVars.Add(Name,ibr)
	End

	Method AddArrayVar(Name:String)
		arrayVars.Add(Name,arrayVars.Count-1)
	End

	Method AddObjVar(Name:String)
		objVars.Add(Name,objVars.Count-1)
	End

End