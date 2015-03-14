# Introduction #

Harpl is an academic project that consist on the creation a new programming language. Harpl will be (at first stage) a procedural interpreted programming language written in Monkey, but I would love to be adding some OO capabilities at some point... we'll see.


# Details #

The idea is that Harpl programs have to be:
  * Easy to undderstand
  * As close as possible to human languages. We'll be using words instead of symbols when possible. You write the code once, but read it lots of times
  * Also, Harpl programs have to be easy and cheap to maintain, so we'll make the language as strict as possible in its syntax and source code quality rules.
  * Harpl will be ultra portable. It's been written in Monkey (and that means it is translated to C++, but can be also translated to Java, C#, Javascript, and can then be run on a incredible wide range of architectures and devices, from phones, to desktop computers, gaming consoles, web browsers, etc.

# Status #
Harpl is in development status. We're still generating a pre-ast assembler, compiler and runtime. The idea is to get a first milestone that is able to compile and execute raw streams of Harpl source code, without any AST implementation, and when this is complete, we'll generate the AST and the function calling convention and linking.
Currently we're finishing the expression compiler and data allocation. We have just variable declarations and the Output sentence that displays text on the console.
Currently we're able to compile and execute chunks of code like this one:
<pre>
!This is a small Harpl sample<br>
!Just testing the RAW status of the compiler<br>
Output "Defining variables..."<br>
Define X as Integer = #000A<br>
Define value as boolean = X=5 or X=#A<br>
Define MyStringVariable As String = "This is a String variable"<br>
Define IntegerVar As Integer = 34, FloatVar as Float = IntegerVar ^ 2  * 2<br>
Output "Program executed. The value of MyStringVariable is:" ++ MyStringVariable<br>
</pre>