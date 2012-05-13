Import Harpl

Class DynamicDataScope

	Private
	Const  DEFAULT_MEM_SIZE:Int = 32
	Public

	Field Ints:Int[]
	Field Floats:Float[]
	Field Strings:String[]
	Field Booleans:Bool[]
	Field Objects:Int[]
	Field Arrays:Object[]	'To set this to something.
	Method New()
		Ints = New Int[DEFAULT_MEM_SIZE];
		Floats = New float[DEFAULT_MEM_SIZE];
		Strings = New String[DEFAULT_MEM_SIZE];
		Booleans = New Bool[DEFAULT_MEM_SIZE];
		Objects = New Int[DEFAULT_MEM_SIZE ];
		Arrays = New Object[DEFAULT_MEM_SIZE];
	End
	
End