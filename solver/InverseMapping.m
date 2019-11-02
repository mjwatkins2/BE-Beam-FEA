function xi = InverseMapping(x0, x1, x)
% Inverse maps points x from the global x domain to the standard domain.
% x0: Location of element left node.
% x1: Location of element right node.
% x: Vector of global coordinates.
% xi: Vector of points in the standard domain. xi = Q^-1(x).

xi = (2*x-x0-x1)/(x1-x0);