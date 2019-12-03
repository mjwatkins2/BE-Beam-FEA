close all;
clear all;
addpath('solver');

%% Dimensions and properties

% Locations of each node
ne = 1; % number of elements
x = linspace(0, 50, ne+1);
% Modulus of elasticity
E = 10e6;
% Moment of inertia
I = 2*5^3/12;

%% Loads

% Values of applied point forces (must be same size as x)
V = zeros(size(x));
V(end) = -1000;
% Values of applied bending moments (must be same size as x)
M = zeros(size(x));
% Distributed load
q = @(x) -100;
qOrder = 0;

%% Constraints 

% Constrained displacements (must be same size as x)
w0 = zeros(size(x));
w0(1) = 1;
% Constrained rotations (must be same size as x)
wrot0 = zeros(size(x));
wrot0(1) = 1;
% Distributed spring
c = @(x) 0;
cOrder = 0;

%% Solver

% P-level (must be 3 or greater)
p = 4;

SolveBeam(x, @(x)E, 0, @(x)I, 0, V, M, q, qOrder, w0, wrot0, c, cOrder, p);
