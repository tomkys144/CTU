function [range_s1, range_s2, range_s3, range_s4, range_g1, range_g2, range_g3, range_g4] = select_ranges(x, markers, shimmer1, geta1, shimmer2, geta2, shimmer3, geta3, shimmer4, geta4)
    range_s1 = [];
    range_s2 = [];
    range_s3 = [];
    range_s4 = [];

    range_g1 = [];
    range_g2 = [];
    range_g3 = [];
    range_g4 = [];

    for i = 1:length(markers) - 1

        if any(and(x >= markers(i), x <= markers(i + 1)))
            range_s1 = [range_s1; shimmer1(markers(i):markers(i + 1))];
            range_s2 = [range_s2; shimmer2(markers(i):markers(i + 1))];
            range_s3 = [range_s3; shimmer3(markers(i):markers(i + 1))];
            range_s4 = [range_s4; shimmer4(markers(i):markers(i + 1))];

            range_g2 = [range_g2; geta2(markers(i):markers(i + 1))];
            range_g3 = [range_g3; geta3(markers(i):markers(i + 1))];
            range_g4 = [range_g4; geta4(markers(i):markers(i + 1))];
            range_g1 = [range_g1; geta1(markers(i):markers(i + 1))];
        end

    end

    if any(x >= markers(end))
        range_s1 = [range_s1; shimmer1(markers(end):end)];
        range_s2 = [range_s2; shimmer2(markers(end):end)];
        range_s3 = [range_s3; shimmer3(markers(end):end)];
        range_s4 = [range_s4; shimmer4(markers(end):end)];

        range_g2 = [range_g2; geta2(markers(end):end)];
        range_g3 = [range_g3; geta3(markers(end):end)];
        range_g4 = [range_g4; geta4(markers(end):end)];
        range_g1 = [range_g1; geta1(markers(end):end)];
    end

end
