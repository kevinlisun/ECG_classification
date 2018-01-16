function [ Weight ] = ComputeWeight( orgBags )

    bagNum = size(orgBags,1);
    Weight = cell(bagNum,1);
    
    for i = 1:bagNum
        instNum = size(orgBags{i},1);
        weight = zeros(instNum,instNum);
        for m = 1:instNum
            for n = m+1:instNum
                weight(m,n) = RBFDist(orgBags{i}(m,:),orgBags{i}(n,:),1);
            end
        end
        weight = weight + weight';
        threshold = mean(mean(weight));
        weight(weight<=threshold) = 1;
        weight(weight>threshold) = 0;
        tempW = sum(weight);
        tempW(tempW==0) = 0.5;
        tempW = 1./tempW;
        Weight{i} = tempW/sum(tempW);
        %Weight{i} = ComputeInstanceWeight(orgBags{i});
    end
        