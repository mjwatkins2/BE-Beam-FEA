function Npp = ShapeFunction2Deriv(len, i, xi)
% Computes the second derivative of shape function Ni at points xi for an
% element of length len.
% len: Element length.
% i: Shape function number.
% xi: Vector of standard coordinates.
% Npp: The second derivative of shape function Ni at each point xi.

switch i
    case 1
        Npp = 1.5*xi;
    case 2
        Npp = len*(3*xi-1)/4;
    case 3
        Npp = -1.5*xi;
    case 4
        Npp = len*(3*xi+1)/4;
    otherwise
        P = LegendrePoly(i-3)';
        Npp = sqrt((2*i-5)/2) * polyval(P,xi);
end