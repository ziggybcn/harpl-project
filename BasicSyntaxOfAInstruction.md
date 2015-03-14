# Basic syntax #

All Harpl instructions are case insensitive and are ended with a ; character. This character is optional at the end of a source code line, but not when you're merging several instructions on a single source code line.

All Harpl instructions can be splitted into several source code lines given that the last token in the splitted line is an operator.

Examples of valid Harpl source code instructions:
<pre>
Define MyVariable as Integer = 45 +<br>
56<br>
<br>
MyVariable = MyVariable+1;<br>
<br>
MyVariable = MyVariable*2; Output ("Hello world!")<br>
<br>
Define MyNumber1 as Integer = 34,<br>
MyNumber2 as Integer = 56,<br>
MyNumber3 as Integer = 67;<br>
<br>
</pre>