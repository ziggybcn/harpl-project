Import Harpl

Class CppTrans

	Const CIP:String = "_hl_"
	Field source:Compiler
	Field node:list.Node<String>
	Field outputcode:= New List<String>
	Field identifiers:= New List<Identifier>
	
	Field astStackTree:=New AstStackTree
	
	Method Translate()
	
		Local asm:= source.generatedAsm.code

		node = asm.FirstNode()
		InitModule
		While node <> null
			Select node.Value
			
				Case AssemblerObj.SET_NEWSCOPE
				'We can expect a number of variablez here, we'll have to diferenciate between a Global scope or a Local scope here.	
				CompileNewScope()
				node = node.NextNode
				
			Default
				Print "unknown assembler sentence: " + node.Value
				node = node.NextNode
			End Select
		
			'node = node.NextNode
		Wend
		EndModule
	End
	
	Method CompileNewScope()
		Local astNode:= New CppAstNode
		astStackTree.Push(astNode)
		astStackTree.Peek.AddScope(Self)
	End
	
	Method GetNextParam:String()
		if node.NextNode = null Then Return ""
		node = node.NextNode
		if node.Value.StartsWith(AssemblerObj.ParameterPrefix) = False Then
			node = node.PrevNode
			Return ""
		EndIf
		Return Mid(node.Value, AssemblerObj.ParameterPrefix.Length + 1)
	End
	
	Method HasMoreParams:Bool()
		if node.NextNode = null Then Return False
		if node.NextNode.Value.StartsWith(AssemblerObj.ParameterPrefix) = True Then Return True
		Return false
	End
	
	Method GetTabs:String()
		Return Tabs(astStackTree.Count)
	End
	
	Method InitModule()
		outputcode.AddLast("#include <string>")
		outputcode.AddLast("using namespace std;")
		outputcode.AddLast("void main() {")
	End
	Method EndModule()
		outputcode.AddLast("}")
	End
End