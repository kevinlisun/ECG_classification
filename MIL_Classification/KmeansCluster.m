function [ centers ] = KmeansCluster( Instances, num_cluster )
    
     rand('state',sum(100*clock));
   
     num_instance = size( Instances, 1 );
     dimensionality = size( Instances, 2 );
    

    initials = zeros( num_cluster, 1 );
    randList = randperm( num_instance );
    initials = randList( 1:num_cluster );
    
    for i=1:num_cluster
        centers(i,:) = Instances(initials(1,i),:);
    end
    
    num_iter=0; 
    complete=0;
    clusters=cell(num_cluster,1);
    while( complete == 0 )
        distance = zeros( num_instance, num_cluster );
        
        for i = 1:num_instance
            for j = 1:num_cluster
                distance(i,j) = sum((Instances(i,:) - centers(j,:)).^2);
                %distance(i,j) = ChiDistance( Instances(i,:), Instances, centers(j,:), clusters{j,1} );
            end
        end
        
        clusters=cell(num_cluster,1);
        for i=1:num_instance
            [minimum,index]=min(distance(i,:));
            clusters{index,1}=[clusters{index,1},i];
        end
        
        for i=1:num_cluster
            tempNum = length(clusters{i,1});
            if( tempNum == 0 )
                new_centers(i,:) = centers(i,:);
            else
                temp_center = sum(Instances(clusters{i,1},:),1);
                new_centers(i,:)=temp_center/tempNum;
            end
        end
        
        for i=1:num_cluster
            identical=0;
            for j=1:num_cluster
                if(sum(new_centers(i,:)==centers(j,:))==dimensionality)
                    identical=1;
                    break;
                end
            end        
            if(identical==0)              
                break;
            end
        end
        centers=new_centers;
        if(identical==1)
            complete=1;
        end
        
        num_iter=num_iter+1;
    end
    
%     for i = 1:num_cluster
%         averageDist = sum( distance(clusters{i,1}, i) )/ size(clusters{i,1},1);
%         clusterInf(i,1) = mu*averageDist;
%     end
      
%      for i=1:(num_cluster-1)
%          for j=(i+1):num_cluster
%              averageDist = averageDist + Dist( centers(i,:), centers(j,:) );
%          end
%      end
%      averageDist = (averageDist * 2) / (num_cluster * (num_cluster-1));
%      clusterInf( 1:num_cluster, 1 ) = mu * averageDist;
     
%      for i = 1:num_cluster
%          averageDist = 0; 
%          for j = 1:num_cluster
%              averageDist = averageDist + sqrt( sum((centers(i,:) - centers(j,:)).^2) );
%          end
%          averageDist = averageDist / (num_cluster-1);
%          clusterInf( i, 1 ) = mu * averageDist;
%      end
%          
             
    
    
    
    
            