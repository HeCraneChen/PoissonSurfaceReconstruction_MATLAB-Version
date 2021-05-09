% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

u_exact = imread('./Data/DSCF4864.JPG');
u_exact = rgb2gray(u_exact);
u_exact = double(u_exact);

imsize = size(u_exact);
w = imsize(2);
h = imsize(1);
dx = 1 / w;
dy = 1 / h;

u_expanded = zeros(h+2, w+2);
b = zeros(h+2, w+2);
u_expanded(2:end-1, 2:end-1) = u_exact;
for i = 2:h+1
    for j = 2:w+1
        % actual version when dx != dy
         b(i, j) = (u_expanded(i+1, j) + ...
                   u_expanded(i-1, j) - ...
                   2 * u_expanded(i, j)) /dx^2 ...
                   + ...
                   (u_expanded(i, j+1) + ...
                   u_expanded(i, j-1) - ...
                   2 * u_expanded(i, j)) / dy^2;
        % simplified version when dx = dy
%         b(i, j) = (u_expanded(i+1, j) + ...
%                    u_expanded(i-1, j) + ...
%                    u_expanded(i, j-1) + ...
%                    u_expanded(i, j+1) - 4 * u_expanded(i, j)) ...
%                    /dx^2;
    end
end

figure(1)
imshow(b)
writematrix(b,'./Data/b.txt');


u = zeros(h+2, w+2);
for k = 1: 1000
    % actual version when dx != dy
    u_k_p_1 = - (dx^2 * dy^2) / (2 * (dx^2 + dy^2) ) * b;
    % simplified version when dx = dy
%     u_k_p_1 = -dx^2 / 4 * b;
    for i = 2:h+1
        for j = 2:w+1
            % actual version when dx != dy
             u_k_p_1(i, j) = u_k_p_1(i, j) + ...
                       (dy^2 * (u(i+1, j) + u(i-1, j)) + ...
                        dx^2 * (u(i, j-1) + u(i, j+1)))/ ...
                        (2 * (dx^2 + dy^2));
            
             % simplified version when dx = dy
%             u_k_p_1(i, j) = u_k_p_1(i, j) + ...
%                        (u(i+1, j) + ...
%                         u(i-1, j) + ...
%                         u(i, j-1) + ...
%                         u(i, j+1))/4;
        end
    end
    u = u_k_p_1;
end

u = u / 255;
figure(2)
imshow(u)



    