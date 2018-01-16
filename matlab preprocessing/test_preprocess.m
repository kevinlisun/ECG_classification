close all
clear all
clc


%path = 'H:\研究生\杨开涛\PTB Database\PTB Database\ill\*.mat';
path = 'E:\CAD\PTB Database\health\*.mat';
filelist=dir(path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for index=1:length(filelist)
    filename = filelist(index).name;
    %filename = strcat('H:\研究生\杨开涛\PTB Database\PTB Database\ill\',filename);
    filename = strcat('E:\CAD\PTB Database\health\',filename);
    load (filename)
    disp([num2str(index), filename,'  Begin']);
   
    dim=38400;
    %%%% remove the HF noise %%%%%%%%
        noHFnoiseECG = zeros(12,dim);
        tmp = zeros(1,dim);
        cutoff = round(length(tmp)*45/500); % roughly regard frequency above 45Hz is hight-frequency noise
        tmp(1:cutoff) = 1;
        for i =1:12
            srcData = val(i, :);
            dctData = dct(srcData);%离散余弦变换
            dctData = dctData.*tmp;
            noHFnoiseECG(i,:) = idct(dctData);
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    %%%% remove the baseline%%%%%%%%
        baseLine = zeros(12,dim);
        pureECG = zeros(12,dim);
        for i =1:12
            srcData = noHFnoiseECG(i,:);
            BL = find_baseline(srcData, 'dct');
            baseLine(i,:) = BL;
            pureECG(i,:) = srcData - BL;
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% get the the three points R S T%%%%%%%%
[indexQ indexR indexS indexT] = find_everage_RST(val(1:12,:), 1000);    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    scsz = get(0,'ScreenSize');
    figure('Position',[scsz(1) scsz(2) scsz(3) scsz(4)])
    %%%===========
    dim2=2000;
    srcData = val(1,:);
    cleanData = pureECG(1,:);
        
    subplot(2, 1, 1);
    plot(srcData);
    hold on
    plot(srcData-cleanData, 'r');
    tempQ=find(indexQ<dim2);
    tempR=find(indexR<dim2);
    tempS=find(indexS<dim2);
    tempT=find(indexT<dim2);
    plot(indexQ(tempQ), srcData(indexQ(tempQ)), 'rs');
    plot(indexR(tempR), srcData(indexR(tempR)), 'ro');
    plot(indexS(tempS), srcData(indexS(tempS)), 'r*');
    plot(indexT(tempT), srcData(indexT(tempT)), 'r+');
    hold on;
    axis([0 2000 -1000 1000]);

    subplot(2, 1, 2);
    plot(cleanData);  
    hold on
      plot(indexQ(tempQ), cleanData(indexQ(tempQ)), 'rs');
    plot(indexR(tempR), cleanData(indexR(tempR)), 'ro');
    plot(indexS(tempS), cleanData(indexS(tempS)), 'r*');
    plot(indexT(tempT), cleanData(indexT(tempT)), 'r+');
    hold on;
    axis([0 2000 -1000 1000]);
    pause
    close
end

