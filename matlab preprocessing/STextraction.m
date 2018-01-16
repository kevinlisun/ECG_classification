close all
clear all
clc


path = 'E:\CAD\PTB Database\health\*.mat';
%path = 'F:\PTB Database\PTB Database\health\*.mat';
filelist=dir(path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for index=1:length(filelist)
    filename = filelist(index).name;

    filename = strcat('E:\CAD\PTB Database\health\',filename);
    
    load (filename)
    if index==1
        tmpData=sameLenST;
        
    else
        tmpData=cat(1,tmpData,sameLenST);
    end    
   
end
sameLenST=[];
    sameLenST=tmpData;
      % 将sameLenST写入矩阵.mat
    %if ~exist('F:\PTB Database\PTB Database\healthST.mat','file')
     %   save('F:\PTB Database\PTB Database\healthST.mat','sameLenST');
   % else
    %    tmpData=load('F:\PTB Database\PTB Database\healthST.mat');
     %   sameLenST=cat(1,tmpData.sameLenST,sameLenST);
     save('F:\PTB Database\healthST.mat','sameLenST');
    %end 
tmpData=[];    

path = 'F:\PTB Database\PTB Database\ill\*.mat';
filelist=dir(path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for index=1:length(filelist)
    filename = filelist(index).name;

    filename = strcat('F:\PTB Database\PTB Database\ill\',filename);
    
    load (filename)
    
      % 将sameLenST写入矩阵.mat
   % if ~exist('F:\PTB Database\PTB Database\illST.mat','file')
    %    save('F:\PTB Database\PTB Database\illST.mat','sameLenST');
    %else
    
%    tmpData=load('F:\PTB Database\PTB Database\illST.mat');
 %       sameLenST=cat(1,tmpData.sameLenST,sameLenST);
  %      save('F:\PTB Database\PTB Database\illST.mat','sameLenST');
   % end 
        
if index==1
    tmpData=sameLenST;     
    else
        tmpData=cat(1,tmpData,sameLenST);
    end    
   
end
   

sameLenST=[];
    sameLenST=tmpData;
      % 将sameLenST写入矩阵.mat
    %if ~exist('F:\PTB Database\PTB Database\healthST.mat','file')
     %   save('F:\PTB Database\PTB Database\healthST.mat','sameLenST');
   % else
    %    tmpData=load('F:\PTB Database\PTB Database\healthST.mat');
     %   sameLenST=cat(1,tmpData.sameLenST,sameLenST);
     save('F:\PTB Database\PTB Database\illST.mat','sameLenST');
    

