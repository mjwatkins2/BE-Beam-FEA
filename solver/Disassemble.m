function AElem = Disassemble(nodes, p, A)
% Determines element-level solution vectors from global solution vector.
% nodes: Vector of x-coordinates of nodes.
% p: Polynomial order to use for shape functions.
% A: Global solution vector.
% AElem: Matrix of element-level solution vectors (Each element on one row)

numElems = length(nodes)-1;
numInternalShapes = p-3;
AElem = zeros(numElems, 4+numInternalShapes);

for e=1:numElems
    
    % First position of the 4x4 overlapping matrix
    row1 = 2*(e-1)+1;
    firstGroup = row1:(row1+3);
    
    % First position of the higher order terms
    row2 = 3 + 2*(numElems) + numInternalShapes*(e-1);
    secondGroup = row2:(row2+numInternalShapes-1);
    
    local = [firstGroup secondGroup];
    AElem(e,:) = A(local);
    
end