function [ output ] = ClassiferForest( testInstances, classifer, weight )

    testNum = size(testInstances,1);
    output = zeros(testNum,1);

    for j = 1:size(classifer,1)
        output = output + weight(j)*eval(classifer{j},testInstances);
    end
    
    output = sign(output');
   