function [ newInst, newLabel ] = autoUnderSample( trainInst, trainLabel )

    type = unique( trainLabel );
    typeNum = length( type );
    newInst = [];
    newLabel = [];

    for i = 1:typeNum
        labelNum(i) = sum( trainLabel== type(i) );
    end
    
    underSampleNum = min( labelNum );

    for i = 1:typeNum
        cutNum = sum(trainLabel==type(i)) - underSampleNum;
        if cutNum == 0
            continue;
        else
            randList = randperm( sum( trainLabel==type(i) ) );
            instList = find( trainLabel==type(i) );
            cut = instList(randList(1:cutNum)); 
            trainInst(cut,:) = [];
            trainLabel(cut,:) = [];
        end
    end
    
    newInst = trainInst;
    newLabel = trainLabel;
    