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
		stringVars.Add(Name,stringVars.Count-1)
	End

	Method AddIntVar(Name:String)
		intVars.Add(Name,intVars.Count-1)
	End
	Method AddFloatVar(Name:String)
		floatVars.Add(Name,floatVars.Count-1)
	End
	Method AddBooleanVar(Name:String)
		booleanVars.Add(Name,booleanVars.Count-1)
	End

	Method AddArrayVar(Name:String)
		arrayVars.Add(Name,arrayVars.Count-1)
	End

	Method AddObjVar(Name:String)
		objVars.Add(Name,objVars.Count-1)
	End

End