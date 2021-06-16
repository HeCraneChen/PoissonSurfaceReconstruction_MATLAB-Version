% solving th 3D Poisson equation for elephant example d2u/dx2 + d2u/dy2 + d2u/dz2 = V
% This version considers non-uniform sampling by creating a vector field on edges first

%% step1 data prep

% fox = readmatrix('./Data/fox.txt');
horse = readmatrix('./Data/horse.txt');
fox_sdf = readNPY('./Data/sdf_fox_64.npy');
horse1 = horse(1:4:end,:);
fox = horse1(:, 1:6);
% fox = fox(:, 1:6);
X = fox(:,1);
Y = fox(:,2);
Z = fox(:,3);
resx = 64; 
resy = 64;
resz = 64;
n_intervals = 64;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;
gridsize_z = (max(Z) - min(Z))/resz;
gridsize = max([gridsize_x, gridsize_y, gridsize_z]);
KNNradius = KNN(fox(:, 1:3),20);


%% step2 find matrix form of Poisson equation (calculate A and b using Stencils)

n_elements = n_intervals * n_intervals;
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%to be pondered%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a vector field
all_sigma_weight = zeros(1,size(fox,1));
all_sigma_weight0 = zeros(1,size(fox,1));
v = zeros(n_intervals, n_intervals, n_intervals);
V = zeros(2 * n_basis, 2 * n_basis, 2 * n_basis);
minX = min(X) - 0.5 * gridsize;
minY = min(Y) - 0.5 * gridsize;
minZ = min(Z) - 0.5 * gridsize;
% loop all the edges
for point_ind = 1:size(fox,1) 
    point_ind
    point = fox(point_ind, :);
    sample_radius = KNNradius(1,point_ind);
    x = point(1);
    y = point(2);
    z = point(3);
    nx = point(4) * sample_radius^2;
    ny = point(5) * sample_radius^2;
    nz = point(6) * sample_radius^2;
    % loop all the edges
    % store nx data on edges parallel to x axis
    for i = 1.5:resx-0.5
        for j = 1:resy
            for k = 1:resz   
                V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, nx, i, j, k, gridsize, minX, minY, minZ, sample_radius);   
             end            
        end
    end 
    % store ny data on edges parallel to y axis
    for j = 1.5:resy-0.5
        for i = 1:resx
            for k = 1:resz   
                V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, ny, i, j, k, gridsize, minX, minY, minZ, density);   
             end            
        end
    end    
    % store nz data on edges parallel to z axis
    for k = 1.5:resz-0.5
        for i = 1:resx
            for j = 1:resy  
                V(2*i,2*j,2*k) = Vfield(V(2*i,2*j,2*k), x, y, z, nz, i, j, k, gridsize, minX, minY, minZ, density);   
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
slice3 = squeeze(output(:,:,n_intervals/4));
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



% slice1_gt = squeeze(fox_sdf(n_intervals/2,:,:));
% slice2_gt = squeeze(fox_sdf(:,n_intervals/2,:));
% slice3_gt = squeeze(fox_sdf(:,:,n_intervals/2));
% figure(4)
% heatmap(slice1_gt);
% figure(5)
% heatmap(slice2_gt);
% figure(6)
% heatmap(slice3_gt);

save('indicator_function.mat', 'output');


% isomatrix = output.*gt_grid;
% N = sum(gt_grid, 'all');
% isovalue = sum(isomatrix, 'all')/N

















% for point_ind = 1:size(fox,1)
%     point = fox(point_ind, :);
%     density = densities(1,point_ind);
%     sigma_weight0 = (density - minKNN) / (maxKNN - minKNN); % the smaller, the denser; get NaN error if applying this to Sigma
%     sigma_weight = 1 / (1 + exp(-density));
%     all_sigma_weight0(point_ind) = sigma_weight0; % mode 0, median  0.0821, mean 0.1080, var 0.0113
%     all_sigma_weight(point_ind) = sigma_weight; % mode 0.5004 , median  0.5052, mean 0.5067, var  3.9010e-05
%     x = point(1);
%     y = point(2);
%     z = point(3);
%     nx = point(4) * density;
%     ny = point(5) * density;
%     nz = point(6) * density;
%     for i = 1:resx-1
%         if x >= minX + gridsize * (i-1) & x < minX + gridsize * i
% %           if x >= minX + gridsize * (i-2) & x < minX + gridsize * (i+2)
%             for j = 1:resy-1
% %                  if y >= minY + gridsize * (j-2) & y < minY + gridsize * (j+2)
%                 if y >= minY + gridsize * (j-1) & y < minY + gridsize * j
%                     for k = 1:resz-1
% %                         if z >= minZ + gridsize * (k-2) & z < minZ + gridsize * (k+2)
%                         if z >= minZ + gridsize * (k-1) & z < minZ + gridsize * k
%                             i
%                             j
%                             k   
%                             V(2*(i+0.5),2*j,2*k) = Vfield(V(2*(i+0.5),2*j,2*k), x, y, z, nx, ny, nz, i+0.5, j, k, gridsize, i, j, k, minX, minY, minZ, sigma_weight);  
%                             V(2*i,2*(j+0.5),2*k) = Vfield(V(2*i,2*(j+0.5),2*k), x, y, z, nx, ny, nz, i, j+0.5, k, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*i,2*j,2*(k+0.5)) = Vfield(V(2*i,2*j,2*(k+0.5)), x, y, z, nx, ny, nz, i, j, k+0.5, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
% 
%                             V(2*(i+1-0.5),2*(j+1),2*k) = Vfield(V(2*(i+1-0.5),2*(j+1),2*k), x, y, z, nx, ny, nz, i+1-0.5, j+1, k, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*(i+1),2*(j+1-0.5),2*k) = Vfield(V(2*(i+1),2*(j+1-0.5),2*k), x, y, z, nx, ny, nz, i+1, j+1-0.5, k, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*(i+1),2*(j+1),2*(k+0.5)) = Vfield(V(2*(i+1),2*(j+1),2*(k+0.5)), x, y, z, nx, ny, nz, i+1, j+1, k+0.5, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
% 
%                             V(2*(i+1-0.5),2*(j),2*(k+1)) = Vfield(V(2*(i+1-0.5),2*(j),2*(k+1)), x, y, z, nx, ny, nz, i+1-0.5, j, k+1, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*(i+1),2*(j+0.5),2*(k+1)) = Vfield(V(2*(i+1),2*(j+0.5),2*(k+1)), x, y, z, nx, ny, nz, i+1, j+0.5, k+1, gridsize, i, j, k, minX, minY, minZ, sigma_weight);
%                             V(2*(i+1),2*(j),2*(k+1-0.5)) = Vfield(V(2*(i+1),2*(j),2*(k+1-0.5)), x, y, z, nx, ny, nz, i+1, j, k+1-0.5, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
% 
%                             V(2*(i+0.5),2*(j+1),2*(k+1)) = Vfield(V(2*(i+0.5),2*(j+1),2*(k+1)), x, y, z, nx, ny, nz, i+0.5, j+1, k+1, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*(i),2*(j+1-0.5),2*(k+1)) = Vfield(V(2*(i),2*(j+1-0.5),2*(k+1)), x, y, z, nx, ny, nz, i, j+1-0.5, k+1, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                             V(2*(i),2*(j+1),2*(k+1-0.5)) = Vfield(V(2*(i),2*(j+1),2*(k+1-0.5)), x, y, z, nx, ny, nz, i, j+1, k+1-0.5, gridsize, i, j, k, minX, minY, minZ, sigma_weight); 
%                       end            
%                     end
%                 end
%             end
%         end
%     end
%     
% end













