% solving th 3D Poisson equation for elephant example d2u/dx2 + d2u/dy2 + d2u/dz2 = V
%% step1 data prep
function [output] = DirectFoxMethod(res, fox, gridsize)
    X = fox(:,1);
    Y = fox(:,2);
    Z = fox(:,3);
    
    n_intervals = res;
    resx = res;
    resy = res;
    resz = res;


    %% step2 find matrix form of Poisson equation (calculate A and b using Stencils)
    n_basis = n_intervals+1;
    n_points = n_basis * n_basis * n_basis;
    n_interior = n_intervals - 1;
    % calculate A and b

    % using stencils to calculate A
    
    A = zeros(n_points);
    A = A + diag(ones(1, n_basis^3)*6*(1./gridsize));
    A = A + diag((-1) * (ones(1, n_basis^3-1)*(1./gridsize)), 1);
    A = A + diag((-1) * (ones(1, n_basis^3-1)*(1./gridsize)), -1);
    A = A + diag((-1) * (ones(1, n_basis^3-n_basis)*(1./gridsize)), n_basis);
    A = A + diag((-1) * (ones(1, n_basis^3-n_basis)*(1./gridsize)), -n_basis);
    A = A + diag((-1) * (ones(1, n_basis^3-n_basis^2)*(1./gridsize)), n_basis^2);
    A = A + diag((-1) * (ones(1, n_basis^3-n_basis^2)*(1./gridsize)), -n_basis^2);

    % using the rasterized points to calculate b, then vectorize it into a
    % column vector

    b_grid = zeros(n_basis, n_basis, n_basis);

    for point_ind = 1:size(fox,1)
        point = fox(point_ind, :);
        x = point(1);
        y = point(2);
        z = point(3);
        nx = point(4);
        ny = point(5);
        nz = point(6);
        for i = 1:resx
            if x >= min(X) + gridsize * (i-1) & x < min(X) + gridsize * i
                for j = 1:resy
                    if y >= min(Y) + gridsize * (j-1) & y < min(Y) + gridsize * j
                        for k = 1:resz
                            if z >= min(Z) + gridsize * (k-1) & z < min(Z) + gridsize * k
                              
                                b_grid(i,j,k) = b_grid(i,j,k) + (nx+ny+nz);
                                b_grid(i,j,k+1) = b_grid(i,j,k+1) + (nx+ny-nz);
                                b_grid(i,j+1,k) = b_grid(i,j+1,k) + (nx-ny+nz);
                                b_grid(i+1,j,k) = b_grid(i+1,j,k) + (-nx+ny+nz);
                                b_grid(i,j+1,k+1) = b_grid(i,j+1,k+1) + (nx-ny-nz);
                                b_grid(i+1,j+1,k) = b_grid(i+1,j+1,k) + (-nx-ny+nz);
                                b_grid(i+1,j,k+1) = b_grid(i+1,j,k+1) + (-nx+ny-nz);
                                b_grid(i+1,j+1,k+1) = b_grid(i+1,j+1,k+1) + (-nx-ny-nz);

                            end
                       end
                    end
                end
            end
        end

    end


    b = permute(b_grid, [3,2,1]);
    b = b(:);

%     figure(3)
%     spy(A)


    %% step3 use direct method to solve Poisson equation
    output = A \ b;

    %% step4 visualize result
    output = reshape(output, [n_basis, n_basis, n_basis]);


end












