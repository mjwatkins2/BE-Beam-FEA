function N = ShapeFunction(len, i, xi)
    % Computes shape function Ni at points xi for an element of length len.
    % len: Element length.
    % i: Shape function number.
    % xi: Vector of standard coordinates.
    % N: The computed shape function Ni at each point xi.

    switch i
        case 1
            N = 0.25*(2+xi).*(1-xi).^2;
        case 2
            N = len/8*(1+xi).*(1-xi).^2;
        case 3
            N = 0.25*(2-xi).*(1+xi).^2;
        case 4
            N = -len/8*(1-xi).*(1+xi).^2;
        otherwise
            N = HigherOrder(i,xi);
    end

function N = HigherOrder(i, xi)
    % Computes higher order shape functions, where i >= 5.
    % i: Shape function number.
    % xi: Vector of standard coordinates.
    % N: The computed shape function Ni at each point xi.

    P = LegendrePoly(i-3)';

    P = polyint(P);
    c = -polyval(P,-1);
    P(end) = P(end) + c;

    P = polyint(P);
    c = -polyval(P,-1);
    P(end) = P(end) + c;

    N = sqrt((2*i-5)/2) * polyval(P,xi);
