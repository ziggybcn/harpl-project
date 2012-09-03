Import Harpl

Class CppAstNode
	Method Children:List<AstNode>() Property
		Return children
	End

	Field idents:= New List<Identifier>
		
	Method AddScope(compiler:CppTrans)
		While compiler.HasMoreParams
			Local datatype:String = compiler.GetNextParam
			Local varName:String = compiler.GetNextParam
			Local ident:= New Identifier
			ident.datatype = datatype
			ident.name = varName
			Select datatype
			
				Case expKinds.BOOLVAR
					compiler.outputcode.AddLast(compiler.GetTabs + "bool " + CppTrans.CIP + varName + ";")
								
				Case expKinds.FLOATVAR
					compiler.outputcode.AddLast(compiler.GetTabs + "float " + CppTrans.CIP + varName + ";")
					
				Case expKinds.INTVAR
					compiler.outputcode.AddLast(compiler.GetTabs + "int " + CppTrans.CIP + varName + ";")
					
				Case expKinds.STRINGVAR
					compiler.outputcode.AddLast(compiler.GetTabs + "wstring " + CppTrans.CIP + varName + ";")
					
				Default
					Print "Data type is:" + datatype
					Continue
			End Select
			idents.AddLast(ident)
		Wend
	End
	
	Private
	Field children:= New List<AstNode>
	
End


