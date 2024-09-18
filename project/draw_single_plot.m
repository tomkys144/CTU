function draw_single_plot(markers, shimmer, geta, fmax)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    shimmer_n = shimmer/mean(shimmer);
    geta_n = geta/mean(geta);
    fmax_n = fmax ./ [mean(shimmer); mean(geta)];

    hold on
    plot(shimmer_n);
    plot(geta_n);
    line([0 length(shimmer_n)], [1 1] * fmax_n(1), "Color", '#0072BD', 'LineStyle', '--');
    line([0 length(geta_n)], [1 1] * fmax_n(2), "Color", '#D95319', 'LineStyle', '--');
    ylim([-0.5, max(fmax_n(:)) * 1.2])
    plot_markers(markers, max(max(shimmer_n), max(geta_n)))

    legend('Shimmer', 'Geta', 'Shimmer F_{max}', 'Geta F_{max}')
end