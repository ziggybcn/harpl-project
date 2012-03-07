#Rem
	summary: This function gets a string represetnation of a HEX number, and return the actual Integer number.
#End
Function HexToInteger:Int(Hex:String)
	Local digit:Int, value:Int;
	For Local i:Int = 0 until Hex.Length '-1;
		value*=16
		Select Hex[i]
			Case "0"[0]; digit = 0;
			Case "1"[0]; digit = 1;
			Case "2"[0]; digit = 2;
			Case "3"[0]; digit = 3;
			Case "4"[0]; digit = 4;
			Case "5"[0]; digit = 5;
			Case "6"[0]; digit = 6;
			Case "7"[0]; digit = 7;
			Case "8"[0]; digit = 8;
			Case "9"[0]; digit = 9;
			Case "A"[0], "a"[0]; digit = 10;
			Case "B"[0], "b"[0]; digit = 11;
			Case "C"[0], "c"[0]; digit = 12;
			Case "D"[0], "d"[0]; digit = 13;
			Case "E"[0], "e"[0]; digit = 14;
			Case "F"[0], "f"[0]; digit = 15;
			Default
				Error("unexpected character on hexadecimal literal.");
		End
		value = (value + digit) 
	Next
	Return value;
End