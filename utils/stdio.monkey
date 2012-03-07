#rem
	header: This module is a very simple I/O layer for the stdcpp target.
	It provides the basic functionality to send string data to the Standard Output Pipe, and to the Standard Error Pipe. It also provides an Input function to get data from the user, using the typical console prompt.
#end

'We don't want the reflection module to break everythinc C based here, so, we add a filter:
#REFLECTION_FILTER="stdio"  

#if TARGET="stdcpp" Or TARGET="glfw"
	'Private
	Extern private
	
	Class FILE
	End
	
	Global stdin:FILE
	Global stdout:FILE
	Global stderr:FILE
	
	Function fputc(c,file:FILE)
	Function fflush(file:FILE)
	Function fgetc:Int(file:FILE)
	'Const EOF
	Public
	
	'summary: Prompt for user input in the system console window and resturns a String
	Function Input:String(prompt:String=">")
		
		Local c:Int, result:String
		
		For Local i:Int = 0 until prompt.Length 
			fputc(prompt[i],stdout)
		end
		fflush(stdout)
		
		c=fgetc(stdin)
		
		While c<>10 And c<>13
			result += String.FromChar(c)
			c=fgetc(stdin);
		Wend
		
		fflush(stdin)
		
		Return result;
	End
	
	'summary: Sends text to the standard output pipe
	Function Output:void(value:String)
		For Local i:Int = 0 to value.Length-1
			fputc(value[i],stdout)
		Next
		fflush(stdout)
	End
	
	'summary: Sends text to the standard error pipe
	Function ErrOutput:void(value:String)
		For Local i:Int = 0 to value.Length-1
			fputc(value[i],stderr )
		Next
		fflush(stderr)
	End
#Else
	#Error "The Jungle stdio module is only supported in C++ based targets such as stdcpp or glfw."
#End 

#rem
	footer: [quote]Copyright (c) 2011-2012 Manel Ibáñez

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
[/quote]
#end
