Import dynamicdatascope

Class DynamicScopeStack
	
	Private
	Field scopes:DynamicDataScope[] 
	Const DEFAULT_SCOPE_SIZE:Int = 100
	Const SCOPE_OVERFLOW:Int = 1024
	Field pointer:Int = 0
	Public
	
	Method New()
		Init
		
	End
	
	Method Init()
		scopes = New DynamicDataScope[DEFAULT_SCOPE_SIZE]
		For Local i:Int=0 until scopes.Length 
			scopes[i] = New DynamicDataScope 
		Next
		pointer = -1
		
	End
	Method AddScope(ints:Int, strings:Int, floats:Int, booleans:Int, arrays:Int, objects:Int)
		pointer+=1
		if pointer>=scopes.Length Then
			Local previousSize:Int = scopes.Length
			scopes = scopes[..scopes.Length+DEFAULT_SCOPE_SIZE]
			For Local i:Int = previousSize-1 until scopes.Length 
				scopes[i] = New DynamicDataScope
			Next
			if scopes.Length >= SCOPE_OVERFLOW Then
				Error("Memory overflow running application")
			EndIf
		EndIf

		'Init the new scope:
		If scopes[pointer].Ints.Length < ints Then scopes[pointer].Ints= New Int[ints] 
		If scopes[pointer].Strings.Length < strings Then scopes[pointer].Strings= New String[strings] 
		If scopes[pointer].Arrays.Length < arrays Then scopes[pointer].Arrays = New object[arrays];
		If scopes[pointer].Booleans.Length < booleans Then scopes[pointer].Booleans = New bool[booleans];
		If scopes[pointer].Floats.Length < floats Then scopes[pointer].Floats = New Float[floats]
		If scopes[pointer].Objects.Length < objects Then scopes[pointer].Objects = New Int[objects];
		
	End Method
	
	Method RemoveScope()

		'Dereference classes here!
		
		'Free arrays here (if they're not finally objects)
		
		pointer-=1
		if pointer<0 Then
			Error("Memory below minimum limit. wrong optimization!")
		EndIf
	End
	
	Method GetdynamicScope:DynamicDataScope (Index:Int)
		if Index = -1 Then Return scopes[0]
		Return scopes[pointer-Index]
	End
	
End