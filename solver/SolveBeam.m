function SolveBeam(x, EFun, EOrder, IFun, IOrder, V, M, qFun, qOrder, w0, wrot0, CFun, COrder, p)
% Entry point to the Bernoulli-Euler beam solver
% --Domain--
% x: Locations of each node
% --Properties--
% EFun: Function specifying modulus of elasticity E(x)
% EOrder: Polynomial order of Efun
% IFun: Function specifying moment of inertia I(x)
% IOrder: Polynomial order of Ifun
% --Loads--
% V: Applied point forces at each node (same size as x)
% M: Applied bending moments at each node (same size as x)
% qFun: Distributed load q(x)
% qOrder: Polynomial order of qFun
% --Constraints--
% w0: Constrained displacement at each node? T/F (same size as x)
% wrot0: Constrained rotation at each node? T/F (same size as x)
% CFun: Distributed spring stiffness c(x)
% COrder: Polynomial order of CFun
% --Solver--
% p: P-level for solution (must be 3 or greater)


%% Check Inputs
if length(x) < 2
    error('Must specify at least two nodes.');
elseif length(x) ~= length(V)
    error('The lengths of vector x and vector V must be equal.')
elseif length(x) ~= length(M)
    error('The lengths of vector x and vector M must be equal.')
elseif length(x) ~= length(w0)
    error('The lengths of vector x and vector w0 must be equal.')
elseif length(x) ~= length(wrot0)
    error('The lengths of vector x and vector wrot0 must be equal.')
elseif any(x(2:end) <= x(1:end-1))
    error('The values of the x-coordinates must always increase.')
end

%% Nodes
% x-coordinates of each node
nodes = x;

%% Constraints
% Identify constrained node numbers
constrainNodeDisplacement = 1:length(nodes);
constrainNodeDisplacement = constrainNodeDisplacement(w0 == 1);
constrainNodeSlope = 1:length(nodes);
constrainNodeSlope = constrainNodeSlope(wrot0 == 1);
killDOF = [constrainNodeDisplacement*2-1 constrainNodeSlope*2];

%% Solve

% Global unconstrained system of equations
[KGlobalUC, FGlobalUC] = Assemble(EFun, IFun, CFun, qFun, EOrder, IOrder, COrder, qOrder, V, M, nodes, p);

% Number all the DOF from 1 to n
unconstrainedDOF = size(KGlobalUC,1);
DOFNumbers = 1:unconstrainedDOF;

% Copy K and F
KGlobal = KGlobalUC;
FGlobal = FGlobalUC;
% Setting rows and columns to [] removes them.
% Do this for the constrained DOF.
KGlobal(killDOF,:) = [];
KGlobal(:,killDOF) = [];
FGlobal(killDOF) = [];
DOFNumbers(killDOF) = [];

% Actual DOF for the system of equations
constrainedDOF = length(DOFNumbers);
disp(sprintf('Degrees of freedom: %d',constrainedDOF));

% Solve for shape function coefficients a
a = KGlobal\FGlobal;

% Copy non-zero coefficients a to unconstrained solution vector A
A = zeros(unconstrainedDOF,1);
A(DOFNumbers) = a;

StrainEnergy = 0.5 * A' * KGlobalUC * A;
LoadsPotential = A' * FGlobalUC;
PE = StrainEnergy - LoadsPotential;
disp(sprintf('Potential energy: %.10f',PE));

% Separate out local solution vectors for each element
AElem = Disassemble(nodes, p, A);

%% Post-process
PostProcessReactions(KGlobalUC, FGlobalUC, A, constrainNodeDisplacement, constrainNodeSlope)
PostProcessPlots(nodes, AElem, EFun, IFun);

