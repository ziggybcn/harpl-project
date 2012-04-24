{%bytecode%}.pos+=1; Local varNum:Int = {%bytecode%}.code[bco.pos]
{%result%} = {%virtualmachine%}.{%source%}[varNum]
{%opkind%} = {%opvalue%}