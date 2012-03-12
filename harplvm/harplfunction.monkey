Import Harpl

Class HarplFunction
	Method Run(vm:Hvm)
		
	End
End

Class Sum_INIV extends HarplFunction
	Method Run(vm:Hvm)
		'Local result:Int = vm.PullInt + vm.Scope(vm.PullInt).IntVar(vm.PullInt)
		'vm.tmpInt[vm.PullInt] = result
	End
End