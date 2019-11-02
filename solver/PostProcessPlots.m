function PostProcessPlots(nodes, AElems, E, I)

    figure;
    clf;
    subplot(3,1,1);
    hold on;
    xlabel('x');
    ylabel('Displacement (w)');
    subplot(3,1,2);
    hold on;
    xlabel('x');
    ylabel('Shear (V)');
    subplot(3,1,3);
    hold on;
    xlabel('x');
    ylabel('Bending Moment (M)');

    npts = 50;
    xi = linspace(-1,1,npts);
    numElems = length(nodes)-1;

    for e = 1:numElems

        [x, w, V, M] = PostProcessElement(E, I, nodes(e), nodes(e+1), AElems(e,:), xi);
        
        subplot(3,1,1);
        plot(x,w);
        hold on;
        plot(x(1),w(1),'ko');
        plot(x(end),w(end),'ko');
        
        subplot(3,1,3);
        plot(x,M);
        
        subplot(3,1,2);
        plot(x,V);
    end

    plotZero(1, 0, nodes(end));
    plotZero(2, 0, nodes(end));
    plotZero(3, 0, nodes(end));

    AdjustYAxis(1);
    AdjustYAxis(2);
    AdjustYAxis(3);

function plotZero(which, x0, xl)
    subplot(3,1,which);
    hold on;
    plot([x0 xl], [0 0], 'k:');

function AdjustYAxis(which)

    subplot(3,1,which);
    lim = ylim;
    diff = lim(2) - lim(1);
    if max(abs([lim(1) lim(2)])) < 1e-12
        diff = 1;
    elseif diff/max(abs([lim(1) lim(2)])) < 1e-9
        diff = max(abs([lim(1) lim(2)]));
    end
    ymin = lim(1)-diff*.1;
    ymax = lim(2)+diff*.1;
    ylim([ymin ymax]);
