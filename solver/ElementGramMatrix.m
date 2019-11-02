function M = ElementGramMatrix(Cs, CsOrder, eMap, p)
% Computes the element-level Gram matrix.
% Cs: Spring stiffness
% eMap: Function handle for a mapping function that accepts a vector xi and
% returns a vector x.  x = eMap(xi);
% p: Polynomial level (p-level) to use for shape functions.
% M: Element-level Gram matrix.

n = p+1;    % Number of shape functions (also rows and columns of M)
M = zeros(n);   % Initialize to all zeros
len = abs(eMap(1) - eMap(-1));

% P-level for integration, corresponding to two shape function second
% derivatives multiplied together.
pInt = p*2 + CsOrder;    % For example, N6 is 5th order so N6^2 is 10th order.

for i = 1:n
    for j = 1:i
        NiNj = @(xi) Cs(eMap(xi)) .* ShapeFunction(len,i,xi) .* ShapeFunction(len,j,xi);
        M(i,j) = GaussInt(pInt, NiNj);
        M(j,i) = M(i,j);
    end
end

M = len / 2 * M;