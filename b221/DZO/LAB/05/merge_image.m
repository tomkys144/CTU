function O = merge_image(A, B, M)
    isize = size(A);

    O = zeros(isize);

    for i=1:isize(1)
        for j=1:isize(2)
            if M(i,j,1) == 0 && M(i,j,2) == 0 && M(i,j,3) == 0
                O(i,j,:) = A(i,j,:);
            else
                O(i,j,:) = B(i,j,:);
            end
        end
    end
end
