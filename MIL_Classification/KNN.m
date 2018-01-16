function [ output ] = KNN( trainInst, trainLabel, testInst, k_of_kNN )

num_of_class = length(unique( trainLabel ));
num_of_train = size( trainInst, 1 );
num_of_test = size( testInst, 1 );
value_1 = 1;
value_2 = 1;
value_3 = 1;
value_4 = 1;
value_5 = 1;
% value_1 = 1/sum(trainLabel==1);
% value_2 = 1/sum(trainLabel==2);
% value_3 = 1/sum(trainLabel==3);
% value_4 = 1/sum(trainLabel==4);
% value_5 = 1/sum(trainLabel==-1);
   
    distanceMatrix = zeros( num_of_train, num_of_test);


    for i = 1:num_of_test
      for j = 1:num_of_train
          distanceMatrix(j,i) = Dist( testInst(i,:), trainInst(j,:) );
      end
    end

    tempOutput = zeros( num_of_test, num_of_class);

    for i = 1:num_of_test
        [temp , index] = sort( distanceMatrix(:,i) );
        for j = 1:k_of_kNN
            if trainLabel( index(j) ) == 1
                tempOutput(i,1) = tempOutput(i,1) + value_1;
            elseif trainLabel( index(j) ) == 2
                tempOutput(i,2) = tempOutput(i,2) + value_2;
            elseif trainLabel( index(j) ) == 3
                tempOutput(i,3) = tempOutput(i,3) + value_3;
            elseif trainLabel( index(j) ) == 4
                tempOutput(i,4) = tempOutput(i,4) + value_4;
            elseif trainLabel( index(j) ) == -1
                tempOutput(i,5) = tempOutput(i,5) + value_5;
            end
        end
    end

output = zeros(1,num_of_test);  
for i = 1:num_of_test
    [a,b] = sort(tempOutput(i,:), 'descend');
    if b(1)==5
        output(i) = -1;
    else
        output(i) = b(1);
    end
end

     
    
     