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
	summary:This Class represents an Harpl assembler executable. When the Harpl compiler is executed, an AssemblerObj is generated as an instance of this Class.
	This Class instance can lateron be passed to the ByteCoder to generate the final executable for the Harpl Virtual Machine.
	This Class also contains all string contants that represent Harpl assembler instructions.
#end
Class AssemblerObj
 	Field code:List < String >= new List < String >
	Const ParameterPrefix:String = "~t"
	Method AddInstruction:list.Node < String > (instruction:String)
		return code.AddLast(instruction)
	End
	
	Method AddInstruction:list.Node < String > (prevNode:list.Node < String >, instruction:String)
		if prevNode.NextNode = null Then
			code.AddLast(instruction)
		else
		
			Return New list.Node < String > (prevNode.NextNode, prevNode, instruction)
		endif
	End
	Method AddParameter:list.Node < String > (parameter:String)
		return code.AddLast(ParameterPrefix + parameter)
	End
	
	Method AddParameter:list.Node < String > (parentNode:list.Node < String >, parameter:String)
		if parentNode.NextNode = null Then
			code.AddLast(ParameterPrefix + parameter)
		else
			Return New list.Node < String > (parentNode.NextNode, parentNode, ParameterPrefix + parameter)
		endif
	End
	
	#Rem
	summary: Substraction instruction on the Harpl Assembler.
	#End
 	Const SUB:String = "SUBSTRACT"
	Const BC_SUB:Int = 100
	
	'summary: Addition instruction on the Harpl Assembler
	Const SUM:String = "SUM"
	Const BC_SUM:Int = 101

	'summary: Divission instruction on the Harpl Assembler
	Const DIV:String = "DIVIDE"
	Const BC_DIV:Int = 102

	'summary: Multiplication instruction on the Harpl Assembler
	Const MUL:String = "MULTIPLY"
	Const BC_MUL:Int = 103

	'summary: Power of instruction on the Harpl Assembler
	Const POW:String = "POWEROF"
	Const BC_POW:Int = 104

	'summary: Modulus of instruction on the Harpl Assembler
	Const MODULUS:String = "MODULUS"
	Const BC_MODULUS:Int = 105

	'summary: bitwise AND instruction on the Harpl Assembler. also acts as concatenation on Strings
	Const BIT_AND:String = "BIT_AND"
	Const BC_BIT_AND:Int = 106

	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const BIT_OR:String = "BIT_OR"
	Const BC_BIT_OR:Int = 107
	
	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const CONCAT:String = "CONCAT"
	Const BC_CONCAT:Int = 108

	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const BIT_XOR:String = "BIT_XOR"
	Const BC_BIT_XOR:Int = 109

	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const BIT_SHL:String = "BIT_SHL"
	Const BC_BIT_SHL:Int = 110

	'summary: bitwise OR instruction on the Harpl Assembler. 
	Const BIT_SHR:String = "BIT_SHR"
	Const BC_BIT_SHR:Int = 111
	
	Const UNARY_SUB:String = "UNARY_SUBSTRACTION"
	Const BC_UNARY_SUB:Int = 112
	
	Const UNARY_COMPLEMENT:String = "UNARY_COMPLEMENT"
	Const BC_UNARY_COMPLEMENT:Int = 113
	
	Const MINOR:String = "MINOR_THAN"
	Const BC_MINOR:Int = 114
	
	Const MAJOR:String = "MAJOR_THAN"
	Const BC_MAJOR:Int = 115

	Const EQUALS:String = "EQUALS"
	Const BC_EQUALS:Int = 116

	Const MAJOR_EQUAL:String = "MAJOR_OR_EQUAL_THAN"
	Const BC_MAJOR_EQUAL:Int = 117

	Const MINOR_EQUAL:String = "MINOR_OR_EQUAL_THAN"
	Const BC_MINOR_EQUAL:Int = 118

	Const NOT_EQUALS:String = "NOT_EQUALS"
	Const BC_NOT_EQUALS:Int = 119
	
	Const LOGICAL_AND:String = "LOGICAL_AND"
	Const BC_LOGICAL_AND:Int = 120
	
	Const LOGICAL_OR:String = "LOGICAL_OR"
	Const BC_LOGICAL_OR:Int = 121
	
	Const AS_INTEGER:String = "AS_INTEGER"
	Const BC_AS_INTEGER:Int = 150
	Const AS_FLOAT:String = "AS_FLOAT"
	Const BC_AS_FLOAT:Int = 151
	Const AS_STRING:String = "AS_STRING"
	Const BC_AS_STRING:Int = 152
	Const AS_BOOLEAN:String = "AS_BOOLEAN"
	Const BC_AS_BOOLEAN:Int = 153

	Const SET_TRUE:String = "SET_TRUE"
	Const BC_SET_TRUE:Int = 154

	'------------------------------------------------------
	'DATA ALLOCATION:
	#Rem
	summary:This sentence indicates that a new variable's scope is being allocated at runtime.
	A new scope syntax is:
	[code] NEWSCOPE
		var-type
		var-name
		...[/ code]
	#end
	Const SET_NEWSCOPE:String = "NEWSCOPE"
	Const BC_SET_NEWSCOPE:Int = 1
	
	Const EXIT_SCOPE:String = "EXITSCOPE"
	Const BC_EXIT_SCOPE:Int = 2

	Const SET_EMPTYSCOPE:String = "EMPTYSCOPE"
	Const BC_SET_EMPTYSCOPE:Int = 3

	'summary: This sentence indicates that a variable has to be set to its default value (it's being init)
	Const SET_DEFVAR:String = "DEF_VAR"
	Const BC_SET_DEFVAR:Int = 4
	
	'summary: Assignation instruction on the Harpl Assembler. SET_VAR has the variable identification schema (kind/name/scope-level/kind/name[/scopelevel])
	Const SET_VAR:String = "SET_VAR"
	Const BC_SET_VAR:Int = 5
	
	
	'------------------------------------------------------------------
	'I/O
	Const IO_OUTPUT:String = "IO_OUTPUT"
	Const BC_IO_OUTPUT:Int = 30
	
	'-------------------------------------------------------------
	'summary: Required heap size for internal string operations.
	Field requiredStringSize:Int
	
	'summary: Required heap size for internal float operations.
	Field requiredFloatSize:Int
	
	'summary: Required heap size for internal integer operations.
	Field requiredIntSize:Int
	
	'summary: Required heap size for internal boolean operations.
	Field requiredBoolSize:int
	
End


