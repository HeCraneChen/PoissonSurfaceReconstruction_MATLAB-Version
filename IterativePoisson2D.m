% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

b = readmatrix('./Data/b.txt');
figure(1)
imshow(b)

u0 = zeros(size(b));
u = jacobi(u0, b);
u = u0;

%%  Jacobi or Gauss Seidel
for i = 1:100
%     u = jacobi(u, b);
    u = gauss(u, b);
end
figure(2)
imshow(u/255)

%%  Multigrid








% five iterations of multigrid
% for i = 1:10
%     u = multigrid(u,b);
% end
% figure(3)
% imshow(u/255)
