function [ output, accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Cluster, classifyMethod, clusterNum, mu )



    %assert(strcmp(clusterMethod, 'Kmeans')||strcmp(clusterMethod, 'Xmeans')||strcmp(clusterMethod, 'Hierarchical'));
    assert(strcmp(classifyMethod, 'NN')||strcmp(classifyMethod, 'SVM')||strcmp(classifyMethod, 'KNN')||strcmp(classifyMethod, 'BTA_SVM')||strcmp(classifyMethod, 'EUS_SVM')...
      ||strcmp(classifyMethod, 'Adaboost')||strcmp(classifyMethod, 'DT')||strcmp(classifyMethod, 'SVM-NN')||strcmp(classifyMethod, 'libSVM')||strcmp(classifyMethod, 'RF')...
      ||strcmp(classifyMethod, 'OVO_SVM')||strcmp(classifyMethod, 'Stacking')||strcmp(classifyMethod, 'AdaBoosting'));

    output = zeros( 1, size(testBags,1) );
    
    centers = Cluster.centers;
    sigmas = Cluster.sigmas;

    [weight] = ComputeWeight(trainBags);
    dimension = clusterNum;
    trainInstances = zeros( size(trainBags,1), dimension );
    for i = 1:size(trainBags,1)
        O = zeros( size(trainBags{i,1},1), dimension );
        for j = 1:size(trainBags{i,1},1)
            for k = 1:dimension
                O(j,k) = exp(-((Dist(trainBags{i,1}(j,:), centers(k,:)))^2)/(2*sigmas(k)^2));
            end
        end
        %加权归一化
        trainInstances(i,:) = weight{i}*O;
    end
    clear weight;
    
    %计算包内示例权值
    [weight] = ComputeWeight(testBags);
    testInstances = zeros( size(testBags,1), dimension );
    for i = 1:size(testBags,1)
        O = zeros( size(testBags{i,1},1), dimension );
        for j = 1:size(testBags{i,1},1)
            for k = 1:dimension
                O(j,k) = exp(-((Dist(testBags{i,1}(j,:), centers(k,:)))^2)/(2*sigmas(k)^2));
            end
        end
        %加权归一化
        testInstances(i,:) = weight{i}*O;
    end
    clear weight;
    
    if strcmp(classifyMethod, 'libSVM')

