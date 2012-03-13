Import Harpl 
#rem
	header:	[b]The Harpl Assembler specification[/b]
	
	The Harpl assembler is a high level assembler that produces Harpl Byte code that can be lateron be executed by the Harpl Virtual Machine.
	This assembler is very verbose and is meant to be easy to follow and understand.
	The instructions set is still being designed, specially optimized instructions, but we're finishing a first [i]usable[/i] version before we get our hands dirty on the whole optimizations process.

	The Harpl Assembler syntax
	
	1.- All instructions are placed at the begining of a line, without any leading space.
	2.- Parameters do start with a TAB always (are indented). This is not optional.
	3.- Any line starting with ! is considered a comment.
	
	[b]Arithmetic non optimized operations on the Harpl Assembler.[/b]
	
	Notice the standard syntax of an arithmetic operation in Harpl assembler:
	
	[list]
	[*] [b]Instruction[/b]				--> This is the operation identifier, SUM, SUB, MUL, etc.
	[*] Data Source 1				--> This is the data source identifier IV for integer variable, FV for float variable, FN for iteger number, etc.
	[*] Data Name 1				--> This is the value itself if it is literal (number, float or string) or the variable name if it is avariable
	[*] [i][Data Scope 1][/i]			--> This is the socope location of the variable name. This parameter only appears on variable data sources.
	[*] Data source 2				--> This is thedata source identifier for the second operator.
	[*] Data name 2				--> The DataName for the second operator
	[*] [i][Data Scope2][/i]			--> If required, the socope of this second operator, on variable operations
	[*] Tmp Destination source	--> The tmp variable destination where the operation result will be stored.
	[/list]
	There are plas to add optimized artithmetics in the future, but by now, we're focusing on functionality rather than speed. Preemptive optimization, you know...
#end

'SENTENCES:
#Rem
	summary:This class represents an Harpl assembler executable. When the Harpl compiler is executed, an AssemblerObj is generated as an instance of this class.
	This class instance can lateron be passed to the ByteCoder to generate the final executable for the Harpl Virtual Machine.
	This class also contains all string contants that represent Harpl assembler instructions.
#end
Class AssemblerObj
 	Field code:List < String >= new List < String >
	
	Method AddInstruction:Bool(instruction:String)
		return code.AddLast(instruction) <> null
	End
	
	Method AddParameter:Bool(parameter:String)
		return code.AddLast("~t" + parameter) <> null
	End
	
	#Rem
	summary: Substraction instruction on the Harpl Assembler.
	#End
 	Const SUB:String = "SUBSTRACT"

	'summary: Addition instruction on the Harpl Assembler
	Const SUM:String = "SUM"

	'summary: Divission instruction on the Harpl Assembler
	Const DIV:String = "DIVIDE"

	'summary: Multiplication instruction on the Harpl Assembler
	Const MUL:String = "MULTIPLY"

	'summary: Power of instruction on the Harpl Assembler
	Const POW:String = "POWEROF"

	'summary: Modulus of instruction on the Harpl Assembler
	Const MODULUS:String = "MODULUS"

	'summary: bitwise AND instruction on the Harpl Assembler. also acts as concatenation on Strings
	Const BIT_AND:String = "BIT_AND"

	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const BIT_OR:String = "BIT_OR"

	'summary: Required heap size for internal string operations.
	Field requiredStringSize:Int
	
	'summary: Required heap size for internal float operations.
	Field requiredFloatSize:Int
	
	'summary: Required heap size for internal integer operations.
	Field requiredIntSize:Int
	
	'summary: Required heap size for internal boolean operations.
	Field requiredBoolSize:int
	
End


