function draw_plots(markers, shimmer1, geta1, shimmer2, geta2, shimmer3, geta3, shimmer4, geta4, fmax)
    draw_fmax = exist("fmax", "var");

    %% normalize
    norm_s1 = mean(shimmer1);
    norm_s2 = mean(shimmer2);
    norm_s3 = mean(shimmer3);
    norm_s4 = mean(shimmer4);
    norm_g1 = mean(geta1);
    norm_g2 = mean(geta2);
    norm_g3 = mean(geta3);
    norm_g4 = mean(geta4);

    if draw_fmax
        norm_fmax = [norm_s1, norm_s2, norm_s3, norm_s4; norm_g1, norm_g2, norm_g3, norm_g4];
        fmax_n = fmax ./ norm_fmax;
    end

    shimmer1_n = shimmer1 / norm_s1;
    shimmer2_n = shimmer2 / norm_s2;
    shimmer3_n = shimmer3 / norm_s3;
    shimmer4_n = shimmer4 / norm_s4;
    geta1_n = geta1 / norm_g1;
    geta2_n = geta2 / norm_g2;
    geta3_n = geta3 / norm_g3;
    geta4_n = geta4 / norm_g4;

    %% plot
    subplot(221)
    hold on
    plot(shimmer1_n, "Color", '#0072BD')
    plot(geta1_n, "Color", '#D95319')

    if draw_fmax
        line([0 length(shimmer1)], [1 1] * fmax_n(1), "Color", '#0072BD', 'LineStyle', '--');
        line([0 length(geta1)], [1 1] * fmax_n(2), "Color", '#D95319', 'LineStyle', '--');
        ylim([-0.5, max(fmax_n(:)) * 1.2])
    end

    plot_markers(markers, max(max(shimmer1_n), max(geta1_n)))
    title('Channel 1')

    if draw_fmax
        legend('Shimmer', 'Geta', 'Shimmer F_{max}', 'Geta F_{max}')
    else
        legend('Shimmer', 'Geta')
    end

    subplot(222)
    hold on
    plot(shimmer2_n, "Color", '#0072BD')
    plot(geta2_n, "Color", '#D95319')

    if draw_fmax
        line([0 length(shimmer2)], [1 1] * fmax_n(1, 2), "Color", '#0072BD', 'LineStyle', '--');
        line([0 length(geta2)], [1 1] * fmax_n(2, 2), "Color", '#D95319', 'LineStyle', '--');
        ylim([-0.5, max(fmax_n(:, 2)) * 1.2])
    end

    plot_markers(markers, max(max(shimmer2_n), max(geta2_n)))
    title('Channel 2')

    if draw_fmax
        legend('Shimmer', 'Geta', 'Shimmer F_{max}', 'Geta F_{max}')
    else
        legend('Shimmer', 'Geta')
    end

    subplot(223)
    hold on
    plot(shimmer3_n, "Color", '#0072BD')
    plot(geta3_n, "Color", '#D95319')

    if draw_fmax
        line([0 length(shimmer3)], [1 1] * fmax_n(1, 3), "Color", '#0072BD', 'LineStyle', '--');
        line([0 length(geta3)], [1 1] * fmax_n(2, 3), "Color", '#D95319', 'LineStyle', '--');
        ylim([-0.5, max(fmax_n(:, 3)) * 1.2])
    end

    plot_markers(markers, max(max(shimmer3_n), max(geta3_n)))
    title('Channel 3')

    if draw_fmax
        legend('Shimmer', 'Geta', 'Shimmer F_{max}', 'Geta F_{max}')
    else
        legend('Shimmer', 'Geta')
    end

    subplot(224)
    hold on
    plot(shimmer4_n, "Color", '#0072BD')
    plot(geta4_n, "Color", '#D95319')

    if draw_fmax
        line([0 length(shimmer4)], [1 1] * fmax_n(1, 4), "Color", '#0072BD', 'LineStyle', '--');
        line([0 length(geta4)], [1 1] * fmax_n(2, 4), "Color", '#D95319', 'LineStyle', '--');
        ylim([-0.5, max(fmax_n(:, 4)) * 1.2])
    end

    plot_markers(markers, max(max(shimmer4_n), max(geta4_n)))
    title('Channel 4')

    if draw_fmax
        legend('Shimmer', 'Geta', 'Shimmer F_{max}', 'Geta F_{max}')
    else
        legend('Shimmer', 'Geta')
    end

end
