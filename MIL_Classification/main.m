clear
clc

% load 'E:\Paper\muti-Instance Learning\Data\Musk\Musk1_1'
% trainBags = [ Musk; unMusk ];
% trainLabels = [ ones(size(Musk)); -ones(size(unMusk)) ];
% load 'COREL.mat';
% Label(Label==0) = -1;
% list = [find(Label==1);find(Label==2);find(Label==3);find(Label==4);find(Label==5);find(Label==-1)]
% trainBags = [ Data(list) ];
% trainLabels = [ Label(list) ];
%--------------------------------------------------------------------------
load '.\data\PTB[MI+HC][50].mat';
%--------------------------------------------------------------------------
% % chose the Myocardial Infarction (MI) type
% typeList = [find(pLabels==5);];
% %typeList = [find(pLabels>0)];
% trainBags = [pBags(typeList);nBags];
% trainLabels = [pLabels(typeList);nLabels];
% trainLabels( trainLabels>0 ) = 1;
%--------------------------------------------------------------------------
% % % %两类分类
% % typeList = [find(pLabels==1);];
% % trainBags = [pBags(typeList);nBags];
% % trainLabels = [pLabels(typeList);nLabels];
% trainBags = [pBags(find(pLabels==4));pBags(find(pLabels==5))];
% trainLabels = [ones(sum(pLabels==4),1);-ones(sum(pLabels==5),1)];

%typeList = [find(pLabels==4);]
trainBags = [ pBags; nBags ];
trainLabels = [ pLabels; nLabels ];
trainLabels( trainLabels>0 ) = 1;
%--------------------------------------------------------------------------

exeTimes = 10;

total = cell(1,200);
k=30;
while k<=30
    k
mu = 0.9;
while mu <= 0.9
    mu
    result = cell( 1, 3 );
    result{1,1} = ['accuracy'];
    result{1,2} = ['recogniP'];
    result{1,3} = ['recogniN'];
    info = cell( 1, 3 );
    info{1,1} = 'info';
    info{1,2} = k;
    info{1,3} = mu;
    result = [ info; result];
for i = 1:exeTimes
    disp( ['<<--- Group test ',num2str(i),' of ',num2str(exeTimes),' --->>'] );
    Param.algorithm = 'MI_CCE';
    Param.clusterMethod = 'Kmeans';
    Param.classifyMethod = 'KNN';
    Param.k = [k];
    Param.mu = mu; 
    tempCell = ten_fold_CV(  trainBags, trainLabels, Param);
    result = [ result; tempCell ];
end
temp = result;
temp(1:2,:) = [];
temp = cell2mat(temp);
tempCell = cell(2,3);
tempCell{1,1} = 'average';
tempCell{2,1} = mean(temp(:,1));
tempCell{2,2} = mean(temp(:,2));
tempCell{2,3} = mean(temp(:,3));
tempCell{3,1} = std(temp(:,1));
tempCell{3,2} = std(temp(:,2));
tempCell{3,3} = std(temp(:,3));
result = [ result; tempCell ];
total{k+mu*10} = result;
mu = mu + 0.2;
end
k = k + 5;
end

label = [];
out = [];

for i = 3 : 3+exeTimes-1
    label = [ label, result{i,1} ];
    out = [ out, result{i,2} ];
end
disp('result:-------------------------');
resultMatrix = zeros(5,5);
resultMatrix(1,1) = sum(out(label==1)==1)/sum(label==1);
resultMatrix(1,2) = sum(out(label==1)==2)/sum(label==1);
resultMatrix(1,3) = sum(out(label==1)==3)/sum(label==1);
resultMatrix(1,4) = sum(out(label==1)==4)/sum(label==1);
resultMatrix(1,5) = sum(out(label==1)==-1)/sum(label==1);

resultMatrix(2,1) = sum(out(label==2)==1)/sum(label==2);
resultMatrix(2,2) = sum(out(label==2)==2)/sum(label==2);
resultMatrix(2,3) = sum(out(label==2)==3)/sum(label==2);
resultMatrix(2,4) = sum(out(label==2)==4)/sum(label==2);
resultMatrix(2,5) = sum(out(label==2)==-1)/sum(label==2);

resultMatrix(3,1) = sum(out(label==3)==1)/sum(label==3);
resultMatrix(3,2) = sum(out(label==3)==2)/sum(label==3);
resultMatrix(3,3) = sum(out(label==3)==3)/sum(label==3);
resultMatrix(3,4) = sum(out(label==3)==4)/sum(label==3);
resultMatrix(3,5) = sum(out(label==3)==-1)/sum(label==3);

resultMatrix(4,1) = sum(out(label==4)==1)/sum(label==4);
resultMatrix(4,2) = sum(out(label==4)==2)/sum(label==4);
resultMatrix(4,3) = sum(out(label==4)==3)/sum(label==4);
resultMatrix(4,4) = sum(out(label==4)==4)/sum(label==4);
resultMatrix(4,5) = sum(out(label==4)==-1)/sum(label==4);

resultMatrix(5,1) = sum(out(label==-1)==1)/sum(label==-1);
resultMatrix(5,2) = sum(out(label==-1)==2)/sum(label==-1);
resultMatrix(5,3) = sum(out(label==-1)==3)/sum(label==-1);
resultMatrix(5,4) = sum(out(label==-1)==4)/sum(label==-1);
resultMatrix(5,5) = sum(out(label==-1)==-1)/sum(label==-1);

overall = sum(out==label) / length(out)
