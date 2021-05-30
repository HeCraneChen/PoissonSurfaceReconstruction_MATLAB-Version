% solving th 3D Poisson equation for elephant example d2u/dx2 + d2u/dy2 + d2u/dz2 = V

%% step1 data prep

% fox = readmatrix('./Data/cube.txt');
fox = readmatrix('./Data/fox.txt');
fox_sdf = readNPY('./Data/sdf_fox_64.npy');
fox = fox(:, 1:6);
X = fox(:,1);
Y = fox(:,2);
Z = fox(:,3);
resx = 64; 
resy = 64;
resz = 64;
n_intervals = 64;
% resx = 128; 
% resy = 128;
% resz = 128;
% n_intervals = 128;
% resx = 16; 
% resy = 16;
% resz = 16;
% n_intervals = 16;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;
gridsize_z = (max(Z) - min(Z))/resz;
gridsize = max([gridsize_x, gridsize_y, gridsize_z]);
densities = KNN(fox(:, 1:3),20);


%% step2 find matrix form of Poisson equation (calculate A and b using Stencils)

n_elements = n_intervals * n_intervals;
n_basis = n_intervals+1;
n_points = n_basis * n_basis * n_basis;


% calculate A and b

% using stencils to calculate A
% A = zeros(n_points);
% A = A + diag(ones(1, n_basis^3)*6*(1./gridsize));
% A = A + diag((-1) * (ones(1, n_basis^3-1)*(1./gridsize)), 1);
% A = A + diag((-1) * (ones(1, n_basis^3-1)*(1./gridsize)), -1);
% A = A + diag((-1) * (ones(1, n_basis^3-n_basis)*(1./gridsize)), n_basis);
% A = A + diag((-1) * (ones(1, n_basis^3-n_basis)*(1./gridsize)), -n_basis);
% A = A + diag((-1) * (ones(1, n_basis^3-n_basis^2)*(1./gridsize)), n_basis^2);
% A = A + diag((-1) * (ones(1, n_basis^3-n_basis^2)*(1./gridsize)), -n_basis^2);


A_s = sparse(n_points, n_points);
B1 = ones(n_basis^3, 1)*6*(1./gridsize);
d1 = [0];
A_s = A_s + spdiags(B1,d1,n_points,n_points);

B2 = (-1) * ones(n_basis^3-1, 1)*(1./gridsize);
B2 = [0; B2];
d2 = [1];
A_s = A_s + spdiags(B2,d2,n_points,n_points);

B3 = (-1) * ones(n_basis^3-1, 1)*(1./gridsize);
B3 = [B3; 0];
d3 = [-1];
A_s = A_s + spdiags(B3,d3,n_points,n_points);

B4 = (-1) * ones(n_basis^3-n_basis, 1)*(1./gridsize);
zero_pad = zeros(n_basis,1);
B4 = [zero_pad; B4];
d4 = [n_basis];
A_s = A_s + spdiags(B4,d4,n_points,n_points);

B5 = (-1) * ones(n_basis^3-n_basis, 1)*(1./gridsize);
zero_pad = zeros(n_basis,1);
B5 = [B5;zero_pad];
d5 = [-n_basis];
A_s = A_s + spdiags(B5,d5,n_points,n_points);

B6 = (-1) * ones(n_basis^3-n_basis^2, 1)*(1./gridsize);
zero_pad = zeros(n_basis^2,1);
B6 = [zero_pad; B6];
d6 = [n_basis^2];
A_s = A_s + spdiags(B6,d6,n_points,n_points);

B7 = (-1) * ones(n_basis^3-n_basis^2, 1)*(1./gridsize);
zero_pad = zeros(n_basis^2,1);
B7 = [B7;zero_pad];
d7 = [-n_basis^2];
A_s = A_s + spdiags(B7,d7,n_points,n_points);

% using the rasterized points to calculate b, then vectorize it into a
% column vector

b_grid = zeros(n_basis, n_basis, n_basis);
% gt_grid = zeros(n_basis, n_basis, n_basis);
% b_grid_s = sparse(n_basis, n_basis, n_basis);

for point_ind = 1:size(fox,1)
    point = fox(point_ind, :);
    density = densities(1,point_ind);
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
                            i
                            j
                            k
%                             gt_grid(i,j,k) = gt_grid(i,j,k) + density;
%                             gt_grid(i,j,k+1) = gt_grid(i,j,k+1) + density;
%                             gt_grid(i,j+1,k) = gt_grid(i,j+1,k) + density;
%                             gt_grid(i+1,j,k) = gt_grid(i+1,j,k) + density;
%                             gt_grid(i,j+1,k+1) = gt_grid(i,j+1,k+1) + density;
%                             gt_grid(i+1,j+1,k) = gt_grid(i+1,j+1,k) + density;
%                             gt_grid(i+1,j,k+1) = gt_grid(i+1,j,k+1) + density;
%                             gt_grid(i+1,j+1,k+1) = gt_grid(i+1,j+1,k+1) + density;
                            
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
b_s = sparse(b);
% b_grid_s = sparse(b_grid);
% b_s = permute(b_grid_s, [3,2,1]);
% b_s = b_s(:);

figure(3)
spy(A_s)


%% step3 use direct method to solve Poisson equation
"start solving the equation"
% output = A \ b;
output_s = A_s \ b_s;
"finished solving the equation"
output = full(output_s);
%% step4 visualize result
output = reshape(output, [n_basis, n_basis, n_basis]);
slice1 = squeeze(output(n_intervals/2,:,:));
slice2 = squeeze(output(:,n_intervals/2,:));
slice3 = squeeze(output(:,:,n_intervals/2));
figure(1)
heatmap(slice1);
figure(2)
heatmap(slice2);
figure(3)
heatmap(slice3);

stencil1 = slice1 > 0.005;
stencil2 = slice2 > 0.005;
stencil3 = slice3 > 0.005;
stencil_sum = sum(slice1.*stencil1 + slice2.*stencil2 + slice3.*stencil3,'all');
ele_num = sum(stencil1,'all') + sum(stencil2,'all') + sum(stencil3,'all');
isovalue = stencil_sum / ele_num;



slice1_gt = squeeze(fox_sdf(n_intervals/2,:,:));
slice2_gt = squeeze(fox_sdf(:,n_intervals/2,:));
slice3_gt = squeeze(fox_sdf(:,:,n_intervals/2));
figure(4)
heatmap(slice1_gt);
figure(5)
heatmap(slice2_gt);
figure(6)
heatmap(slice3_gt);

save('indicator_function.mat', 'output');


% isomatrix = output.*gt_grid;
% N = sum(gt_grid, 'all');
% isovalue = sum(isomatrix, 'all')/N













