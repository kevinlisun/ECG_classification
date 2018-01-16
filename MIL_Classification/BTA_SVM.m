function [ resultLabel ] = BTA_SVM( trainInstances, trainLabels, testInstances, testLabels )

    resultLabel = zeros(size(testInstances,1),1);
    
    tempLabels = trainLabels;
    tempLabels( [find(tempLabels==1);find(tempLabels==2);find(tempLabels==3)] ) = 1;
    tempLabels( [find(tempLabels==4);find(tempLabels==5);find(tempLabels==-1)] ) = -1;
    opt = [' -t 2 -s 0 -w1 2000000 -w-1 2000000'];
    classifer_1 = svmtrain(tempLabels,trainInstances,opt);
    
    tempLabels = trainLabels(trainLabels==1|trainLabels==2|trainLabels==3);
    tempInst = trainInstances(trainLabels==1|trainLabels==2|trainLabels==3,:);
    tempLabels(tempLabels==2|tempLabels==3) = -1;
    opt = [' -t 2 -s 0 -w1 100000 -w-1 100000'];
    classifer_21 = svmtrain(tempLabels,tempInst,opt);
    
    tempLabels = trainLabels(trainLabels==4|trainLabels==5|trainLabels==-1);
    tempInst = trainInstances(trainLabels==4|trainLabels==5|trainLabels==-1,:);
    tempLabels(tempLabels==4|tempLabels==5) = 1;
    opt = [' -t 2 -s 0 -w1 100000 -w-1 100000'];
    classifer_22 = svmtrain( tempLabels, tempInst, opt );
    
    tempLabels = trainLabels(trainLabels==2|trainLabels==3);
    tempInst = trainInstances(trainLabels==2|trainLabels==3,:);
    tempLabels(tempLabels==2) = 1;
    tempLabels(tempLabels==3) = -1;
    opt = [' -t 2 -s 0 -w1 100000 -w-1 100000'];
    classifer_32 = svmtrain( tempLabels, tempInst, opt );

    
    tempLabels = trainLabels(trainLabels==4|trainLabels==5);
    tempInst = trainInstances(trainLabels==4|trainLabels==5,:);
    tempLabels(tempLabels==4) = 1;
    tempLabels(tempLabels==5) = -1;
    opt = [' -t 2 -s 0 -w1 100000 -w-1 100000'];
    classifer_33 = svmtrain( tempLabels, tempInst, opt );
    
    list_1 = 1:size(testInstances,1);
    [label_1,b] = svmpredict(testLabels(list_1,:),testInstances(list_1,:),classifer_1);
    list_21 = list_1(label_1==1);
    [label_21,b] = svmpredict(testLabels(list_21,:),testInstances(list_21,:),classifer_21);
    list_22 = list_1(label_1==-1);
    [label_22,b] = svmpredict(testLabels(list_22,:),testInstances(list_22,:),classifer_22);
    list_31 = list_21(label_21==1);
    list_32 = list_21(label_21==-1);
    [label_32,b] = svmpredict(testLabels(list_32,:),testInstances(list_32,:),classifer_32);
    list_33 = list_22(label_22==1);
    list_34 = list_22(label_22==-1);
    [label_33,b] = svmpredict(testLabels(list_33,:),testInstances(list_33,:),classifer_33);
    list_41 = list_32(label_32==1);
    list_42 = list_32(label_32==-1);
    list_43 = list_33(label_33==1);
    list_44 = list_33(label_33==-1);
    
    resultLabel(list_31) = 1;
    resultLabel(list_41) = 2;
    resultLabel(list_42) = 3;
    resultLabel(list_43) = 4;
    resultLabel(list_44) = 5;
    resultLabel(list_34) = -1;
    
    disp(['... (',num2str(resultLabel(1,1)),',',num2str(testLabels(1,1)),') ...']);
    