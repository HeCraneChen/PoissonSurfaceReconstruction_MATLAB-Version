% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021
% This code implements Jacobi method
function u1 = jacobi(u0, b)
    n_interval_y = size(b, 1) - 1;
    n_interval_x = size(b, 2) - 1;
    dx = 1 / n_interval_y;
    u1 = -dx^2/4 * b;
    for i = 2:n_interval_y
        for j = 2:n_interval_x
            u1(i,j) = u1(i,j) + (u0(i-1,j) + u0(i+1,j) + u0(i,j-1) + u0(i,j+1))/4;
        end
    end
end
