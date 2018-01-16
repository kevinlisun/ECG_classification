function [result] = Vote( resultMatrix )
    
    instNum = size(resultMatrix,1);
    result = zeros(instNum,1);
    for i = 1:instNum 
        temp = zeros(1,20);
        for j = 1:20
            temp(1,j) = length(find(resultMatrix(i,:)==j));
        end
        [a,index] = max(temp);
        result(i,1) = index;
    end