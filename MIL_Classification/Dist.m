function [ distance ] = Dist( inst_1, inst_2 )
    
    num_1 = size( inst_1, 1);
    num_2 = size( inst_2, 1);
    if( num_1*num_2 == 1)
        distance = sqrt(sum((inst_1-inst_2).^2));
        %distance = AngleDistance(inst_1,inst_2);
    end
   