# FEA Code for a Bernoulli-Euler Beam

This is a Matlab FEA solver for your basic Bernoulli-Euler beam. It outputs the total potential energy, force and moment reactions, and shear and bending moment diagrams. It  supports arbitrary functions for modulus E, cross-section moment of inertia I, distributed load q, and spring foundation c (each can be a function of x). DOF can be increased by adding elements or raising the p-level of the shape functions.

Two example input files provided:
- cantilever_example.m
  - The exact solution is obtained with one element and 3rd order shape functions.
- nonpolynomial_example.m
  - The exact solution cannot be obtained with polynomial shape functions due to a nonpolynomial load distribution. The file uses 4 elements with 6th order shape functions.
