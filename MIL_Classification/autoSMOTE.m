function [ newInst, newLabel ] = autoSMOTE( trainInst, trainLabel )

    type = unique( trainLabel );
    typeNum = length( type );
    newInst = [];
    newLabel = [];

    for i = 1:typeNum
        labelNum(i) = sum( trainLabel== type(i) );
    end
    
    synNum = max( labelNum );
    
    for i = 1:typeNum
        [ temp ] = SMOTE( trainInst( trainLabel==type(i), : ), synNum, 3 );
        newInst = [ newInst; temp ];
        newLabel = [ newLabel; type(i)*ones(synNum,1) ];
    end
    
    

    