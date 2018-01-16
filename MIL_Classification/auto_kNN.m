function [ k_Arr, output] = auto_kNN( trainInst, trainLabel, testInst )

    trainLabel( trainLabel==0 ) = -1;
    num_of_train = size( trainInst, 1 );
    num_of_test = size( testInst, 1 );

    k_Arr = 100*ones( 2, 3 );

    distanceMatrix = zeros( num_of_train, num_of_test);


    for i = 1:num_of_test
      for j = 1:num_of_train
          distanceMatrix(j,i) = Dist( testInst(i,:), trainInst(j,:) );
      end
    end
    
    tempOutput = zeros( num_of_test, 17);
    k_of_kNN = 3;
    while k_of_kNN <= 17
        
        for i = 1:num_of_test
             [temp , index] = sort( distanceMatrix(:,i) );
             for j = 1:k_of_kNN
                 %tempVote(j) = trainLabel( index(j) );  
                 tempOutput(i,k_of_kNN) = tempOutput(i,k_of_kNN) + trainLabel( index(j) );
             end
%              if sum( tempVote >= 0 )
%                  tempOutput(i,k_of_kNN) = sum(tempVote==1)/k_of_kNN;
%              else
%                  tempOutput(i,k_of_kNN) = -sum(tempVote==-1)/k_of_kNN;
%              end
        end
    
        differenceFactor = length( find(abs( tempOutput(:,k_of_kNN) ) <= 1 + fix(k_of_kNN/5) ) );
        %differenceFactor = -sum(abs(tempOutput(:,k_of_kNN))) / num_of_test;
        if( differenceFactor < k_Arr( 1, 3 ) )
            k_Arr( 1, 3 ) = differenceFactor;
            k_Arr( 2, 3 ) = k_of_kNN;

            [ k_Arr(1,:), index ] = sort( k_Arr(1,:));
            k_Arr(2,:) = k_Arr(2,index);
        end
    
        if( sum(k_Arr(1,:))==0 & sum(k_Arr(2,:)~=0)==3 )
            break;
        end
        
        k_of_kNN = k_of_kNN + 2;
    end
    
    output = tempOutput(:,k_Arr(2,:));
    output = sign( output );
    output = sum( output, 2 );
    output = sign( output );
    output = output';
    
    
    
        

    
     