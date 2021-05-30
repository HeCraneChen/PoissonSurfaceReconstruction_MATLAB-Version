function [densities] = KNN(points,K)
    % points is Nx3 or Nx2, K is an integer < N usually 20
    % output: 1xN, densities, the larger the value, the sparser
    "I'm inside knn" 
    
    n_points = size(points,1);
    distances = zeros(n_points, n_points);
    for i= 1:n_points
        for j = i+1:n_points
            distances(i,j) = norm(points(i,:) - points(j,:));
            distances(j,i) = distances(i,j);
        end
    end
    densities = zeros(1, n_points); 
    for i = 1:n_points
        all_d = sort(distances(i,:));
        top = all_d(1:(K+1));
        densities(1,i) = sum(top);
    end
    
    "I'm done with knn"
    
end