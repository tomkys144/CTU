function M = get_mask(GxA, GyA, GxB, GyB)
    isize = size(GxA);

    GA = sqrt(GxA.^2 + GyA.^2);
    GB = sqrt(GxB.^2 + GyB.^2);

    M = zeros(isize);
    for i=1:isize(1)
        for j=1:isize(2)
            if GA(i,j,:) <= GB(i,j,:)
                M(i,j,:) = 255;
            end
        end
    end
end
