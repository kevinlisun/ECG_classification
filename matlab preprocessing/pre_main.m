close all
clear all
clc


%path = 'E:\在元智大学\wrong case\health\st检测不准或R波漏检\*.mat';
path = 'D:\DATA\Myocardial infarction\good\*.mat';
filelist=dir(path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for index = 1:length(filelist)
    filename = filelist(index).name;
    filename = strcat('D:\DATA\Myocardial infarction\good\',filename);
%     filename = strcat('E:\CAD\PTB Database\ill\',filename);
    load (filename)
    disp([num2str(index), filename,'Begin']);
    %%%% remove the baseline%%%%%%%%
        multiLeadECG = val(1:12, :);
        [baseLine,noBaselineECG] = find_baseline_multilead(multiLeadECG,1000,'dct');%注意第2个输入参数是Fs,
                                                                             %而且这个函数可以同时求
                                                                             %多导程的基线

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% get the the three points R S T%%%%%%%%
        [indexQ indexR indexS indexT sumData ] = find_everage_RST(multiLeadECG, 1000);    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %%%% remove the HF noise %%%%%%%%
        pureECG = denoise_HF(noBaselineECG, 1000);%参数1000表示采样频率
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nbrbeat = size(indexT,2)-1;    %注意这个5表示取5个心跳，你自己可以设
        Q = indexQ(1:nbrbeat);
        R = indexR(2:nbrbeat+2);
        S = indexS(2:nbrbeat+1);
        T = indexT(2:nbrbeat+1);  
    %%%% get the the normST and the feature by function fitting%%%%%%%%
    [sameLenST normST fit3FtORGcell fit3FtSLcell fit3FtSLHcell] = extract_features...
        (pureECG, Q, R, S, T, 3, 'fit');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(filename,'val','pureECG','sameLenST', 'normST',...
    'indexQ', 'indexR', 'indexS', 'indexT',...
    'fit3FtORGcell', 'fit3FtSLcell', 'fit3FtSLHcell');
    disp([num2str(index), filename,'OK']);
    %%%%%%%%%%%%%get all the normST, and store as one file%%%%%%%%%%%%%%%%%%%
    if index == 1
        normSTmat = normST;
        sameLenSTmat = sameLenST;
    else
        normSTmat = cat(1, normSTmat, normST);
        sameLenSTmat = cat(1, sameLenSTmat, sameLenST);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [nbrBeats combinedFeature] = feature_combine(filename);
    fit3FtORG{index, 1} = combinedFeature{1};
    fit3FtSL{index, 1} = combinedFeature{2};
    fit3FtSLH{index, 1} = combinedFeature{3};

    if index == 1
        heartBeatEachPerson = nbrBeats;
    else
        heartBeatEachPerson = cat(1, heartBeatEachPerson, nbrBeats);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %
    scsz = get(0,'ScreenSize');
    figure('Position',[scsz(1) scsz(2) scsz(3) scsz(4)])
    %%%===========
    wdlen = 10000;
    indexQ = indexQ(indexQ<=wdlen);
    indexR = indexR(indexR<=wdlen);
    indexS = indexS(indexS<=wdlen);
    indexT = indexT(indexT<=wdlen);

    
    srcData = val(1, 1:wdlen);
    cleanData = pureECG(1, 1:wdlen);
    
    subplot(2, 1, 1);
    plot(srcData);
    hold on
    
    plot(srcData-cleanData, 'r');    
    plot(indexQ, srcData(indexQ), 'rs');
    plot(indexR, srcData(indexR), 'ro');
    plot(indexS, srcData(indexS), 'r*');
    plot(indexT, srcData(indexT), 'r+');

    subplot(2, 1, 2);
    plot(cleanData);  
    hold on
    plot(indexQ, cleanData(indexQ), 'rs');
    plot(indexR, cleanData(indexR), 'ro');
    plot(indexS, cleanData(indexS), 'r*');
    plot(indexT, cleanData(indexT), 'r+');
   % pause
    close
end

%%%%=========
% save('D:\NA_dim50.mat', 'normSTmat', 'sameLenSTmat')
% save('d:\fit_feature_na_dim50.mat','fit3FtORG' , 'fit3FtSL', 'fit3FtSLH','heartBeatEachPerson')
%注意：当处理的是'健康'样例时，激活一下三行
% save('D:\Healthy_control_dim50_[50].mat', 'normSTmat', 'sameLenSTmat')
% save('d:\fit_feature_health_dim50_[50].mat','fit3FtORG' , 'fit3FtSL', 'fit3FtSLH','heartBeatEachPerson')
%注意：当处理的是'有病'样例时，激活一下三行
save('d:\Myocardial_infarction_top3_dim50_[30].mat', 'normSTmat', 'sameLenSTmat')
save('d:\fit_feature_MI_top3_dim50_[30].mat','fit3FtORG' , 'fit3FtSL', 'fit3FtSLH','heartBeatEachPerson')
