function [wanted, bins] = calculate_histogram(signal, f_max)
    %CALCULATE_HISTOGRAM Summary of this function goes here
    %   Detailed explanation goes here
    wanted = [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 1000]; % value can be more than 100 % theoreticaly, lets put here 1000 %
    thresholds = wanted / 100 * f_max;

    bins = zeros(size(wanted));

    for i = 1:length(signal)

        for j = 1:length(thresholds) - 1

            if (signal(i) >= thresholds(j) && signal(i) < thresholds(j + 1))
                bins(j) = bins(j) + 1;

                continue
            end

        end

    end

    max_value = max(bins) / 100;
    
    bins = bins ./ sum(bins) * 100;

    wanted(wanted == 1000) = 100;
end
