% solving th 3D Poisson equation for elephant example d2u/dx2 + d2u/dy2 + d2u/dz2 = V

%% step1 data prep

fox = readmatrix('fox.txt');
fox = fox(:, 1:6);
X = fox(:,1);
Y = fox(:,2);
Z = fox(:,3);
% resx = 128; 
% resy = 128;
% resz = 128;
% n_intervals = 128;
resx = 256; 
resy = 256;
resz = 256;
n_intervals = 256;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;
gridsize_z = (max(Z) - min(Z))/resz;
gridsize = max([gridsize_x, gridsize_y, gridsize_z]);


%% step2 find matrix form of Poisson equation (calculate A and b using Stencils)

n_elements = n_intervals * n_intervals;
n_basis = n_intervals+1;
n_points = n_basis * n_basis * n_basis;


% calculate b


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
                            i
                            j
                            k
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

b = b_grid;
u = zeros(size(b_grid)); % Set the initial guess to be all zero


%% step3 use direct method to solve Poisson equation
% for i = 1:100
%     u = jacobi3D(u, b, gridsize);
% %     u = gauss3D(u, b, gridsize);
% end

%% step3.5 another option: use Multigrid Solver method to solve Poisson equation
for i = 1:50
    u = multigrid3D(u, b, gridsize);
end

%% step4 visualize result
output = reshape(u, [n_basis, n_basis, n_basis]);
slice1 = squeeze(output(n_intervals/2,:,:));
slice2 = squeeze(output(:,n_intervals/2,:));
slice3 = squeeze(output(:,:,n_intervals/2));
figure(1)
heatmap(slice1);
figure(2)
heatmap(slice2);
figure(3)
heatmap(slice3);

save('indicator_function.mat', 'output');














