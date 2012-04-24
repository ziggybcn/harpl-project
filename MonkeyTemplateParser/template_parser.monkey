Import os
Function Main()
	if AppArgs.Length<>2 Then
		PrintInfoHeader
		Print "Wrong parameters number."
		Return -1
	EndIf
	Local filePath:String = AppArgs[1]
	
	if filePath.StartsWith(".") Then filePath = os.RealPath(filePath)
	
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
	Print "Located at: " + GetDir(filePath )
	text = ParseDoc(text,GetDir(filePath))
	Print text
	Return 0
End

Function PrintInfoHeader()
	Print "Monkey template parser for the Harpl source code."
	Print "This is a simple parser app, pass the file to be pre-compiled as the first paramter, and you're good to go!"
End

Function GetPath:String(file1:String, relative:String)
	Return os.RealPath(file1 + relative)
End

Function GetDir:String(filename:String)
	filename = filename.Replace("/","\")
	Local lastIndex:Int = filename.FindLast("\")
	Return filename[.. lastIndex+1]
End

Function ParseDoc:String(text:String, replaces:Replacer[], fileLocation:String)
	Local lines:String[] = text.Split("~n")
	Local lines2:list.List<String> = new list.List<String>
	Local ignore:Int = 0
	For Local i:Int = 0 until lines.Length
		Local teststring:String = lines[i].Trim()
		if teststring.ToLower.StartsWith("'loadtemplate ") And ignore = 0
			Print "Template load requested!"
			lines2.AddLast(lines[i])
			local data:String[] = teststring.Split(",")
			Local repList:List<Replacer> = new List<Replacer>
			For Local i:Int = 1 until data.Length
				Local repData:String[] = data[i].Split("=")
				Local rep:Replacer = new Replacer
				if repData.Length = 2
					rep.find = repData[0]
					rep.replace = repData[1]
					repList.AddLast(rep)
				endif
			Next
			local repArray:Replacer[] = repList.ToArray()
			Local filelocation:String = os.RealPath(fileLocation + data[0][14..].Trim())
			Print "Requesting template located at: " + filelocation
			lines2.AddLast(ParseDoc(LoadString(filelocation),repArray,GetDir(filelocation)))
			ignore+=1
		ElseIf lines[i].Trim().ToLower = "'endtemplate"
			ignore-=1
		end
		if ignore = 0 Then 
			Local line:String = lines[i]
			For Local rep:Replacer = EachIn replaces
				line = line.Replace("{%" + rep.find.Trim + "%}",rep.replace.Trim)
			next
			lines2.AddLast(line)
		endif
	Next
	Local result:String
	For Local s:String = eachin lines2
		result = result + s + "~n"
	Next
	Return result
End

Class Replacer
	Field find:String
	Field replace:String
End

Function ParseDoc:String(text:String, fileLocation:String)
	Return ParseDoc(text,[], fileLocation)
End
