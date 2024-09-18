function [Gx, Gy] = merge_grad(GxA, GyA, GxB, GyB, M)
    isize = size(GxA);

    Gx = zeros(isize);
    Gy = zeros(isize);

    for i=1:isize(1)
        for j=1:isize(2)
            if M(i,j,1) == 0 && M(i,j,2) == 0 && M(i,j,3) == 0
                Gx(i,j,:) = GxA(i,j,:);
                Gy(i,j,:) = GyA(i,j,:);
            else
                Gx(i,j,:) = GxB(i,j,:);
                Gy(i,j,:) = GyB(i,j,:);
            end
        end
    end
end
