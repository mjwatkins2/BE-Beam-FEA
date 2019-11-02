function [KGlobalUC, FGlobalUC] = Assemble(E, I, Cs, q, EOrder, IOrder, CsOrder, qOrder, V, M, nodes, p)
% Computes element-level stiffness matrices and load vectors and assembles
% them into the global unconstrained stiffness matrix and load vector.
% E: Modulus of elasticity
% I: Cross-section moment of intertia
% Cs: Distributed spring stiffness
% q: Function handle for distributed load as a function of x.
% qOrder: The polynomial order of q(x).
% V: Applied shear force at each node. Must be the same size as vector nodes.
% M: Applied moment at each node. Must be the same size as vector nodes.
% nodes: Vector of x-coordinates of nodes.
% p: Polynomial order to use for shape functions.
% KGlobalUC: The global assembled unconstrained stiffness matrix.
% FGlobalUC: The global assembled unconstrained load vector.

numElems = length(nodes)-1;
numInternalShapes = p-3;
UnconstrainedDOF = (2+2*numElems)+(numInternalShapes*numElems);

KGlobalUC = zeros(UnconstrainedDOF);
FGlobalUC = zeros(UnconstrainedDOF,1);

for e = 1:numElems
    
    MapElem = @(xi) Mapping(nodes(e), nodes(e+1), xi);
    
    % For every element except the last, apply shear and moment to left
    % side only so that they aren't applied twice.
    Vo = V(e);
    Vl = 0;
    Mo = M(e);
    Ml = 0;
    
    % For the last element, apply to both sides.
    if e == numElems
        Vl = -V(end); % Keep positive as up
        Ml = -M(end); % Keep positive as CW
    end
    
    % Element-level stiffness matrix, Gram matrix, and load vector
    KElem = ElementStiffnessMatrix(E, I, EOrder, IOrder, MapElem, p);
    MElem = ElementGramMatrix(Cs, CsOrder, MapElem, p);
    FElem = ElementLoadVector(MapElem, p, q, qOrder, Vo, Vl, Mo, Ml);
    
    % First position of the 4x4 overlapping matrix
    row1 = 2*(e-1)+1;
    
    % Copy first four terms to global stiffness matrix and load vector
    firstGroup = row1:(row1+3);
    KGlobalUC(firstGroup, firstGroup) = KGlobalUC(firstGroup,firstGroup) + ...
        KElem(1:4,1:4) + MElem(1:4,1:4);
    FGlobalUC(firstGroup) = FGlobalUC(firstGroup) + FElem(1:4);
    
    % First position of the higher order terms
    row2 = 3 + 2*(numElems) + numInternalShapes*(e-1);
    
    % Copy (N1 to N4) * (higher order terms)
    secondGroup = row2:(row2+numInternalShapes-1);
    % Upper right
    KGlobalUC(firstGroup, secondGroup) = KGlobalUC(firstGroup, secondGroup) + ...
        KElem(1:4, 5:end) + MElem(1:4, 5:end);
    % Lower left
    KGlobalUC(secondGroup, firstGroup) = ...
        KElem(5:end, 1:4) + MElem(5:end, 1:4);
    
    % Copy additional diagonal terms
    KGlobalUC(secondGroup, secondGroup) = KGlobalUC(secondGroup, secondGroup) + ...
        KElem(5:end, 5:end) + MElem(5:end, 5:end);
    FGlobalUC(secondGroup) = FGlobalUC(secondGroup) + FElem(5:end);

end