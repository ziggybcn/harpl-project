Import runtimescope
Const MAXSCOPENESTINGLEVEL = 1024

Class ScopeStack

	Field scopes := new RuntimeScope[MAXSCOPENESTINGLEVEL]
	
	Field vm:Hvm
	
	Field currentScope:Int = 0
	
	Method PushScope:Bool(intHeap:Int, strHeap:Int, boolHeap:Int, floatHeap:int)
		currentScope += 1
		if currentScope >= MAXSCOPENESTINGLEVEL Then
			Local runTimeError := new RunTimeError
			runTimeError.description = "Stack overflow on nested data scopes."
			vm.runTimeErrors.AddLast(runTimeError)
			Return false
		EndIf
		if scopes[currentScope] = null Then scopes[currentScope] = New RuntimeScope
		if scopes[currentScope].Ints < IntHeap Then scopes[currentScope].Ints = New int[intHeap]
		if scopes[currentScope].Strings < IntHeap Then scopes[currentScope].Strings = New String[intHeap]
		if scopes[currentScope].Bools < IntHeap Then scopes[currentScope].Bools = New Bool[intHeap]
		if scopes[currentScope].Floats < IntHeap Then scopes[currentScope].Floats = New Float[intHeap]
	End
	
	Method PullScope:Bool()
		currentScope -= 1
		if currentScope < 0 Then
			Local runTimeError := new RunTimeError
			runTimeError.description = "Stack underflow on nested data scopes. Error in generated assembly or executable is corrupted."
			vm.runTimeErrors.AddLast(runTimeError)
			currentScope = 0
			Return false
		EndIf
	End
	
	Method IntFromScope:Int(scope:Int, index:Int)
		Return scopes[scope].Ints[index]
	End
	Method BoolFromScope:Bool(scope:Int, index:Int)
		Return scopes[scope].Bools[index]
	End
	Method StringFromScope:String(scope:Int, index:Int)
		Return scopes[scope].Strings[index]
	End
	Method FloatFromScope:Float(scope:Int, index:Int)
		Return scopes[scope].Floats[index]
	End
	
End