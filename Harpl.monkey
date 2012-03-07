#rem
	header:This is the Harpl compiler project, in all its glory.
#end
Import utils.stdio
Import utils.retro
Import utils.stringutils 
'Import reflection 

Import compiler.compiler 
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
	
	Local localCompiler:= New Compiler
	If localCompiler.CompileFile (AppArgs[1]) = False Then
		For Local err:CompileError = eachin localCompiler.compileErrors 
			Print "Error: " + err.description
			if err.file <>"" Then
				Print "    At file: " + err.file + "[" + err.posX + "," + err.posY + "]"
			EndIf
			Print ""
		Next
	EndIf
	
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
	footer:This compiler is under the MIT license. Enjoy!
#end
