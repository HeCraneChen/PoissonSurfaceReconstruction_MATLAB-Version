% Visualizing finite element 2D basis functions
p = readmatrix('p.txt'); % x, y coordinates of points
t = readmatrix('t.txt'); % first three rows: index of three vertices of each triangle, last row: index of the domain
e = readmatrix('e.txt'); % outside boundary edges, only used to identify which points lie on the boundary
i_boundary = unique([e(1,:), e(2,:)]);
figure(1)
trimesh(t(1:3,:)', p(1,:), p(2,:));
u = zeros(327, 1);
u(77) = 1;
u(197) = 1;
figure(2)
trimesh(t(1:3,:)', p(1,:), p(2,:), u);
figure(3)
trisurf(t(1:3,:)', p(1,:), p(2,:), u); % in u, there are two piece-wise linear and continuous functions

% Solves the 2D Poisson equation, with constance right-hand side
n_elements = size(t, 2);
n_points = size(p, 2);
a = zeros(n_elements, 1);
A = zeros(n_points);
b = zeros(n_points, 1);
for i = 1:n_elements
    i1 = t(1, i);
    i2 = t(2, i);
    i3 = t(3, i);
    % vertices
    v1 = p(:, i1);
    v2 = p(:, i2);
    v3 = p(:, i3);
    a(i) = dot(v1 - v2, [0 1; -1 0] * (v1 - v3))/2.; % area of one triangle
    % gradients
    g1 = [(v1 - v2)'; (v1 - v3)'] \ [1; 1];
    g2 = [(v2 - v3)'; (v2 - v1)'] \ [1; 1];
    g3 = [(v3 - v1)'; (v3 - v2)'] \ [1; 1];
    
    A(i1, i1) = A(i1, i1) + a(i) * dot(g1, g1);
    A(i2, i2) = A(i2, i2) + a(i) * dot(g2, g2);
    A(i3, i3) = A(i3, i3) + a(i) * dot(g3, g3);
    A(i1, i2) = A(i1, i2) + a(i) * dot(g1, g2);
    A(i1, i3) = A(i1, i3) + a(i) * dot(g1, g3);
    A(i2, i3) = A(i2, i3) + a(i) * dot(g2, g3);
    A(i2, i1) = A(i2, i1) + a(i) * dot(g1, g2);
    A(i3, i1) = A(i3, i1) + a(i) * dot(g1, g3);
    A(i3, i2) = A(i3, i2) + a(i) * dot(g2, g3);
    b(i1) = b(i1) + a(i) / 3;
    b(i2) = b(i2) + a(i) / 3;
    b(i3) = b(i3) + a(i) / 3;
end

figure(4)
spy(A)


% setting boundary conditions
interior = ones(n_points, 1);
interior(i_boundary) = 0;
interior = logical(interior);
A = A(interior, interior);
b = b(interior);
figure(5)
spy(A)

u = zeros(n_points, 1);
u(interior) = A \ b;
figure(6)
trisurf(t(1:3,:)', p(1,:), p(2,:), u);






