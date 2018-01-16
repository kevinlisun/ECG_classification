function [ result ] = OVO_SVM( trainInstances, trainLabels, testInstances, testLabels )
    
    
    trainNum = size(trainInstances,1);
    testNum = size(testInstances,1);
    types = unique(trainLabels);
    typeNum = length(types);
    
    classifers = cell(0.5*typeNum*(typeNum-1),1);
    resultMatrix = zeros(testNum,0.5*typeNum*(typeNum-1));
    
    index = 1;
    for i = 1:typeNum
        for j = i+1:typeNum
            disp(['training the SVM ...',num2str(i),'-',num2str(j)]);%
            tempTrainLabels = [trainLabels(find(trainLabels==types(i)));trainLabels(find(trainLabels==types(j)))];
           
            tempTrainInst = [trainInstances(find(trainLabels==types(i)),:);trainInstances(find(trainLabels==types(j)),:)];
            
            tempTrainInst = [(1:size(tempTrainInst,1))',tempTrainInst];
            tempTestInstances = [(1:size(testInstances,1))',testInstances];
            if sum(trainLabels==types(i)) > sum(trainLabels==types(j))
                opt = [' -t 2 -s 0 -w',num2str(types(i)),' 3 -w',num2str(types(j)),' 5'];
            else
                opt = [' -t 2 -s 0 -w',num2str(types(i)),' 5 -w',num2str(types(j)),' 3'];
            end
            svmStruct = svmtrain( tempTrainLabels, tempTrainInst, opt);  
            %svmStruct = svmtrain( trainInst, tempTrainLabels, 'Kernel_Function',...
            %        'rbf', 'Method', 'QP', 'BoxConstraint', 1, 'showplot',false);
            classifer{index,1} = svmStruct;
            %tempResult = svmclassify( svmStruct, testInstances,'showplot',false);
            [tempResult,b] = svmpredict( testLabels, tempTestInstances, svmStruct);
            resultMatrix(:,index) = tempResult;
            index = index + 1;
        end
    end
    
    [result] = Vote( resultMatrix );
    
%     result = zeros( testNum, 1 );
%     for i = 1:testNum
%         if sum(resultMatrix(i,:)) == max(resultMatrix(i,:))
%             result = sum(resultMatrix(i,:));
%         end
%     end
        
        
        
        