Class ByteCodeObj
	
	Field tmpCode:List<Int> = new List<Int>

	Field code:Int[]
	
	'ininlinded literal data values:
	Field literals:String[]
	Field floats:Float[]
	
	'Execution pos:
	Field pos:Int
	
	Field requiredStringsSize:Int
	Field requiredBooleanSize:Int
	Field RequiredIntegerSize:Int
	Field RequiredFloatSize:Int
End