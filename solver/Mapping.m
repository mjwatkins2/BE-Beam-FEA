function x = Mapping(x0, x1, xi)
% Maps points xi from the standard domain to the global x domain.
% x0: Location of element left node.
% x1: Location of element right node.
% xi: Vector of standard coordinates.
% x:  Vector of points in the global x domain. x = Q(xi).

x = (1-xi)/2 * x0 + (1+xi)/2 * x1;