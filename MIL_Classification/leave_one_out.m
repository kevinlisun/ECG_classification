function [resultCell] = leave_one_out( trainBags, trainLabels, Param)

    algorithm = Param.algorithm;
    clusterMethod = Param.clusterMethod;
    classifyMethod = Param.classifyMethod;
    kArr = Param.k;
    mu = Param.mu; 

    assert(strcmp(algorithm, 'MI_CCE')||strcmp(algorithm, 'ZHOU_CCE'));

    trainNum = length(trainLabels);
    
    types = unique(trainLabels);
%     right = 0;
%     rightP = zeros(1,length(types));
%     rightN = 0;
    
      
    totalInstances = cell2mat(trainBags);
    if strcmp(clusterMethod, 'Kmeans')
        [ centers ] = kmeansCluster( totalInstances, kArr );
        [ sigmas ] = ComputeSigma( centers, mu );
        Cluster.centers = centers;
        Cluster.sigmas = sigmas;
    end
    if strcmp(clusterMethod, 'Xmeans')
        [ centers, sigmas, clusters ] = XMeansCluster( totalInstances, kArr, mu );
    end
    if strcmp(clusterMethod, 'Hierarchical')
        [ centers, sigmas, clusters ] = HierarchicalCluster(totalInstances, clusterNum, mu );
    end
    

    output = zeros(trainNum,1);
    for i = 1:trainNum
        list = 1:trainNum;
        list(i) = [];
        testLabels = trainLabels(i);
        
    
        disp( ['MI_CCE classify experients ', num2str(i), '...'] );
    
        if strcmp( algorithm, 'MI_CCE')
            [ output(i) ] = MI_CCE( trainBags(list), trainLabels(list), trainBags(i), testLabels, Cluster, classifyMethod, kArr, mu );
        end
    
        if strcmp( algorithm, 'ZHOU_CCE')
            [ output(i) ] = ZHOU_CCE( trainBags(list),  testLabels,trainBags([13,33,50, 159,160,162, 205,210,190, 230,240,260, 275,280,287, 318,320,330]), trainBags([13,33,50, 159,160,162, 205,210,190, 230,240,260, 275,280,287, 318,320,330]), Cluster, classifyMethod, kArr, mu );
        end

    end


    resultCell = cell(1,3);
    resultCell{1,1} = trainLabels;
    resultCell{1,2} = output;
    resultCell{1,3} = sum(output==trainLabels);
    



