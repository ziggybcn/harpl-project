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
		return code.AddLast("~t" + parameter)
	End
	
	Method AddParameter:list.Node < String > (parentNode:list.Node < String >, parameter:String)
		if parentNode.NextNode = null Then
			code.AddLast("~t" + parameter)
		else
			Return New list.Node < String > (parentNode.NextNode, parentNode, "~t" + parameter)
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
	Const BC_EXIT_NEWSCOPE:Int = 2

	Const SET_EMPTYSCOPE:String = "EMPTYSCOPE"
	Const BC_SET_EMPTYSCOPE:Int = 3

	'summary: This sentence indicates that a variable has to be set to its default value (it's being init)
	Const SET_DEFVAR:String = "DEF_VAR"
	Const BC_SET_DEFVAR:Int = 4
	
	'summary: Assignation instruction on the Harpl Assembler. SET_VAR has the variable identification schema (kind/name/scope-level/kind/name[/scopelevel])
	Const SET_VAR:String = "SET_VAR"
	Const BC_SET_VAR:Int = 5
	
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


