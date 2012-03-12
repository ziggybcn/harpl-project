Import Harpl 

'SENTENCES:
#Rem
	summary:This class represents an Harpl assembler executable. When the Harpl compiler is executed, an AssemblerObj is generated as an instance of this class.
	This class instance can lateron be passed to the ByteCoder to generate the final executable for the Harpl Virtual Machine.
	This class also contains all string contants that represent Harpl assembler instructions and instruction prefixes.
#end
Class AssemblerObj
	Field code:List<String> = new List<String>

	'summary: Substraction prefix on the Harpl Assembler
	Const SUB:String = "SUB_"

	'summary: Addition prefix on the Harpl Assembler
	Const SUM:String = "SUM_"

	'summary: Divission prefix on the Harpl Assembler
	Const DIV:String = "DIV_"

	'summary: Multiplication prefix on the Harpl Assembler
	Const MUL:String = "MUL_"

	'summary: Power of prefix on the Harpl Assembler
	Const POW:String = "POW_"

	'summary: Modulus of prefix on the Harpl Assembler
	Const MODULUS:String = "MOD_"

	'summary: bitwise AND prefix on the Harpl Assembler. also acts as concatenation on Strings
	Const OP_AND:String = "AND_"

	'summary: bitwise OR prefix on the Harpl Assembler. 
	Const OP_OR:String = "OR_"

	'summary: Required heap size for internal string operations.
	Field requiredStringSize:Int
	
	'summary: Required heap size for internal float operations.
	Field requiredFloatSize:Int
	
	'summary: Required heap size for internal integer operations.
	Field requiredIntSize:Int
	
	'summary: Required heap size for internal boolean operations.
	Field requiredBoolSize:int
	
End
