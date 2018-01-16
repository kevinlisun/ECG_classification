function [sigma] = ComputeSigma( centers, mu )

     num_cluster = size(centers,1);
     sigma = zeros(num_cluster,1);
     for i = 1:num_cluster
         averageDist = 0; 
         for j = 1:num_cluster
             averageDist = averageDist + sqrt( sum((centers(i,:) - centers(j,:)).^2) );
         end
         averageDist = averageDist / (num_cluster-1);
         sigma( i, 1 ) = mu * averageDist;
     end
         