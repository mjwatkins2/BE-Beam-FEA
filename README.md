# FEA Code for a Bernoulli-Euler Beam

This is a Matlab FEA solver for your basic Bernoulli-Euler beam. It outputs the total potential energy, force and moment reactions, and shear and bending moment diagrams. It  supports arbitrary functions for modulus E, cross-section moment of inertia I, distributed load q, and spring foundation c (each can be a function of x). DOF can be increased by adding elements or raising the p-level of the shape functions.

Two example input files provided:
- cantilever_example.m
  - The exact solution is obtained with one element and 4th order shape functions.
- nonpolynomial_example.m
  - The exact solution cannot be obtained with polynomial shape functions due to a nonpolynomial load distribution. The file uses 4 elements with 6th order shape functions.

## Cantilever Example:
The cantilever example is fixed on the left side, there is a uniform distributed load of -100 lb/in, and there is a -1000 lb load at the right side. If typical beam elements with 3rd order shape functions are used, the shear diagram shows discontinuities because the exact solution is not perfectly represented. The shear and bending moment diagrams are shown with 10 elements below:

![Image of 3rd order solution](https://github.com/mjwatkins2/BE-Beam-FEA/blob/master/Images/Cantilever3.png)

If the 4th order shape function is added, only one element is required to reach the exact solution:

![Image of 4th order solution](https://github.com/mjwatkins2/BE-Beam-FEA/blob/master/Images/Cantilever4.png)

## Nonpolynomial Example:
The nonpolynomial example uses a distributed load that is a normal distribution so that the exact solution is cannot be represented with polynomial shape functions. You can however get arbitrarily close to the exact solution by increasing the number of elements (h-extension) or increasing the shape function order (p-extension). For example here is a solution with 4 elements and 6th order shape functions:

![Image of 6th order solution](https://github.com/mjwatkins2/BE-Beam-FEA/blob/master/Images/Nonpolynomial6.png)

The equivalent solution with 4 elements and typical 3rd order beam elements would be much less smooth due to discretization error: 

![Image of 3rd order solution](https://github.com/mjwatkins2/BE-Beam-FEA/blob/master/Images/Nonpolynomial3.png)
