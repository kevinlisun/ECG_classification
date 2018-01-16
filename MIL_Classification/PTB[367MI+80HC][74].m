clear
clc

load 'C:\Users\Kevin\Desktop\LTMIL\PTB database\dataCell_1.mat';
MI_index = [];
Health_index = [];
for i = 1:548
    if strcmp(dataCell{i,2},'Myocardial infarction')
        MI_index = [MI_index;i];
    end
    if strcmp(dataCell{i,2},'Healthy control')
        Health_index = [Health_index;i];
    end
end

MI_Bags = dataCell(MI_index,:);
MI_Bags(:,2) = [];
MI_type = MI_Bags(:,2);
types = unique(MI_type);
types = [types, cell(14,1)];
counts = zeros(14,1);


for i = 1:length(MI_type)
    for j = 1:length(types)
        if strcmp(MI_type{i,1},types{j,1})
            types{j,2} = [types{j,2},i];
            counts(j) = counts(j) + 1;
        end
    end
end
   
[a,b] = sort(counts,'descend');
pLabels = zeros(length(MI_type),1);
for i = 1:14
    pLabels(types{b(i),2}) = i;
end

typeLabels = types(b,1)

        



Health_Bags = dataCell(Health_index,:);
Health_Bags(:,2) = [];
nBags = Health_Bags(:,3);
nLabel = -ones(80,1);


typeLabels = [cell(14,1),typeLabels];

for i = 1:14
    typeLabels{i} = i;
end

head = cell(1,2);
head{1,2} = 'Healthy control';
head{1,1} = -1;
typeLabels = [head;typeLabels];
pBags = MI_Bags(:,3);
clear types;
types = typeLabels;

clear Health_Bags Health_index MI_Bags MI_index MI_type a b counts dataCell head ...
       i j typeLabels;









