close all;
clear all;
addpath('solver');

%% Dimensions and properties

% Locations of each node
x = [0 12.5 25 37.5 50];
% Modulus of elasticity
E = 10e6;
% Moment of inertia
I = 2*5^3/12;

%% Loads

% Values of applied point forces (must be same size as x)
V = [0 0 0 0 0];
% Values of applied bending moments (must be same size as x)
M = [0 0 0 0 0];
% Distributed load
q = @(x) 200*exp(-((x-25).^2)/50);
qOrder = 6; % It's not 6th order, but this is used for picking the number of Gauss points

%% Constraints 

% Constrained displacements (must be same size as x)
w0 = [1 0 0 0 1];
% Constrained rotations (must be same size as x)
wrot0 = [0 0 0 0 0];
% Distributed spring
c = @(x) 0;
cOrder = 0;

%% Solver

% P-level (must be 3 or greater)
p = 6;

SolveBeam(x, @(x)E, 0, @(x)I, 0, V, M, q, qOrder, w0, wrot0, c, cOrder, p);
