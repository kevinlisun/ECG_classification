function distance = maxHausdorff(Bag1,Bag2)


   
    size1=size(Bag1);
    size2=size(Bag2);
    line_num1=size1(1);
    line_num2=size2(1);
    dist=zeros(line_num1,line_num2);
    for i=1:line_num1
        for j=1:line_num2
            dist(i,j)=sqrt(sum((Bag1(i,:)-Bag2(j,:)).^2));
        end
    end

    dist1 = max(min(dist));
    dist2 = max(min(dist'));
    distance = max(dist1,dist2); 
    
    
    