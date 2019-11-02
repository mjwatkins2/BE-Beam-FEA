function [x, w, V, M] = PostProcessElement(EFun, IFun, n1x, n2x, AElem, xi)
    % Computes displacement and shear and bending moment functions in an element at std coords xi.
    % EFun: Modulus of elasticity function handle E(x).
    % IFun: Moment of inertia of the cross-section I(x).
    % n1x: x coordinate of node 1 (left).
    % n2x: x coordinate of node 2 (right).
    % AElem: Solution coefficients for this element.
    % xi: Standard coordinates.
    % x: Mapped x coordinate for each xi.
    % w: Displacment at each xi.
    % V: Shear at each xi.
    % M: Moment at each xi.

    mapFun = @(xi) Mapping(n1x, n2x, xi);
    len = n2x - n1x;
    x = mapFun(xi);
    E = EFun(x);
    I = IFun(x);

    w = ComputeW(len, xi, AElem);
    M = ComputeM(len, xi, E, I, AElem);

    % V = (EIw'')'
    % Approximate the derivative since E and I may also be functions of x
    % V = gradient(M,abs(x(2)-x(1))); Could just use 'gradient' function if xi
    % is sufficiently dense, but safer to use central difference method at each
    % xi in case xi is sparse.
    delta = 1e-3;
    xiL = xi - delta;
    xiR = xi + delta;
    xL = mapFun(xiL);
    xR = mapFun(xiR);
    ML = ComputeM(len, xiL, E, I, AElem);
    MR = ComputeM(len, xiR, E, I, AElem);
    V = (MR - ML) ./ (xR - xL);
    % Use forward and backward derivatives at the end points
    V(1) = (MR(1) - M(1)) / (xR(1) - x(1));
    V(end) = (M(end) - ML(end)) / (x(end) - xL(end));

    % check = V - gradient(M,abs(x(2)-x(1)))


function w = ComputeW(len, xi, AElem)

    numShapes = length(AElem);
    % Generate a matrix where the columns are shape function evaluations.
    N = zeros(numShapes, length(xi));
    for i=1:numShapes
        N(i,:) = ShapeFunction(len, i, xi);
    end
    % The total displacement of element e is its shape functions multipled
    % by its solution vector coefficients. Use matrix multiply.
    w = AElem * N;


function M = ComputeM(len, xi, E, I, AElem)

    numShapes = length(AElem);
    % Generate a matrix where the columns are shape function second derivatives.
    Npp = zeros(numShapes, length(xi));
    for i=1:numShapes
        Npp(i,:) = ShapeFunction2Deriv(len,i,xi);
    end
    % 2nd deriv. of displacement w.r.t xi
    wpp = AElem * Npp;

    % M = EIw'' = EId^2w/dxi^2 * 4/len^2
    M = 4/len^2 * E .* I .* wpp;

