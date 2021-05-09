% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

function [u1] = multigrid3Dv2(u0, b, dx, dy, dz)
    n_interval = size(b, 1) - 1;
    % presmoothing
    for i = 1:5
        u0 = gauss3Dv2(u0, b, dx, dy, dz);
    end
    % calculate residual (Interpolating residual from fine to coarse grid is called Restriction)
    r = zeros(size(b));
    for i = 2:n_interval
        for j = 2:n_interval
            for k = 2:n_interval
                % dx, dy, dz are equal
%                 r(i,j,k) = b(i,j,k) - (u0(i-1, j, k) + u0(i+1, j, k) + u0(i, j-1, k) + u0(i, j+1, k) + u0(i, j, k-1) + u0(i, j, k+1) - 6 * u0(i, j, k)) / dx^2; % dx == dy == dz
                
                % dx, dy, dz are not equal
                r(i,j,k) = b(i,j,k) - ( dy^2 * dz^2 * (u0(i-1, j, k) + u0(i+1, j, k)) + dx^2 * dz^2 * (u0(i, j-1, k) + u0(i, j+1, k)) + dx^2 * dy^2 * (u0(i, j, k-1) + u0(i, j, k+1)) - 2 * (dx^2 + dy^2 + dz^2) * u0(i, j, k)) / (dx^2 * dy^2 * dz^2);
            end
        end
    end
    %%%%%%%%%%%%%% interpolate the residual r to coarse grid %%%%%%%%%%%%%% Restriction
    rc = zeros(fix(n_interval/2)+1, fix(n_interval/2)+1, fix(n_interval/2)+1);
    rc(2:end-1, 2:end-1, 2:end-1) = r(3:2:end-2, 3:2:end-2, 3:2:end-2);
    % perform a few iterations (like 10 iterations) on the coarse grid
    du = zeros(size(rc));
    
    %% multigtid
    if size(rc, 1)< 4 % when we are at the coarsest grid  
        for i = 1:10
            du = gauss3Dv2(du, rc, dx, dy, dz);
        end
    else
        du = multigrid3Dv2(du, rc, dx, dy, dz);
    end
    %% two grid
%     for i = 1:10
%         du = gauss(du, rc);
%     end
    %%
        
    %%%%%%%%%%%%%%%% interpolate the correction du to fine grid %%%%%%%%%%%%%%%%% Prolongation
    duf = zeros(size(b));
    duf(3:2:end-2, 3:2:end-2, 3:2:end-2) = du(2:end-1, 2:end-1, 2:end-1); % the same points, don't need interpolation, copied according to Restriction process
    duf(2:2:end-1, 3:2:end-2, 3:2:end-2) = 0.5 * (duf(1:2:end-2, 3:2:end-2, 3:2:end-2) + duf(3:2:end, 3:2:end-2, 3:2:end-2)); % linear interpolation in x direction
    duf(:,2:2:end-1, 3:2:end-2) = 0.5 * (duf(:,1:2:end-2, 3:2:end-2) + duf(:,3:2:end, 3:2:end-2)); % linear interpolation in y direction
    duf(:,:,2:2:end-1) = 0.5 * (duf(:,:,1:2:end-2) + duf(:,:,3:2:end)); % linear interpolation in z direction
    % add correction to the solution and perform iteratons on the fine grid
    u1 = u0 + duf; % duf almost the whole solution, but missing high frequency contents; u0 is only high frequency content
    for i = 1:5
        u1 = gauss3Dv2(u1, b, dx, dy, dz);
    end
    
end