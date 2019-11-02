function K = ElementStiffnessMatrix(E, I, Eorder, Iorder, eMap, p)
% Computes the element-level stiffness matrix.
% E: Modulus of elasticity function handle E(x).
% I: Moment of inertia of the cross-section I(x).
% eMap: Function handle for a mapping function that accepts a vector xi and
% returns a vector x.  x = eMap(xi);
% p: Polynomial level (p-level) to use for shape functions.
% K: Element-level stiffness matrix.

n = p+1;    % Number of shape functions (also rows and columns of K)
K = zeros(n);   % Initialize stiffness matrix to all zeros
len = abs(eMap(1) - eMap(-1));  % Element length

% P-level for integration, corresponding to two shape function second
% derivatives multiplied together.
pInt = (p-2)*2 + Eorder + Iorder;    % For example, N6'' is 3rd order so N6''^2 is sixth order.

for i = 1:n
    for j = 1:i
        NiNj = @(xi) E(eMap(xi)) .* I(eMap(xi)) .*ShapeFunction2Deriv(len,i,xi) .* ShapeFunction2Deriv(len,j,xi);
        K(i,j) = GaussInt(pInt, NiNj);
        K(j,i) = K(i,j);
    end
end

K = 8/len^3 * K;