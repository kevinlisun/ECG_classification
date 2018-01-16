function [resultCell] = ten_fold_CV( trainBags, trainLabels, Param)

    algorithm = Param.algorithm;
    clusterMethod = Param.clusterMethod;
    classifyMethod = Param.classifyMethod;
    clusterNum = Param.k;
    mu = Param.mu; 

%------------------------------------------------------------------
    totalInstances = [cell2mat(trainBags)];
    if strcmp(clusterMethod, 'Kmeans')
        [ centers  ] = kmeansCluster( totalInstances, clusterNum );
        %[centers, sigmas, clusters] = KmeansCluster( totalInstances, clusterNum, mu );
    end
    if strcmp(clusterMethod, 'Xmeans')
        [centers, sigmas, clusters] = XmeansCluster( totalInstances, clusterNum, mu );
    end
    if strcmp(clusterMethod, 'Hierarchical')
        [ centers  ] = HierarchicalCluster(totalInstances, clusterNum );
    end
    
    [ sigmas ] = ComputeSigma( centers, mu );
        
    Clusters.centers = centers;
    Clusters.sigmas = sigmas;
%------------------------------------------------------------------    
    
    

    assert(strcmp(algorithm, 'MI_CCE')||strcmp(algorithm, 'ZHOU_CCE')||strcmp(algorithm, 'MI_KNN')||strcmp(algorithm, 'VOTE'));

    if length(unique(trainLabels))==2
        pNum = sum(trainLabels==1);
        nNum = sum(trainLabels==-1);

        featureIll = trainBags(trainLabels==1);
        featureHealth = trainBags(trainLabels==-1);

        listP = randperm( pNum );
        listN = randperm( nNum );

        pieceNumP = fix( pNum / 10 );
        pieceNumN = fix( nNum / 10 );

        validationNum = 10 * (pieceNumP + pieceNumN);
        validationNumP = 10 * pieceNumP;
        validationNumN = 10 * pieceNumN;

        PBags( :, 1 ) = featureIll( listP( 1:validationNumP) );
        NBags( :, 1 ) = featureHealth( listN( 1:validationNumN ) );
        tailBags{ :, 1 } = cat( 1, featureIll( listP( validationNumP+1 : pNum ) ), featureHealth( listN( validationNumN+1 : nNum) ) );
        tailLabels = cat( 1, ones( pNum-validationNumP, 1), -ones( nNum-validationNumN, 1) );
 

        for i = 1 : 10
            validationBags{ i, 1 } = cat( 1, PBags( (i-1)*pieceNumP+1 : i*pieceNumP, :), NBags( (i-1)*pieceNumN+1 : i*pieceNumN, : ) );
            validationLabels{ i, 1 } = cat( 1, ones( pieceNumP, 1), -ones( pieceNumN, 1) );
        end
    
    

        right = 0;
        rightP = zeros(1,10);
        rightN = zeros(1,10);
        predictPNum = 0;
        predictNNum = 0;

        for i = 1:10
            tempBags = validationBags;
            testBags = validationBags{ i, 1 };
            tempBags( i ) = [];
            trainBags = cat( 1, tempBags{:,1} );
            trainBags = cat( 1, trainBags, tailBags{:,1} );
    
            tempLabels = validationLabels;
            testLabels = validationLabels{ i, 1 };
            tempLabels( i ) = [];
            trainLabels = cat( 1, tempLabels{:,1} );
            trainLabels = cat( 1, trainLabels, tailLabels );
    
            disp( ['MI_CCE classify experients ', num2str(i), '...'] );
    
            if strcmp( algorithm, 'MI_CCE')
                [ output ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
          
            if strcmp( algorithm, 'ZHOU_CCE')
                [ output ] = ZHOU_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            
            if strcmp( algorithm, 'MI_KNN')
                [ output ] = MI_CCE( trainBags, trainLabels, testBags, 3);
            end
            output = output';
    
            right = right + sum( output == testLabels );
            rightP(i) = rightP(i) + sum( output( find( testLabels == 1 ) ) == 1 ); 
            rightN(i) = rightN(i) + sum( output( find( testLabels == -1 ) ) == -1); 

        end
        accru = right / validationNum;
        accruP =  sum(rightP) / validationNumP;
        accruN =  sum(rightN) / validationNumN; 

        resultCell = cell(1,3);
        resultCell{1,1} = accru;
        resultCell{1,2} = accruP;
        resultCell{1,3} = accruN;
    %四类分类--------------------------------------------------------------------------   
    elseif length(unique(trainLabels))==3
                num1 = sum(trainLabels==1);
        num2 = sum(trainLabels==2);
        num3 = sum(trainLabels==3);
        num_1 = sum(trainLabels==-1);

        feature1 = trainBags(trainLabels==1);
        feature2 = trainBags(trainLabels==2);
        feature3 = trainBags(trainLabels==3);
        feature_1 = trainBags(trainLabels==-1);
        
        list1 = randperm( num1 );
        list2 = randperm( num2 );
        list3 = randperm( num3 );
        list_1 = randperm( num_1 );
        
        pieceNum1 = fix( num1 / 10 );
        pieceNum2 = fix( num2 / 10 );
        pieceNum3 = fix( num3 / 10 );
        pieceNum_1 = fix( num_1 / 10 );
        
        validationNum = 10 * (pieceNum1 + pieceNum2 + pieceNum3 + pieceNum_1 );
        validationNum1 = 10 * pieceNum1;
        validationNum2 = 10 * pieceNum2;
        validationNum3 = 10 * pieceNum3;
        validationNum_1 = 10 * pieceNum_1;

        bags1 = feature1( list1( 1:validationNum1) );
        bags2 = feature2( list2( 1:validationNum2) );
        bags3 = feature3( list3( 1:validationNum3) );
        bags_1 = feature_1( list_1( 1:validationNum_1) );
        
        tailBags{ :, 1 } = cat( 1, feature1( list1( validationNum1+1 : num1 ) ),...
            feature2( list2( validationNum2+1 : num2 ) ),...
            feature3( list3( validationNum3+1 : num3 ) ),...
            feature_1( list_1( validationNum_1+1 : num_1 ) ) );
        tailLabels = cat( 1, ones( num1-validationNum1, 1),...
            2*ones( num2-validationNum2, 1),...
            3*ones( num3-validationNum3, 1),...
            -1*ones( num_1-validationNum_1, 1) );
 
        for i = 1 : 10
            validationBags{ i, 1 } = cat( 1, bags1( (i-1)*pieceNum1+1 : i*pieceNum1, :),...
                bags2( (i-1)*pieceNum2+1 : i*pieceNum2, : ),...
                bags3( (i-1)*pieceNum3+1 : i*pieceNum3, : ),...
                bags_1( (i-1)*pieceNum_1+1 : i*pieceNum_1, : ) );
            validationLabels{ i, 1 } = cat( 1, ones( pieceNum1, 1),...
                2*ones( pieceNum2, 1),...
                3*ones( pieceNum3, 1),...
                -1*ones( pieceNum_1, 1) );
        end
        
        T = [];
        O = [];
        A = [];
        
        for i = 1:10
            tempBags = validationBags;
            testBags = validationBags{ i, 1 };
            tempBags( i ) = [];
            trainBags = cat( 1, tempBags{:,1} );
            trainBags = cat( 1, trainBags, tailBags{:,1} );
    
            tempLabels = validationLabels;
            testLabels = validationLabels{ i, 1 };
            tempLabels( i ) = [];
            trainLabels = cat( 1, tempLabels{:,1} );
            trainLabels = cat( 1, trainLabels, tailLabels );
    
            disp( ['MI_CCE classify experients ', num2str(i), '...'] );
    
            if strcmp( algorithm, 'MI_CCE')
                [ output,accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            if strcmp( algorithm, 'ZHOU_CCE')
                [ output,accur ] = ZHOU_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            if strcmp( algorithm, 'MI_KNN')
                [ output ] = MI_KNN( trainBags, trainLabels, testBags, 3);
            end
            accur = sum(output==testLabels')/length(testLabels);
            T = [ T,testLabels' ];
            O = [ O,output ];
            A = [ A,accur ];
            
         end
         
         resultCell = cell(1,3);
         resultCell{1,1} = T;
         resultCell{1,2} = O;
         resultCell{1,3} = A;
%五类分类----------------------------------------------------------------------
    elseif length(unique(trainLabels))==5
                num1 = sum(trainLabels==1);
        num2 = sum(trainLabels==2);
        num3 = sum(trainLabels==3);
        num4 = sum(trainLabels==4);
        num_1 = sum(trainLabels==-1);

        feature1 = trainBags(trainLabels==1);
        feature2 = trainBags(trainLabels==2);
        feature3 = trainBags(trainLabels==3);
        feature4 = trainBags(trainLabels==4);
        feature_1 = trainBags(trainLabels==-1);
        
        list1 = randperm( num1 );
        list2 = randperm( num2 );
        list3 = randperm( num3 );
        list4 = randperm( num4 );
        list_1 = randperm( num_1 );
        
        pieceNum1 = fix( num1 / 10 );
        pieceNum2 = fix( num2 / 10 );
        pieceNum3 = fix( num3 / 10 );
        pieceNum4 = fix( num4 / 10 );
        pieceNum_1 = fix( num_1 / 10 );
        
        validationNum = 10 * (pieceNum1 + pieceNum2 + pieceNum3 + pieceNum4  + pieceNum_1 );
        validationNum1 = 10 * pieceNum1;
        validationNum2 = 10 * pieceNum2;
        validationNum3 = 10 * pieceNum3;
        validationNum4 = 10 * pieceNum4;
        validationNum_1 = 10 * pieceNum_1;

        bags1 = feature1( list1( 1:validationNum1) );
        bags2 = feature2( list2( 1:validationNum2) );
        bags3 = feature3( list3( 1:validationNum3) );
        bags4 = feature4( list4( 1:validationNum4) );
        bags_1 = feature_1( list_1( 1:validationNum_1) );
        
        tailBags{ :, 1 } = cat( 1, feature1( list1( validationNum1+1 : num1 ) ),...
            feature2( list2( validationNum2+1 : num2 ) ),...
            feature3( list3( validationNum3+1 : num3 ) ),...
            feature4( list4( validationNum4+1 : num4 ) ),...
            feature_1( list_1( validationNum_1+1 : num_1 ) ) );
        tailLabels = cat( 1, ones( num1-validationNum1, 1),...
            2*ones( num2-validationNum2, 1),...
            3*ones( num3-validationNum3, 1),...
            4*ones( num4-validationNum4, 1),...
            -1*ones( num_1-validationNum_1, 1) );
 
        for i = 1 : 10
            validationBags{ i, 1 } = cat( 1, bags1( (i-1)*pieceNum1+1 : i*pieceNum1, :),...
                bags2( (i-1)*pieceNum2+1 : i*pieceNum2, : ),...
                bags3( (i-1)*pieceNum3+1 : i*pieceNum3, : ),...
                bags4( (i-1)*pieceNum4+1 : i*pieceNum4, : ),...
                bags_1( (i-1)*pieceNum_1+1 : i*pieceNum_1, : ) );
            validationLabels{ i, 1 } = cat( 1, ones( pieceNum1, 1),...
                2*ones( pieceNum2, 1),...
                3*ones( pieceNum3, 1),...
                4*ones( pieceNum4, 1),...
                -1*ones( pieceNum_1, 1) );
        end
        
        T = [];
        O = [];
        A = [];
        
        for i = 1:10
            tempBags = validationBags;
            testBags = validationBags{ i, 1 };
            tempBags( i ) = [];
            trainBags = cat( 1, tempBags{:,1} );
            trainBags = cat( 1, trainBags, tailBags{:,1} );
    
            tempLabels = validationLabels;
            testLabels = validationLabels{ i, 1 };
            tempLabels( i ) = [];
            trainLabels = cat( 1, tempLabels{:,1} );
            trainLabels = cat( 1, trainLabels, tailLabels );
    
            disp( ['MI_CCE classify experients ', num2str(i), '...'] );
    
            if strcmp( algorithm, 'MI_CCE')
                [ output,accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            if strcmp( algorithm, 'ZHOU_CCE')
                [ output] = ZHOU_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
                accur = sum(output==testLabels')/length(testLabels);
            end
            if strcmp( algorithm, 'MI_KNN')
                [ output ] = MI_KNN( trainBags, trainLabels, testBags, 5);
                 accur = sum(output==testLabels')/length(testLabels);
            end
            if strcmp( algorithm, 'VOTE')
                classifyMethod = 'libSVM';
                [ output_1,accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
                classifyMethod = 'KNN';
                [ output_2,accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
                [ output_3 ] = MI_KNN( trainBags, trainLabels, testBags, 5);
                tempoutput = [output_1;output_2;output_3];
                for i = 1:size(tempoutput,2)
                    num = unique(tempoutput(:,i));
                    if length(num)==2
                        if sum(tempoutput(:,i)==num(1))==2
                            output(1,i) = num(1);
                        else
                            output(1,i) = num(2);
                        end
                    else
                        output(1,i) = output_1(i);
                    end
                end
            accur = sum(output'==testLabels)/length(testLabels)     
            end
           
        
            T = [ T,testLabels' ];
            O = [ O,output ];
            A = [ A,accur ];
            
         end
         
         resultCell = cell(1,3);
         resultCell{1,1} = T;
         resultCell{1,2} = O;
         resultCell{1,3} = A;
    else
%--------------------------------------------------------------------------
%多类情况
%--------------------------------------------------------------------------
        num1 = sum(trainLabels==1);
        num2 = sum(trainLabels==2);
        num3 = sum(trainLabels==3);
        num4 = sum(trainLabels==4);
        num5 = sum(trainLabels==5);
        num_1 = sum(trainLabels==-1);

        feature1 = trainBags(trainLabels==1);
        feature2 = trainBags(trainLabels==2);
        feature3 = trainBags(trainLabels==3);
        feature4 = trainBags(trainLabels==4);
        feature5 = trainBags(trainLabels==5);
        feature_1 = trainBags(trainLabels==-1);
        
        list1 = randperm( num1 );
        list2 = randperm( num2 );
        list3 = randperm( num3 );
        list4 = randperm( num4 );
        list5 = randperm( num5 );
        list_1 = randperm( num_1 );
        
        pieceNum1 = fix( num1 / 10 );
        pieceNum2 = fix( num2 / 10 );
        pieceNum3 = fix( num3 / 10 );
        pieceNum4 = fix( num4 / 10 );
        pieceNum5 = fix( num5 / 10 );
        pieceNum_1 = fix( num_1 / 10 );
        
        validationNum = 10 * (pieceNum1 + pieceNum2 + pieceNum3 + pieceNum4 + pieceNum5 + pieceNum_1 );
        validationNum1 = 10 * pieceNum1;
        validationNum2 = 10 * pieceNum2;
        validationNum3 = 10 * pieceNum3;
        validationNum4 = 10 * pieceNum4;
        validationNum5 = 10 * pieceNum5;
        validationNum_1 = 10 * pieceNum_1;

        bags1 = feature1( list1( 1:validationNum1) );
        bags2 = feature2( list2( 1:validationNum2) );
        bags3 = feature3( list3( 1:validationNum3) );
        bags4 = feature4( list4( 1:validationNum4) );
        bags5 = feature5( list5( 1:validationNum5) );
        bags_1 = feature_1( list_1( 1:validationNum_1) );
        
        tailBags{ :, 1 } = cat( 1, feature1( list1( validationNum1+1 : num1 ) ),...
            feature2( list2( validationNum2+1 : num2 ) ),...
            feature3( list3( validationNum3+1 : num3 ) ),...
            feature4( list4( validationNum4+1 : num4 ) ),...
            feature5( list5(validationNum5+1 : num5 ) ),...
            feature_1( list_1( validationNum_1+1 : num_1 ) ) );
        tailLabels = cat( 1, ones( num1-validationNum1, 1),...
            2*ones( num2-validationNum2, 1),...
            3*ones( num3-validationNum3, 1),...
            4*ones( num4-validationNum4, 1),...
            5*ones( num5-validationNum5, 1),...
            -1*ones( num_1-validationNum_1, 1) );
 
        for i = 1 : 10
            validationBags{ i, 1 } = cat( 1, bags1( (i-1)*pieceNum1+1 : i*pieceNum1, :),...
                bags2( (i-1)*pieceNum2+1 : i*pieceNum2, : ),...
                bags3( (i-1)*pieceNum3+1 : i*pieceNum3, : ),...
                bags4( (i-1)*pieceNum4+1 : i*pieceNum4, : ),...
                bags5( (i-1)*pieceNum5+1 : i*pieceNum5, : ),...
                bags_1( (i-1)*pieceNum_1+1 : i*pieceNum_1, : ) );
            validationLabels{ i, 1 } = cat( 1, ones( pieceNum1, 1),...
                2*ones( pieceNum2, 1),...
                3*ones( pieceNum3, 1),...
                4*ones( pieceNum4, 1),...
                5*ones( pieceNum5, 1),...
                -1*ones( pieceNum_1, 1) );
        end
        
        T = [];
        O = [];
        A = [];
        
        for i = 1:10
            tempBags = validationBags;
            testBags = validationBags{ i, 1 };
            tempBags( i ) = [];
            trainBags = cat( 1, tempBags{:,1} );
            trainBags = cat( 1, trainBags, tailBags{:,1} );
    
            tempLabels = validationLabels;
            testLabels = validationLabels{ i, 1 };
            tempLabels( i ) = [];
            trainLabels = cat( 1, tempLabels{:,1} );
            trainLabels = cat( 1, trainLabels, tailLabels );
    
            disp( ['MI_CCE classify experients ', num2str(i), '...'] );
    
            if strcmp( algorithm, 'MI_CCE')
                [ output,accur ] = MI_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            if strcmp( algorithm, 'ZHOU_CCE')
                [ output,accur ] = ZHOU_CCE( trainBags, trainLabels, testBags, testLabels, Clusters, classifyMethod, clusterNum, mu );
            end
            T = [ T,testLabels' ];
            O = [ O,output ];
            A = [ A,accur ];
            
         end
         
         resultCell = cell(1,3);
         resultCell{1,1} = T;
         resultCell{1,2} = O;
         resultCell{1,3} = A;
         
    end
         
         
        
        
        
        
        
    



