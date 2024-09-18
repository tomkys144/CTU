function plot_markers(mx, max_y)
    %PRINT_MARKERS Summary of this function goes here
    %   Detailed explanation goes here
    hold on

    for i = 1:length(mx)
        line([mx(i) mx(i)], [0 max_y], 'Color', 'y');
    end

end