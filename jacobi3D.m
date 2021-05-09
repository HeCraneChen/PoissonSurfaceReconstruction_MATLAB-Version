% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021
% This code implements Jacobi method in 3D
function u1 = jacobi3D(u0, b, dx)
    n_interval = size(b, 1) - 1;
    u1 = (dx^4 / 6) * b;
    for i = 2:n_interval
        for j = 2:n_interval
            for k = 2:n_interval
                u1(i,j,k) = u1(i,j,k) +  dx^2 * (u0(i-1,j,k) + u0(i+1,j,k) + u0(i,j-1,k) + u0(i,j+1,k) + u0(i,j,k-1) + u0(i,j,k+1))/6;
            end
        end
    end
end