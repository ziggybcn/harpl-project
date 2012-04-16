Class ByteCodeObj
	
	'During compilaiton process, we need to dynamically acces/create and modify bytecode, literals, etc. 
	'To accomplish this in a performance accepable way, we'll use Lists durint compilation time:

	'Used for compile-time manipulation of ByteCode
	Field tmpCode:List<Int> = new List<Int>

	'Used for compile-time manipulation os String Literals
	Field tmpLiterals:List<String>
	Field tmpLiteralsCount:Int = 0

	'Used for compile-time manipulation of float literals
	Field tmpFloats:List<Float>
	Field tmpFloatCount:Int = 0

	'During runtime operations we need direct and fast access to all bytecode data, and literals, etc.
	'To do so, we'll use arrays during runtime.
	Field code:Int[]
	
	'ininlinded literal data values:
	Field literals:String[]
	Field floats:Float[]
	
	'This field contains the instruction pointer in the bytecode array:
	Field pos:Int
	
	'That's the required "heap" size, for the execution of the given assembled object. This is calculated in the compilation process
	'and set there at that time. It is a static number.
	Field requiredStringsSize:Int
	Field requiredBooleanSize:Int
	Field RequiredIntegerSize:Int
	Field RequiredFloatSize:Int
	
	Method New()
		tmpLiterals = New List<String>
		tmpFloats = New List<Float>
	End
End