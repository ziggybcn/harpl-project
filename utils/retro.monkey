#rem
	header: This module provides a some classic basic-esque string manipualtion strings.
#end

'summary: Returns a given number of chars from the left of the string
Function Left:String(value:String, index:int)
	Return value[..index]
End

'summary: Returns a given number of chars from the right of the string
Function Right:String(value:String, index:int)
	Return value[-index..]
End

'summary: Returns a given number of chars from the middle of the string. First character is 1 (instead of the regular 0 of Monkey strings)
Function Mid:String(value:String, index:Int, count:Int)
	index-=1
	Return value[index..(index+count)]
End

'summary: Returns strings from the middle of a string to its end. First character is 1 (instead of the regular 0 of Monkey strings)
Function Mid:String(value:String, index:Int)
	index -=1
	Return value[index..]
End

'summary: Returns the 1 based position of a given substring on a string, or 0 if it is not found.
Function Instr( value:String,sub:String,start=1 )
	Return value.Find( sub,start-1 )+1
End Function

'summary: Replace a given substring in a sitring.
Function Replace:String( value:String,sub:String,replaceWith:String )
	Return value.Replace( sub,replaceWith )
End Function

'summary: Converts a string to lower case
Function Lower:String( str$ )
	Return str.ToLower()
End Function

'summary: Converts a string to upper case
Function Upper:String( str$ ) 
	Return str.ToUpper()
End Function