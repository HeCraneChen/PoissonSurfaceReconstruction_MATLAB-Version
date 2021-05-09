% solving th 2D Poisson equation for elephant example d2u/dx2 + d2u/dy2 = V
% Let's first try to formulate into two separate linear systems for x aixs and y axis
%% step1 rasterization of data, consider two axis sperately, rasterize into grid_x and grid_y, each is a 1 by 128 vector
% (More efficient way might be consider two dimensions together, input N x 4 array, output grid: 2 x Res x Res array)

% elephant = readmatrix('elephant.2D.txt');
% elephant = elephant(:, 1:4);
% X = elephant(:,1);
% Y = elephant(:,2);
% resx = 128; 
% resy = 128;
% gridsize_x = (max(X) - min(X))/resx;
% gridsize_y = (max(Y) - min(Y))/resy;
% 
% 
% elephant_x = sortrows(elephant,1);
% elephant_y = sortrows(elephant,2);
% grid = zeros(1, resx, resy);
% 
% for point_ind = 1:size(elephant,1)
%     point = elephant(point_ind, :);
%     x = point(1);
%     y = point(2);
%     nx = point(3);
%     ny = point(4);
%     for i = 0:resx-1
%         if x >= min(X) + gridsize_x * i & x < min(X) + gridsize_x * (i+1)
%             for j = 0:resy-1
%                 if y >= min(Y) + gridsize_y * j & y < min(Y) + gridsize_y * (j+1)
%                     i
%                     j
%                     grid(1, i+1, j+1) = grid(1, i+1, j+1) + nx;
%                     grid(2, i+1, j+1) = grid(2, i+1, j+1) + ny;
%                     
%                 end
%             end
%         end
%     end
%     
% end


% grid1 = grid(1,:,:);
% grid1 = squeeze(grid1);
% grid2 = grid(2,:,:);
% grid2 = squeeze(grid2);
% figure(1)
% spy(grid1)
% figure(2)
% spy(grid2)




% another way: formulate Vx and Vy, just like 1D case

elephant = readmatrix('elephant.2D.txt');
elephant = elephant(:, 1:4);
X = elephant(:,1);
Y = elephant(:,2);
resx = 128; 
resy = 128;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;


elephant_x = sortrows(elephant,1);
elephant_y = sortrows(elephant,2);
gridx = zeros(1, resx);
gridy = zeros(1, resy);

for point_ind = 1:size(elephant,1)
    point_ind
    point = elephant(point_ind, :);
    x = point(1);
    y = point(2);
    nx = point(3);
    ny = point(4);
    for i = 0:resx-1
        if x >= min(X) + gridsize_x * i & x < min(X) + gridsize_x * (i+1)           
            gridx(1, i+1) = gridx(1, i+1) + nx;    
            break
        end
    end
    
    for i = 0:resy-1
        if x >= min(Y) + gridsize_y * i & y < min(Y) + gridsize_y * (i+1)           
            gridy(1, i+1) = gridy(1, i+1) + ny;     
            break
        end
    end
    
end


%% step2 find matrix form of Poisson equation (calculate A_x, b_x, A_y, b_y), if B1 is chosen as basis, A_x, A_y is a tridiagonal matrix
x = linspace(0, resx, resx+1);
y = linspace(0, resy, resy+1);

% consider x axis only
A_x = zeros(resx - 1); 
A_x = A_x + diag(1./(x(3:end) - x(2:end-1))) + diag(1./(x(2:end-1) - x(1:end-2)));
A_x = A_x - diag(1./(x(3:end-1) - x(2:end-2)), 1);
A_x = A_x - diag(1./(x(3:end-1) - x(2:end-2)), -1);

b_x = zeros(resx - 1, 1);
gridx = gridx';
temp = gridx * 0.5; % 0.5 is half the area of a triangle in the hat function
b_x_with_boundary = [temp; 0] + [0; temp];
b_x = b_x_with_boundary(2:end-1);

% consider y axis only
A_y = zeros(resy - 1); 
A_y = A_y + diag(1./(y(3:end) - y(2:end-1))) + diag(1./(y(2:end-1) - y(1:end-2)));
A_y = A_y - diag(1./(y(3:end-1) - y(2:end-2)), 1);
A_y = A_y - diag(1./(y(3:end-1) - y(2:end-2)), -1);

b_y = zeros(resy - 1, 1);
gridy = gridy';
temp = gridy * 0.5; % 0.5 is half the area of a triangle in the hat function
b_y_with_boundary = [temp; 0] + [0; temp];
b_y = b_y_with_boundary(2:end-1);


%% step3 use direct method to solve Poisson equation
u_x = A_x \ b_x;
u_y = A_y \ b_y;

%% step4 visualize result













