function [v] = Vfield(v, x, y, z, nx, I, J, K, gridsize, minX, minY, minZ, sample_radius)
 
    Sigma = (gridsize)^2  * eye(3); 
    mu = [x; y; z]; % coordinates of the point locating inside the cube
    X = [minX + gridsize * I; minY + gridsize * J; minZ + gridsize * K]; % coordinates of the edge
    W = (expm(-0.5 * (X - mu)'* inv(Sigma)*(X - mu))) / sqrt((2 * pi)^3 * det(Sigma));
%     W = 1;
    v = v + W / (sample_radius)^3 * nx;

      
end












%     Sigma = (gridsize)^2 * sigma_weight * eye(3); %  % the smaller sigma_weight is, the denser, the thiner Gaussian, the smaller area it affects. vice versa.
%     if x >= minX + gridsize * (i-1) & x < minX + gridsize * i
%         if y >= minY + gridsize * (j-1) & y < minY + gridsize * j
%             if z >= minZ + gridsize * (k-1) & z < minZ + gridsize * k
%                 W = 1;
%             end
%        end
%     end
%     W = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % debug the distribution, using the special case that we worked on
       
    
     % visualize 3D gaussian see if it's like a ball, 
     % colormap: yellow means larger, and blue means smaller
%      [X1,Y1,Z1] = sphere(16);
%      x1 = [0.5*X1(:); 0.75*X1(:); X1(:)];
%      y1 = [0.5*Y1(:); 0.75*Y1(:); Y1(:)];
%      z1 = [0.5*Z1(:); 0.75*Z1(:); Z1(:)];
%      x1 = x1 + ones(size(x1))*I;
%      y1 = y1 + ones(size(y1))*J;
%      z1 = z1 + ones(size(z1))*K;
%      S = repmat([50,25,10],numel(X1),1);
%      s = S(:);
%      c = zeros(size(s));
%      for i = 1:size(c,1)
% %          c(i,1) = (x1(i,1) - I)^2 + (y1(i,1) - J)^2 + (z1(i,1) - K)^2;
%         mu = [I; J; K];
%         X = [x1(i,1); y1(i,1); z1(i,1)];
%         x = x1(i,1);
%         y = y1(i,1);
%         z = z1(i,1);
%         d = sqrt((I - x)^2 + (J - y)^2 + (K - z)^2);
%         if d <= gridsize
%             W = 1;
%         else
%             W = 0;
%         end
%         
% %         W = (expm(-0.5 * (X - mu)'* inv(Sigma)*(X - mu))) / sqrt((2 * pi)^3 * det(Sigma))
%         c(i,1) = W;
%      end
%      figure(3)
%      scatter3(x1,y1,z1,s,c)
%      view(40,35)
    
%      % debug Gaussian, the following two versions are equivalent
%     x = -3;
%     y = -2;
%     % version 1
%     Sigma = [0.25 0.3; 0.3 1];
%     mu = [0; 0];
%     X = [x; y];
%     W = (expm(-0.5 * (X - mu)'* inv(Sigma)*(X - mu))) / sqrt((2 * pi)^2 * det(Sigma))
%     % version 2
%     mu = [0 0];
%     X = [x, y];
%     pdf = mvnpdf(X,mu,Sigma)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%