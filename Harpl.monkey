#rem
	header:This is the Harpl compiler project, in all its glory.
#end
Import utils.stdio
Import utils.retro
Import utils.stringutils 
Import reflection
Import compiler
Import vmaassembler.assemblerobj
Import harplvm.hvm
Import os

'summary: This const contains the name of this application
Const APPNAME:String = "Harpl compiler"
'summary: This const contains the string representation of current version
Const APPVERSION:String = "00.00.00-A"
'summary: This const contains any additional version information (such as BETA, RC, whatever) to the current version
Const APPEXTRA:String = ""

'summary: This function returns a string reprention of current application name, version and extra information, useful to display app info.
Function AppString:String()
	if APPEXTRA = "" Then 	Return APPNAME + " " + APPVERSION  Else Return APPNAME + " " + APPVERSION + " " + APPEXTRA;
End
 
#rem
	summary:This is the entry point of the Harpl compiler
#end
Function Main()
	Print "======================================================"
	Print AppString
	Print "======================================================"
	If AppArgs.Length<2 Then 
		ShowCommandLineArgs()
		AbortExecution("No command-line parameters were found.", 0)
	ElseIf AppArgs.Length > 2 Then 
		ShowCommandLineArgs()
		AbortExecution("Too many parameters.", -1)
	endif
	
	Local lCompiler := New Compiler
	'If lCompiler.CompileFile (AppArgs[1]) = False Then
	lCompiler.CompileFile(AppArgs[1])
		For Local err:CompileError = eachin lCompiler.compileErrors
			Print "Error: " + err.description
			if err.file <>"" Then
				Print "    At file: " + err.file + "[" + err.posX + "," + err.posY + "]"
			EndIf
			Print ""
		Next
	'Else
		Local harplByteCoder := New HarplByteCoder 
		local bco:ByteCodeObj = harplByteCoder.GenerateByteCode(lCompiler.generatedAsm)
		For Local i:Int = eachin bco.code
			Print "Bytecode: " + i
		Next
		Local virtualMachine:Hvm = new Hvm
		if bco <> null then
			'virtualMachine.Run(bco)
		Else
			Print "The Byte Code Generator could not generate a valid bytecode object."
		endif
	'EndIf
	
End

'summary: This function should show the compiler syntax in the command line window
Function ShowCommandLineArgs()
	Print "Syntax: HARPL [filename]"
	Return True
End

'summary: Ends the execution of the compiler, providing an on-screen error message and returning an ErrorLevel to the OS or calling application
Function AbortExecution:void(message:String, errorLevel:Int=0)
	Print "Error: " + message
	Print "Execution of " + APPNAME + " has been canceled."
	ExitApp(errorLevel)
End

#rem
	footer: [quote]Copyright (c) 2011-2012 Manel Ibáñez

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
[/quote]
#end

