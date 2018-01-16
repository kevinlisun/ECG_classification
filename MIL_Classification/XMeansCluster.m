function [ centers, clusterInf, clusters ] = XMeansCluster( Instances, Kmax, mu )
    save 'instances.mat' Instances;
    complete = 0;
    %centers = cat( 1, max(Instances), min(Instances) );
    index = 1;
    [ centers, clusters ] = SVDclusteringfor2( Instances );
    while( complete==0 )
        [ centers, clusters ] = ImproveParams( Instances, centers );
        oldK = size( clusters, 1 );
        [ centers, clusters ] = ImproveStructure( Instances, Kmax, centers, clusters );
        newK = size( clusters, 1 );
        if oldK == newK || newK > Kmax
            complete = 1;
        end
        index = index + 1;
    end
    
    num_cluster = size(clusters,1);
    
    for i = 1:num_cluster
        averageDist = 0;
        for j = 1:num_cluster
            averageDist = averageDist + Dist( centers(i,:), centers(j,:) );
        end
        averageDist = averageDist / (num_cluster-1);
        clusterInf( i, 1 ) = mu * averageDist;
    end