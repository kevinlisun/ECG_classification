function [output] = EUS_SVM( trainInst, trainLabel, testInst, ensembleNum )

    pNum = sum( trainLabel==1 );
    nNum = sum( trainLabel==-1 );
    pInst = trainInst( trainLabel==1, : );
    nInst = trainInst( trainLabel==-1, : );
    classifer = cell( ensembleNum, 1 );
    output = zeros( size(testInst,1),ensembleNum );
    
    for i = 1:ensembleNum
        list = randperm( pNum );
        list = list( 1:nNum );
        label = [ones(nNum,1); -ones(nNum,1)];
        disp(['training SVM ', num2str(i), ' of ', num2str(ensembleNum), '...']);
        svmStruct = svmtrain( [pInst(list,:); nInst], label, 'Kernel_Function',...
                  'rbf', 'BoxConstraint', 1, 'Method', 'QP', 'showplot',false);
        classifer{i} = svmStruct;
    end   
    
    for i = 1:ensembleNum
        svmStruct = classifer{i};
        output(:,i) = svmclassify( svmStruct, testInst, 'showplot', false);
    end
    
    output = sum( output ,2 );
    output = sign( output );
%     output( output < fix(0.5*ensembleNum) ) = -1;
%     output( output >= fix(0.5*ensembleNum) ) = 1;
    
