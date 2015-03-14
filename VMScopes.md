# Introduction #

This page just shows some ideas about the Harpl VM implementation.


# Data Scopes #

The Harpl VM will store data into "scopes". A scope is a whole area of memory that can be allocated and deallocated on request, to contain a given number of variables. That is, if a Harpl function uses 5 integers and 10 Strings, when the VM "enters" this function, it will allocate a Data Scope with the required space to store those variables. Once the execution goes out of the function, this scope will be considered invalid and released (or not) depending on potential re-usability of allocated space (this will be determined by the VM itself, automatically).

The data scope allocation is performed with a speciffic sentence and there will be 2 kind of data scopes:


  * Dynamic data scope: Those data scopes are allocated and deallocated in the form of a Stack. A complete stack is accesible from any code area. So if we're inside a block of code (execution) that has 5 nested levels of Data Scopes, we can access values from any of the levels. Data Scopes on the Harpl VM can be nested and the VM indexes all scopes from 0 (the current scope) to n (the latest scope). So index 1 means the parent of current Scope, the 2 means the grand parent of the current scope, and so on. There's also a scope indexed with -1 wich is considered a Global Scope that can be accesses from any part of the code. That is, Global Scpe can be accessed from any scope

  * Static data scope: This data scope is created in parallel to the global scope and can be accesses using a "pointer" variable. that's how object on Harpl will work. An object instance will be a data scope that only gets deallocated when there are no references to it (garbage collection). Access to this scopes is based on object-kind variables. All this static data scopes have a internal counter that indicates the number of references do exist to itself. If this number reaches 0, the static data scope is ready for deletion, otherwise it'll be alive. That makes the code garbage collection very fast but it won't handle cyclic references. we'll add a speciffic manual functino for this later, it can be slow if it is not automatically performed and we leave this management to the Harpl coder, so this cyclic reference "finder" algo, ca be used specialy while the Harpl application is being debugged and to track memory consumption on the application. We'll do our best to prevent cyclic data structures in the language.

Static data scopes will be implemented in the future. first usable version of Harpl will be based on procedural language without structures. I'll be adding this on a secondary iteration of Harpl, due it's complexity.