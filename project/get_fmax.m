function [fmax] = get_fmax(markers, shimmer1, geta1, shimmer2, geta2, shimmer3, geta3, shimmer4, geta4)
    fig_fmax = figure("Units", "normalized", "OuterPosition", [0 0 1 1]);
    draw_plots(markers, shimmer1, geta1, shimmer2, geta2, shimmer3, geta3, shimmer4, geta4)
    sgtitle("Select F_{max} range(s) (Click between markers)")

    [x, ~] = ginput();
    x = x + 1;

    [range_s1, range_s2, range_s3, range_s4, range_g1, range_g2, range_g3, range_g4] = select_ranges(x, markers, shimmer1, geta1, shimmer2, geta2, shimmer3, geta3, shimmer4, geta4);

    fmax = zeros([2, 4]);

    fmax(1, 1) = max(range_s1) * 0.95;
    fmax(1, 2) = max(range_s2) * 0.95;
    fmax(1, 3) = max(range_s3) * 0.95;
    fmax(1, 4) = max(range_s4) * 0.95;

    fmax(2, 1) = max(range_g1) * 0.95;
    fmax(2, 2) = max(range_g2) * 0.95;
    fmax(2, 3) = max(range_g3) * 0.95;
    fmax(2, 4) = max(range_g4) * 0.95;

    close(fig_fmax)
end