%         A = 1;
%         B = 2;
%         trainInstances = trainInstances(trainLabels==A|trainLabels==B,:);
%         trainLabels = trainLabels( trainLabels==A|trainLabels==B );
%         testInstances = testInstances( testLabels==A|testLabels==B,: );
%         testLabels = testLabels( testLabels==A|testLabels==B );
%         pInst = trainInstances( trainLabels == 1,: );
%         nInst = trainInstances( trainLabels == -1,: );
%         %nInst = SMOTE( nInst, fix(2*size(nInst,1)), 3 );
%         trainInstances = [pInst;nInst];
%         trainLabels = [ones(size(pInst,1),1);-ones(size(nInst,1),1)];
%        
%         pInst_1 = trainInstances( trainLabels == 1, : );
%         pInst_2 = trainInstances( trainLabels == 2, : );
%         pInst_3 = trainInstances( trainLabels == 3, : );
%         pInst_4 = trainInstances( trainLabels == 4, : );
%         nInst = trainInstances( trainLabels == -1,: );
%         pInst_1 = SMOTE( pInst_1, fix(size(nInst,1)), 3 );
%         pInst_2 = SMOTE( pInst_2, fix(size(nInst,1)), 3 );
%         pInst_3 = SMOTE( pInst_3, fix(size(nInst,1)), 3 );
%         pInst_4 = SMOTE( pInst_4, fix(size(nInst,1)), 3 );
%         trainInstances = [pInst_1;pInst_2;pInst_3;pInst_4;nInst];
%         trainLabels = [ones(size(nInst,1),1);2*ones(size(nInst,1),1);3*ones(size(nInst,1),1);4*ones(size(nInst,1),1);-ones(size(nInst,1),1)];
          
        %opt = [' -t 2 -s 0 -c 100000 -e 0.00001'];
        %opt = [' -t 2 -s 0 -w1 10000 -w2 12000 -w3 14000 -w4 16000 -w-1 8000'];
        opt = [' -s 0 -t 2 -g 0.002 -c 512 -w1 1000 -w2 1200 -w3 1400 -w4 1600 -w-1 1000'];
        model = svmtrain(trainLabels,trainInstances,opt);
        [resultLabel,b] = svmpredict(testLabels,testInstances,model);

        output = resultLabel';
        accur = b(1);
    end
    
    if strcmp(classifyMethod, 'NN')

        net = newff( trainInstances', trainLabels', [20,20] );
        net = train( net, trainInstances', trainLabels' );
        resultLabel = sim( net, testInstances' );
        resultLabel = round(resultLabel);
        resultLabel(resultLabel<=0) = -1;
        resultLabel(resultLabel>=4) = 4;
        output = resultLabel;
        accur = sum(testLabels==resultLabel')/size(testLabels,1)
    end
    
    if strcmp(classifyMethod, 'KNN')
        [ kArr, output ] = auto_kNN( trainInstances, trainLabels, testInstances );
        resultLabel = output;
        accur = sum(output'==testLabels)/length(testLabels);
    end
    
     if strcmp(classifyMethod, 'DT')
        disp('Training decision tree ...');
        tree = classregtree( trainInstances, trainLabels );
        resultLabel = eval(tree,testInstances);
        resultLabel = round(resultLabel);
        resultLabel(resultLabel<=0) = -1;
        resultLabel(resultLabel>=4) = 4;
        output = resultLabel';
        accur = sum(testLabels==resultLabel)/size(testLabels,1)
     end
    
     if strcmp(classifyMethod, 'RF')
         %         [ forest, bias ] = BuildForest( trainInstances, trainLabels, 500, 20 );
         %         [ resultLabel ] = ClassiferForest( testInstances, forest, bias );
      
         model = classRF_train( trainInstances, trainLabels, 1000 );
         [resultLabel, votes, prediction_per_tree] = classRF_predict( testInstances, model );
         output = resultLabel';
         accur = sum(testLabels==resultLabel)/size(testLabels,1)
     end
     
     if strcmp(classifyMethod, 'Adaboost')
         disp('Adaboosting...');
         resultLabel = AdaBoosting( trainInstances, trainLabels, testInstances, testLabels );
         accur = sum(testLabels'==resultLabel)/size(testLabels,1);
         disp(['The accuracy is ',num2str(accur),' ...']); 
         output = output + resultLabel;
     end
     
     if strcmp(classifyMethod, 'Stacking')
       
         disp('Training decision tree ...');
         tree = classregtree( trainInstances, trainLabels);


         disp('Training SVM...');
         opt = [' -t 2 -s 0 -c 1000 -e 0.001'];
         %opt = [' -t 2 -s 0 -w1 10000 -w2 12000 -w3 14000 -w4 16000 -w-1 8000'];
         svmStruct = svmtrain(trainLabels,trainInstances,opt);

         disp('Training Random Forest...');
         RFmodel = classRF_train(  trainInstances, trainLabels, 1000 );

         %对训练样本分类测试
         Inst_1 = zeros(1,size(trainInstances,1)+size(testInstances,1));
         Inst_1 = eval(tree,[trainInstances;testInstances]);
%          temp_1 = round(temp_1);
%          temp_1(temp_1==0) = 1;
%          temp_1(temp_1<0) = -1;
%          temp_1(temp_1>4) = 4;
         [Inst_2,b] = svmpredict([trainLabels;testLabels],[trainInstances;testInstances],svmStruct);
         [Inst_3, votes, prediction_per_tree] = classRF_predict([trainInstances;testInstances],RFmodel);
         
         newInst = [Inst_1,Inst_2,Inst_3];
         newTrainInst = newInst(1:size(trainInstances,1),:);
         newTestInst = newInst(size(trainInstances,1)+1:size(trainInstances,1)+size(testInstances,1),:);
         [ output ] = KNN( newTrainInst, trainLabels, newTestInst, 5 );
         resultLabel = output;
         accur = sum(output'==testLabels)/length(testLabels);
    end
    
        
                
    

   
    
    
    
    
    
    
