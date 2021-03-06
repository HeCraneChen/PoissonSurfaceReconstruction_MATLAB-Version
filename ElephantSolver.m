% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

% solving th 2D Poisson equation for elephant example d2u/dx2 + d2u/dy2 = V

%% step1 data prep

elephant = readmatrix('./Data/elephant.2D.txt');
elephant = elephant(:, 1:4);
X = elephant(:,1);
Y = elephant(:,2);
resx = 128; 
resy = 128;
gridsize_x = (max(X) - min(X))/resx;
gridsize_y = (max(Y) - min(Y))/resy;
a_square = gridsize_x * gridsize_y; % area of one square


elephant_x = sortrows(elephant,1);
elephant_y = sortrows(elephant,2);
grid = zeros(2, resx, resy);


%% step2 find matrix form of Poisson equation (calculate A and b using Stencils)

n_intervals = 128;
n_elements = n_intervals * n_intervals;
n_basis = n_intervals+1;
n_points = n_basis * n_basis;

% store attr info into array (each square is an element, we store indices of its four vertices)
element_attr = zeros(4, n_elements);
for i=1:n_elements
    col = mod(i, n_intervals);
    if col == 0
        col = n_intervals;
    end
    row = (i - col)/n_intervals + 1;
    
    v1 = (row - 1) * n_basis + col; % upper left corner
    v2 = v1 + 1; % upper right corner
    v3 = v1 + n_basis;  % lower left corner
    v4 = v3 + 1;  % lower right corner
    element_attr(:,i) = [v1, v2, v3, v4];
end

% store vertex info into array (for each point(vertex), stores who are the basis)
vertex_attr = zeros(2, n_points);
for i = 1:n_points
    col = mod(i, n_basis);
    if col == 0
        col = n_basis;
    end
    row = (i - col)/n_basis + 1;
    vertex_attr(:,i) = [col, row];
end




% calculate A and b

% using stencils to calculate A
A = zeros(n_points);
A = A + diag(ones(1, n_basis^2)*2*(1./gridsize_x) + ones(1, n_basis^2)*2*(1./gridsize_y));
A = A + diag((-1) * (ones(1, n_basis^2-1)*(1./gridsize_y)), 1);
A = A + diag((-1) * (ones(1, n_basis^2-1)*(1./gridsize_y)), -1);
A = A + diag((-1) * (ones(1, n_basis^2-n_basis)*(1./gridsize_x)), n_basis);
A = A + diag((-1) * (ones(1, n_basis^2-n_basis)*(1./gridsize_x)), -n_basis);

% using the rasterized points to calculate b, then vectorize it into a
% column vector

b_grid = zeros(n_basis, n_basis);

for point_ind = 1:size(elephant,1)
    point = elephant(point_ind, :);
    x = point(1);
    y = point(2);
    nx = point(3);
    ny = point(4);
    for i = 1:resx
        if x >= min(X) + gridsize_x * (i-1) & x < min(X) + gridsize_x * i
            for j = 1:resy
                if y >= min(Y) + gridsize_y * (j-1) & y < min(Y) + gridsize_y * j
                    i
                    j
                    b_grid(i,j) = b_grid(i,j) + (nx + ny);
                    b_grid(i, j+1) = b_grid(i, j+1) + (nx - ny);
                    b_grid(i+1, j) = b_grid(i+1, j) + (-nx + ny);
                    b_grid(i+1, j+1) = b_grid(i+1, j+1) + (-nx - ny);                   
                end
            end
        end
    end
    
end

b = b_grid';
b = b(:);

figure(3)
spy(A)


%% step3 use direct method to solve Poisson equation
output = A \ b;

%% step4 visualize result
output = reshape(output, [n_basis, n_basis]);
heatmap(output);














