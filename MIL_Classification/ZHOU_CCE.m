function [ output ] = ZHOU_CCE( trainBags, trainLabels, testBags, testLabels, Cluster, classifyMethod, clusterNum, mu )



    %assert(strcmp(clusterMethod, 'Kmeans')||strcmp(clusterMethod, 'Xmeans')||strcmp(clusterMethod, 'Hierarchical'));
    assert(strcmp(classifyMethod, 'NN')||strcmp(classifyMethod, 'SVM')||strcmp(classifyMethod, 'KNN')||strcmp(classifyMethod, 'BTA_SVM')||strcmp(classifyMethod, 'EUS_SVM')...
      ||strcmp(classifyMethod, 'Adaboost')||strcmp(classifyMethod, 'DT')||strcmp(classifyMethod, 'SVM-NN')||strcmp(classifyMethod, 'libSVM')||strcmp(classifyMethod, 'RF')...
      ||strcmp(classifyMethod, 'OVO_SVM')||strcmp(classifyMethod, 'GMM'));

    output = zeros( 1, size(testBags,1) );
    
    centers = Cluster.centers;
    sigmas = Cluster.sigmas;

  
    dimension = clusterNum;
    trainInstances = zeros( size(trainBags,1), dimension );
    for i = 1:size(trainBags,1)
        O = zeros( size(trainBags{i,1},1), dimension );
        for j = 1:size(trainBags{i,1},1)
            tempO = zeros( 1, dimension );
            for k = 1:dimension
                tempO(1,k) = Dist(trainBags{i,1}(j,:), centers(k,:));
            end
            [a,b] = min( tempO );
             O(j,b) = 1;
        end
        trainInstances(i,:) = sum(O,1);
        trainInstances(trainInstances>1) = 1;
    end
    
    testInstances = zeros( size(testBags,1), dimension );
    for i = 1:size(testBags,1)
        O = zeros( size(testBags{i,1},1), dimension );
        for j = 1:size(testBags{i,1},1)
            tempO = zeros( 1, dimension );
            for k = 1:dimension
                tempO(1,k) = Dist(testBags{i,1}(j,:), centers(k,:));
            end
            [a,b] = min( tempO );
             O(j,b) = 1;
        end
        testInstances(i,:) = sum(O,1);
        testInstances(testInstances>1) = 1;
    end
    
    if strcmp(classifyMethod, 'libSVM')

        %opt = [' -t 2 -s 0 -w1 3 -w-1 5'];
        opt = [' -t 2 -s 0 -c 100000 -e 0.00001'];
        model = svmtrain(trainLabels,trainInstances,opt);
        [resultLabel,b] = svmpredict(testLabels,testInstances,model);
        output = resultLabel';
    end
                
    

   
    
    
    
    
    
    
