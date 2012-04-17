Import Harpl

Class HarplFunction abstract
	Method Run:Void(vm:Hvm, bto:ByteCodeObj) abstract
End

Class Sum_INIV extends HarplFunction
	Method Run(vm:Hvm)
		'Local result:Int = vm.PullInt + vm.Scope(vm.PullInt).IntVar(vm.PullInt)
		'vm.tmpInt[vm.PullInt] = result
	End
End