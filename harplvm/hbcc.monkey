#Rem
	summary: This is the Harpl Byte Code assembler.
	This class will provide all methods required to convert Harpl Assembler to bytecode that the Harpl Virtual Machine can run.
#end
Import Harpl
Class HarplByteCoder
	Function GenerateByteCode:ByteCodeObj(harplAsm:AssemblerObj)
		Return New ByteCodeObj
	End function
End