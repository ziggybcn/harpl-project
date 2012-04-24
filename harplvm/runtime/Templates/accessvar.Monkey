{%bytecode%}.pos+=1; Local varNum:Int = {%bytecode%}.code[{%bytecode%}.pos]
{%bytecode%}.pos+=1; Local scopeNum:Int = {%bytecode%}.code[{%bytecode%}.pos]
Local localScope:DynamicDataScope = {%virtualmachine%}.dataScope.GetdynamicScope(scopeNum)
{%result%} = localScope.{%datasource%}[varNum]
{%opkind%} = {%opvalue%}
