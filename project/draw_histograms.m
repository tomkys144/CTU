function draw_histograms(wanted, shimmer, geta)
    plot_both = ~isempty(shimmer) && ~isempty(geta);

    if plot_both
        %%% Shimmer
        subplot(421)
        bar(wanted, shimmer(:, 1))
        title('Shimmer channel 1')

        subplot(423)
        bar(wanted, shimmer(:, 2))
        title('Shimmer channel 2')

        subplot(425)
        bar(wanted, shimmer(:, 3))
        title('Shimmer channel 3')

        subplot(427)
        bar(wanted, shimmer(:, 4))
        title('Shimmer channel 4')

        %%% Geta
        subplot(422)
        bar(wanted, geta(:, 1))
        title('Geta channel 1')

        subplot(424)
        bar(wanted, geta(:, 2))
        title('Geta channel 2')

        subplot(426)
        bar(wanted, geta(:, 3))
        title('Geta channel 3')

        subplot(428)
        bar(wanted, geta(:, 4))
        title('Geta channel 4')

        return
    end

    if ~isempty(shimmer)
        subplot(221)
        bar(wanted, shimmer(:, 1))
        title('Shimmer channel 1')

        subplot(222)
        bar(wanted, shimmer(:, 2))
        title('Shimmer channel 2')

        subplot(223)
        bar(wanted, shimmer(:, 3))
        title('Shimmer channel 3')

        subplot(224)
        bar(wanted, shimmer(:, 4))
        title('Shimmer channel 4')

        return
    end

    if ~isempty(geta)
        subplot(221)
        bar(wanted, geta(:, 1))
        title('Geta channel 1')

        subplot(222)
        bar(wanted, geta(:, 2))
        title('Geta channel 2')

        subplot(223)
        bar(wanted, geta(:, 3))
        title('Geta channel 3')

        subplot(224)
        bar(wanted, geta(:, 4))
        title('Geta channel 4')

        return
    end

end
