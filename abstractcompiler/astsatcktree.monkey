Import Harpl
Class AstStackTree
	'summary: Puts a node in the compile stack
	Method Push(node:CppAstNode)
		list.AddLast(node)
		count += 1
	End
	'summary: Get the last node in the compile stack and removes it from the stack
	Method Pull:CppAstNode()
		return list.RemoveLast()
		count -= 1
	End
	
	'summary: Returns the latest item on the compile stack but does not consume it.
	Method Peek:CppAstNode()
		Return list.Last()
	End
	
	'summary: Returns true if the stack is empty, otherwise returns true
	Method IsEmpty:Bool()
		Return count = 0
		list.ObjectEnumerator
	End
	
	
	'summary: Return the number of items in the stack
	Method Count:Int()
		Return count
	End
	
	Method ObjectEnumerator:Enumerator<AstNode>()
		Return list.ObjectEnumerator()
	End
	
	Private
	Field list:= New List<CppAstNode>
	Field count:Int = 0
End Class