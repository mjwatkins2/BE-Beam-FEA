close all;
clear all;
addpath('solver');

%% Dimensions and properties

% Locations of each node
ne = 4; % number of elements
x = linspace(0, 50, ne+1);
% Modulus of elasticity
E = 10e6;
% Moment of inertia
I = 2*5^3/12;

%% Loads

% Values of applied point forces (must be same size as x)
V = zeros(size(x));
% Values of applied bending moments (must be same size as x)
M = zeros(size(x));
% Distributed load
q = @(x) 200*exp(-((x-25).^2)/50);
qOrder = 6; % It's not 6th order, but this is used for picking the number of Gauss points

%% Constraints 

% Constrained displacements (must be same size as x)
w0 = zeros(size(x));
w0(1) = 1;
w0(end) = 1;
% Constrained rotations (must be same size as x)
wrot0 = zeros(size(x));
% Distributed spring
c = @(x) 0;
cOrder = 0;

%% Solver

% P-level (must be 3 or greater)
p = 6;

SolveBeam(x, @(x)E, 0, @(x)I, 0, V, M, q, qOrder, w0, wrot0, c, cOrder, p);
