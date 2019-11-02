function F = ElementLoadVector(eMap, p, qFun, qOrder, Vo, Vl, Mo, Ml)
% Computes the element-level load vector.
% eMap: Function handle for a mapping function that accepts a vector xi and
% returns a vector x.  x = eMap(xi);
% p: Polynomial level (p-level) to use for shape functions.
% qFun: Function handle for a distributed load that is a function of x.
% Accepts a vector x and returns a vector q. q = qFun(x).
% qOrder: The order of the distributed load function q.
% Vo: Shear applied at xo.
% Vl: Shear applied at xl.
% Mo: Moment applied at xo.
% Ml: Moment applied at xl.
% F: Element-level load vector.

n = p+1;    % Number of shape functions (also # rows of F)
F = zeros(n,1);

len = abs(eMap(1) - eMap(-1));

for i = 1:n
    f = @(xi) qFun(eMap(xi)).*ShapeFunction(len,i,xi);
    F(i) =  GaussInt(p+qOrder, f);
end

F = len/2 * F;

F(1:4) = F(1:4) + [Vo, -Mo, -Vl, Ml]';
