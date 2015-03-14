# Introduction #

This page just shows some ideas about the Harpl VM implementation.


# Data Scopes #

The Harpl VM will store data into "scopes". A scope is a whole area of memory that can be allocated and deallocated on request, to contain a given number of variables. That is, if a Harpl function uses 5 integers and 10 Strings, when the VM "enters" this function, it will allocate a Data Scope with the required space to store those variables. Once the execution goes out of the function, this scope will be considered invalid and released (or not) depending on potential re-usability of allocated space (this will be determined by the VM itself, automatically).

The data scope allocation is performed with a speciffic sentence and there will be 2 kind of data scopes:

  * Dynamic data scope: Those data scopes are allocated and deallocated in the form of a Stack. A complete stack is accesible from any code area. So if we're inside a block of code (execution) that has 5 nested levels of Data Scopes, we can access values from any of the levels. The VM indexes all scopes from 0 (the current scope) to n (the latest scope). There's also a scope indexed with -1 wich is considered a Global scope that can be accesses from any part of the code.

  * Static data scope: