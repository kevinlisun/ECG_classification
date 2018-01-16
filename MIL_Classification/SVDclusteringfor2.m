function [ new_centers, new_clusters ] = SVDclusteringfor2( Instances )


    transMatrix = feval('deletecolumn',Instances); 
    [rowt colt]=size(transMatrix);

    %数据标准化，均值       nnnnnnnnnnnnnn，方差为
    indicator = feval('averageindicator',transMatrix);

    %SVD分解
    [U,S,V] = svd(indicator);% SVM分解
    left = find(U(:,1)>=0); % U的第一列向量,大于0为一类，否则为另外一类
    right = find(U(:,1)<0); % 列向量

    new_clusters = cell(2,1);
    new_clusters{1,1} = left';
    new_clusters{2,1} = right';

    if size(new_clusters{1,1},2)==0
        new_clusters(1) = [];
    end
    if size(new_clusters{2,1},2)==0
        new_clusters(2) = [];
    end

    new_centers = zeros( 2, colt );
    for i = 1:2
        tempNum = length(new_clusters{i,1});
        temp_center = sum(Instances(new_clusters{i,1},:),1);
        new_centers(i,:) = temp_center/tempNum;
    end







    

