function [list] = RandomSelect( instWeight, Pr )


    randlist = rand(1,length(instWeight));
    randlist = randlist / sum(randlist);
    weight = instWeight - randlist;
    [a,b] = sort( weight, 'descend' );
    list = b(1:fix(Pr*length(instWeight)));
%     num_1 = sum(labels==1);
%     num_2 = sum(labels==2);
%     num_3 = sum(labels==3);
%     num_4 = sum(labels==4);
%     num_5 = sum(labels==-1);
%     
%     list_1 = find(labels==1);
%     list_2 = find(labels==2);
%     list_3 = find(labels==3);
%     list_4 = find(labels==4);
%     list_5 = find(labels==-1);
%     
%     temp = randperm(num_1);
%     rand_1 = list_1(temp(1:fix(p1*num_1)));
%     temp = randperm(num_2);
%     rand_2 = list_2(temp(1:fix(p2*num_2)));
%     temp = randperm(num_3);
%     rand_3 = list_3(temp(1:fix(p3*num_3)));
%     temp = randperm(num_4);
%     rand_4 = list_4(temp(1:fix(p4*num_4)));
%     temp = randperm(num_5);
%     rand_5 = list_5(temp(1:fix(p5*num_5)));
%     
%     list = [rand_1;rand_2;rand_3;rand_4;rand_5]';
    
    