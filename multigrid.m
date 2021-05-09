% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

function [u1] = multigrid(u0, b)
    n_interval_y = size(b, 1) - 1;
    n_interval_x = size(b, 2) - 1;
    dx = 1 / n_interval_y;
    % presmoothing
    for i = 1:5
        u0 = gauss(u0, b);
    end
    % calculate residual (Interpolating residual from fine to coarse grid is called Restriction)
    r = zeros(size(b));
    for i = 2:n_interval_y
        for j = 2:n_interval_x
            r(i,j) = b(i,j) - (u0(i-1, j) + u0(i+1, j) + u0(i, j-1) + u0(i, j+1) - 4 * u0(i, j)) / dx^2;
        end
    end
    % interpolate the residual r to coarse grid
    rc = zeros(fix(n_interval_y/2)+1, fix(n_interval_x/2)+1);
    rc(2:end-1, 2:end-1) = r(3:2:end-2, 3:2:end-2);
    % perform a few iterations (like 10 iterations) on the coarse grid
    du = zeros(size(rc));
    
    %% multigtid
    if size(rc, 1)< 4 % when we are at the coarsest grid  
        for i = 1:10
            du = gauss(du, rc);
        end
    else
        du = multigrid(du, rc);
    end
    %% two grid
%     for i = 1:10
%         du = gauss(du, rc);
%     end
    %%
        
    % interpolate the correction du to fine grid
    duf = zeros(size(b));
    duf(3:2:end-2, 3:2:end-2) = du(2:end-1, 2:end-1);
    duf(2:2:end-1, 3:2:end-2) = 0.5 * (duf(1:2:end-2, 3:2:end-2) + duf(3:2:end, 3:2:end-2));
    duf(:,2:2:end-1) = 0.5 * (duf(:,1:2:end-2) + duf(:,3:2:end));
    % add correction to the solution and perform iteratons on the fine grid
    u1 = u0 + duf; % duf almost the whole solution, but missing high frequency contents; u0 is only high frequency content
    for i = 1:5
        u1 = gauss(u1, b);
    end
    
end