function [ Synth ] = Synthetize( organInst, list, k )

    synNum = length( list );

    orgNum = size( organInst, 1 );
    dim = size( organInst, 2 );
    distanceMatrix = zeros( synNum, orgNum );
    
    for i = 1 : synNum
        for j = 1 : orgNum
            distanceMatrix(i,j) = Dist( organInst(list(i),:), organInst(j, :) );
        end
        [a,b] = sort( distanceMatrix(i,:) );
        tempList = randperm(k);
        dif = organInst(b(tempList(1)+1),:) - organInst(list(i),:);
        gap = 0.5*rand( 1, dim );
        Synth(i,:) = organInst(list(i),:) + gap.*dif;
    end
        
        
        