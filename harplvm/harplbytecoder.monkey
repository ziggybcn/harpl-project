Import Harpl
#Rem
	summary: This is the Harpl Byte Code assembler.
	This Class will provide all methods required to convert Harpl Assembler to bytecode that the Harpl Virtual Machine can run.
#end
Class HarplByteCoder
	Function GenerateByteCode:ByteCodeObj(harplAsm:AssemblerObj)
		
		Local result:= New ByteCodeObj
		
		Return result
		
	End function
End