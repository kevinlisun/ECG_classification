function predictLabels = AdaBoost( trainInstances, trainLabels, testInstances, testLabels )

    iterNum = 50;
    % 初始化inst权值
    InstWeight = ones(1,size(trainInstances,1))/size(trainInstances,1);
    e = zeros(iterNum,1);
    classifyWeights = zeros(1,iterNum);
    classifer = cell(iterNum,1);
    classiferLabel = zeros(iterNum,1);
   
    for iter = 1:iterNum
       % 随机从训练样本中选取一半训练分类器
       
       [tempList] = RandomSelect( trainLabels, 0.7, 0.7, 0.7, 0.7, 0.7 );
       index = length(tempList);
       
       disp('Training SVM...');
       opt = [' -t 2 -s 0 -w1 10000 -w2 12000 -w3 14000 -w4 16000 -w-1 8000'];
       svmStruct = svmtrain(trainLabels(tempList(1:index)),trainInstances(tempList(1:index),:),opt);

       %对训练样本分类测试
     
       [tempH,b] = svmpredict(trainLabels,trainInstances,svmStruct);
       tempH = tempH';
       
       %统计错分个数
       
       classifer{iter,1} = svmStruct;
       
     
       
       % 计算错误率
       e(iter) = sum(InstWeight.*IsNotEqual(tempH,trainLabels'))/size(trainInstances,1);
     
       %是否终止循环
       if( e(iter)>=0.5 )
           iter = iter - 1;
           InstWeight = ones(1,size(trainInstances,1))/size(trainInstances,1);
           continue;
       end
       
       %求分类器权值
       classifyWeight(iter) = 0.5*log((1-e(iter))/e(iter));
       %将更新的样本权值归一化
       for i = 1:size(trainInstances,1)
           tempInstWeight(i) = InstWeight(i)*exp(-classifyWeight(iter)*trainLabels(i)*tempH(i));
       end
       tempInstWeight = tempInstWeight/sum(tempInstWeight);
       %更新样本权值
       InstWeight = tempInstWeight;
   end
   
   h = cell( iter, 1 );
   result = zeros( 5, size(testInstances,1) );
   
   for i= 1:iterNum
       %分类并统计
       
           
           svmStruct = classifer{i,1};
           [temp,b] = svmpredict(testLabels,testInstances,svmStruct);
           
           tempMatrix = zeros(size(temp,1),5);
           temp(temp==-1) = 5;
           for j = 1:size(temp,1)
               tempMatrix(j,temp(j)) = 1;
           end
           h{i} = tempMatrix';
       
       end

   
       temp_result = classifyWeight(i).*h{i};
       result = result + temp_result;
  
   predictLabels = zeros(1,size(testInstances,1));
   for i = 1:size(testInstances,1)
       [a,b] = sort( result(:,i), 'descend' );
       predictLabels(i) = b(1);
   end
   predictLabels(predictLabels==5) = -1;
       

       
       
       
       
    
    
    