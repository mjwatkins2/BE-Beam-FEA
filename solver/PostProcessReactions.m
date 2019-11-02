function PostProcessReactions(KGlobalUC, FGlobalUC, A, constrainNodeDisplacement, constrainNodeSlope)

RV = KGlobalUC*A-FGlobalUC;
forces = RV(constrainNodeDisplacement*2-1);
moments = -RV(constrainNodeSlope*2);

if ~isempty(forces)
    disp('Force reactions:');
    for n=1:length(forces)
        fprintf('\tNode %d: %0.3f\n', constrainNodeDisplacement(n), forces(n));
    end
end
if ~isempty(moments)
    disp('Moment reactions:');
    for n=1:length(moments)
        fprintf('\tNode %d: %0.3f\n', constrainNodeSlope(n), moments(n));
    end
end