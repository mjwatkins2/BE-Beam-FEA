function Nppp = ShapeFunction3Deriv(len, i, xi)
% Computes the third derivative of shape function Ni at points xi for an
% element of length len.
% len: Element length.
% i: Shape function number.
% xi: Vector of standard coordinates.
% Nppp: The third derivative of shape function Ni at each point xi.

switch i
    case 1
        Nppp = 1.5;
    case 2
        Nppp = 0.75*len;
    case 3
        Nppp = -1.5;
    case 4
        Nppp = 0.75*len;
    otherwise
        P = LegendrePoly(i-3)';
        P = polyder(P);
        Nppp = sqrt((2*i-5)/2) * polyval(P,xi);
end