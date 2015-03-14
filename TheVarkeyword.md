# Introduction #

This shows the local variables declaration syntax:

# Details #

A local variable is declared with the keyword Define, followed by the variable name, an As clause, and then the variable kind.

Example:

**Define** _`VariableName`_ **as** _`VariableKind`_

This sentence also alows you to set a default variable value. This default value is considered the "initialization" value.

**Define** _`VariableName`_ **as** _`VariableKind`_ _[**`=`** expression]_

You can optionaly define several variables at once, separating each variable declaration by a coma, following this syntax:

**Define** _`VariableName`_ **as** _`VariableKind`_ _[**`=`** expression]_ **,** _`VariableName`_ **as** _`VariableKind`_ _[**`=`** expression]_

# Valid variable names #

A variable name has to start with a letter from "a" to "z", and can contain any latin letter, number, or the underscore character `_`. A variable name can't contain any special character or tilde or accented character. Also, notice that Harpl is case insensitive, so `MyName`, `myname` and `MYNAME` are the same variable name.

# Available data types #

Currently Harpl accepts the following data types:

  * Integer: This represents an integer numeric value. It is, at last, a 16 bits integer value. (depending on the architecture of the host running Harpl, Integers can be 32 bits or longer).

  * Float: This represents a floating point value. This is, at last, a 16 bits single precission float, white it's most standard implementation is double precission 32 bits floats.

  * String: This represents text. Strings store their characters, at last, using 8 bits (traditional ANSI/ASCII encoding). Depending on the architecture of the host, strings can be unicode or have any different encoding.

  * Boolean: This represents a boolean value. Those data types can only store two possible values: True or False.

Harpl does not currently support any additional data type, but this might change in the future.

So all in all, a valid Var sentece could look like:

**Define** `MyAge` **as Integer** _= 21_, `MyName` **as String** _= "Manel"_, `DoILikeDolphins` **as Boolean** _= True_ _;_

# Default variables values #

If you don't specify a default value on a variable declaration, the following values are set by default:

  * Integer = 0
  * Float = 0.0
  * String = ''
  * Boolean = False

So writing: <pre>
Define Counter as Integer = 0;<br>
</pre>
Is the same as: <pre>
Define Counter as Integer;<br>
</pre>