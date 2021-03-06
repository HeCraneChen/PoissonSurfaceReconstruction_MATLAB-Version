% solving th 3D Poisson equation for elephant example d2u/dx2 + d2u/dy2 + d2u/dz2 = V
% This version considers non-uniform sampling by creating a vector field on edges first

%% step1 data prep

% fox = readmatrix('./Data/fox.txt');
horse = readmatrix('./Data/horse.txt');
horse1 = horse(1:4:end,:);
shape = horse1(:, 1:6);
% shape = fox(:, 1:6);
X = shape(:,1);
Y = shape(:,2);
Z = shape(:,3);
resx = 64; 
resy = 64;
resz = 64;
n_intervals = 64;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;
gridsize_z = (max(Z) - min(Z))/resz;
gridsize = max([gridsize_x, gridsize_y, gridsize_z]);
KNNradius = KNN(shape(:, 1:3),20);


%% step2 find matrix form of Poisson equation (calculate A and b using Stencils)

n_basis = n_intervals+1;
n_points = n_basis * n_basis * n_basis;


% calculate A and b

% using stencils to calculate A
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

% create a vector field
v = zeros(n_intervals, n_intervals, n_intervals);
V = zeros(2 * n_basis, 2 * n_basis, 2 * n_basis);
minX = min(X) - 0.5 * gridsize;
minY = min(Y) - 0.5 * gridsize;
minZ = min(Z) - 0.5 * gridsize;
% loop all the edges
for point_ind = 1:size(shape,1) 
    point_ind
    point = shape(point_ind, :);
    sample_radius = 1 / KNNradius(1,point_ind);
    x = point(1);
    y = point(2);
    z = point(3);
    nx = point(4);
    ny = point(5);
    nz = point(6);
    % loop all the edges
    % store nx data on edges parallel to x axis
%     "loop all the x edges"
    for i = 1.5:resx-0.5
        if x >= minX + gridsize * (i-2) & x < minX + gridsize * (i + 2)
            for j = 1:resy
                if y >= minY + gridsize * (j-2) & y < minY + gridsize * (j + 2)
                    for k = 1:resz 
                        if z >= minZ + gridsize * (k-2) & z < minZ + gridsize * (k + 2)
                            V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, nx, i, j, k, gridsize, minX, minY, minZ, sample_radius); 
                        end
                    end 
                end
            end
        end
    end 
    % store ny data on edges parallel to y axis
%      "loop all the y edges"
     for j = 1.5:resy-0.5
        if y >= minY + gridsize * (j-2) & y < minY + gridsize * (j + 2)
            for i = 1:resx
                if x >= minX + gridsize * (i-2) & x < minX + gridsize * (i + 2)
                    for k = 1:resz  
                        if z >= minZ + gridsize * (k-2) & z < minZ + gridsize * (k + 2)
                            V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, ny, i, j, k, gridsize, minX, minY, minZ, sample_radius);   
                        end
                    end 
                end
            end
         end
    end   
    % store nz data on edges parallel to z axis
%     "loop all the z edges"
    for k = 1.5:resz-0.5
        if z >= minZ + gridsize * (k-2) & z < minZ + gridsize * (k + 2)
            for i = 1:resx
                if x >= minX + gridsize * (i-2) & x < minX + gridsize * (i + 2)
                    for j = 1:resy  
                        if y >= minY + gridsize * (j-2) & y < minY + gridsize * (j + 2)
                            V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, nz, i, j, k, gridsize, minX, minY, minZ, sample_radius);   
                        end
                    end   
                end
            end
        end
    end 
end

% loop all the vertices to get right-hand side, each vertex is affected by
% six edges
b_grid = zeros(n_basis, n_basis, n_basis);
for i = 1:resx
   for j = 1:resy
        for k = 1:resz  
            i
            j
            k
            b_grid(i,j,k) = V(2*(i+0.5),2*j,2*k) + V(2*i,2*(j+0.5),2*k) + V(2*i,2*j,2*(k+0.5))...
                            - V(2*(i-0.5),2*j,2*k)- V(2*i,2*(j-0.5),2*k) - V(2*i,2*j,2*(k-0.5));                         
        end
    end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b = permute(b_grid, [3,2,1]);
b = b(:);
b_s = sparse(b);


figure(3)
spy(A_s)


%% step3 use direct method to solve Poisson equation
"start solving the equation"
% direct solver
% output_s = A_s \ b_s; 

% multigrid solver
for i = 1:10
    i
    u = multigrid3D(u, b_grid, gridsize);
end
"finished solving the equation"
output = full(output_s);
%% step4 visualize result
output = reshape(output, [n_basis, n_basis, n_basis]);
slice1 = squeeze(output(n_intervals/2,:,:));
slice2 = squeeze(output(:,n_intervals/2,:));
slice3 = squeeze(output(:,:,n_intervals/4));
figure(1)
heatmap(slice1);
figure(2)
heatmap(slice2);
figure(3)
heatmap(slice3);


save('indicator_function.mat', 'output');

































