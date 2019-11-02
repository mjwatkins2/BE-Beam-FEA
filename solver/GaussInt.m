function result = GaussInt(p, func)
% Integrates a function func which is order p between -1 and 1.
% p: The order of the function that is to be integrated.
% func: A function handle that is a function of only one variable.
%       For example: f = @(x)(x.^4);
%                    result = GaussInt(4, f);
% result: The scalar integration result.


n = ceil((p+1)/2);

[x, w] = GaussPoints(n);

fofx = func(x);

result = fofx'*w;