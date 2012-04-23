Import os
Function Main()
	if AppArgs.Length<>2 Then
		PrintInfoHeader
		Print "Wrong parameters number."
		Return -1
	EndIf
	Local filePath:String = AppArgs[1]
	
	if FileType(filePath)<>1 Then
		PrintInfoHeader
		Print "Wrong file. File was not found or it is not a file."
		Return -1
	endif
	
	Local text:String = LoadString(AppArgs[1])
	if text = "" Then
		PrintInfoHeader
		Print "File was empty"
		Return -1
	EndIf
	
	Print "Parsing document: " + os.StripAll(filePath)
	
	Return 0
End

Function PrintInfoHeader()
	Print "Monkey template parser for the Harpl source code."
	Print "This is a simple parser app, pass the file to be pre-compiled as the first paramter, and you're good to go!"
End