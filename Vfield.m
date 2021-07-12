function [v] = Vfield(v, x, y, z, nx, I, J, K, gridsize, minX, minY, minZ, sample_radius)
 
    Sigma = (gridsize)^2  * eye(3); 
    mu = [x; y; z]; % coordinates of the point locating inside the cube
    X = [minX + gridsize * I; minY + gridsize * J; minZ + gridsize * K]; % coordinates of the edge
    W = (expm(-0.5 * (X - mu)'* inv(Sigma)*(X - mu))) / sqrt((2 * pi)^3 * det(Sigma));
%     W = 1;
    v = v + W / sample_radius * nx; 

      
end











