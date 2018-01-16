function [baseline, cleanData] = find_baseline_multilead(multiLeadECG, Fs, methold)
% clear all;
% clc
% load 'E:\在元智大学\PTB Database\ill\s0034_rem.mat'%基线很剧烈
% load 'E:\在元智大学\PTB Database\ill\s0025lrem.mat'%不要超过基频的一半
% load 'E:\在元智大学\PTB Database\ill\s0031lrem.mat'%不要超过基频的一半
% load 'E:\在元智大学\PTB Database\ill\s0042lrem.mat'%有的要超过基频的一半，有的不要,适合画图
% load 'E:\在元智大学\PTB Database\ill\s0052lrem.mat'%没有超过心跳基频，但是有明显形变
% load 'E:\在元智大学\PTB Database\ill\s0557_rem.mat'%有跳变
% load 'E:\在元智大学\PTB Database\ill\s0150lrem.mat'%信号很弱
% load 'E:\在元智大学\PTB Database\ill\s0130lrem.mat'%检验基线算法，能量没有突起点,基线很强
% load 'E:\在元智大学\PTB Database\health\s0023_rem.mat' %EMG很严重
% load 'E:\在元智大学\PTB Database\health\s0476_rem.mat' %offset = 1,有一些不好
% load 'E:\在元智大学\PTB Database\health\s0533_rem.mat'
% load 'E:\在元智大学\PTB Database\health\s0534_rem.mat'%第一个点会进去
% load 'E:\在元智大学\PTB Diagnostic Database\s0007_rem.mat'%不要超过基频的一半

% load 'E:\在元智大学\MIT-BIT database\100.mat'%糟糕1.2420 650000
% load 'E:\在元智大学\MIT-BIT database\101.mat'%好1.1520 650000
% load 'E:\在元智大学\MIT-BIT database\102.mat' %1.2240
% load 'E:\在元智大学\MIT-BIT database\103.mat'%可以用于作图，WP那篇paper里用到了 1.1520
% load 'E:\在元智大学\MIT-BIT database\104.mat' %1.2420
% load 'E:\在元智大学\MIT-BIT database\105.mat'%1.3860
% load 'E:\在元智大学\MIT-BIT database\106.mat'%1.0080 频率中间有突起
% load 'E:\在元智大学\MIT-BIT database\107.mat'%1.1880
% load 'E:\在元智大学\MIT-BIT database\108.mat'%WP 那篇paper 0.9360
% load 'E:\在元智大学\MIT-BIT database\109.mat'%可以用于作图
% load 'E:\在元智大学\MIT-BIT database\111.mat'%
% load 'E:\在元智大学\MIT-BIT database\112.mat'%
% load 'E:\在元智大学\MIT-BIT database\113.mat'%第II导程不好
% load 'E:\在元智大学\MIT-BIT database\114.mat'%
% load 'E:\在元智大学\MIT-BIT database\115.mat'%处理较好，WP 那篇paper用到
% load 'E:\在元智大学\MIT-BIT database\116.mat'%
% load 'E:\在元智大学\MIT-BIT database\117.mat'%
% load 'E:\在元智大学\MIT-BIT database\118.mat'%
% load 'E:\在元智大学\MIT-BIT database\119.mat'%第I导程有长的ST
% load 'E:\在元智大学\MIT-BIT database\121.mat'%
% load 'E:\在元智大学\MIT-BIT database\122.mat'%
% load 'E:\在元智大学\MIT-BIT database\123.mat'%
% load 'E:\在元智大学\MIT-BIT database\124.mat'%dwt 那篇paper里用了
% load 'E:\在元智大学\MIT-BIT database\200.mat'%
% load 'E:\在元智大学\MIT-BIT database\201.mat'%
% load 'E:\在元智大学\MIT-BIT database\202.mat'%
% load 'E:\在元智大学\MIT-BIT database\203.mat'%伊朗人的paper里用了
% load 'E:\在元智大学\MIT-BIT database\205.mat'%
% load 'E:\在元智大学\MIT-BIT database\207.mat'%cutIdx = fdmtlF/2 - offset;基频检测不准
% load 'E:\在元智大学\MIT-BIT database\208.mat'%
% load 'E:\在元智大学\MIT-BIT database\209.mat'%
% load 'E:\在元智大学\MIT-BIT database\210.mat'%WP 那篇paper用到
% load 'E:\在元智大学\MIT-BIT database\212.mat'%
% load 'E:\在元智大学\MIT-BIT database\213.mat'%
% load 'E:\在元智大学\MIT-BIT database\214.mat'%
% load 'E:\在元智大学\MIT-BIT database\215.mat'%
% load 'E:\在元智大学\MIT-BIT database\217.mat'%
% load 'E:\在元智大学\MIT-BIT database\219.mat'%
% load 'E:\在元智大学\MIT-BIT database\220.mat'%
% load 'E:\在元智大学\MIT-BIT database\221.mat'%
% load 'E:\在元智大学\MIT-BIT database\222.mat'%伊朗人的paper里用了
% load 'E:\在元智大学\MIT-BIT database\223.mat'%
% load 'E:\在元智大学\MIT-BIT database\228.mat'%
% load 'E:\在元智大学\MIT-BIT database\230.mat'%
% load 'E:\在元智大学\MIT-BIT database\231.mat'%运算到end的时候，为什么基线为0
% load 'E:\在元智大学\MIT-BIT database\232.mat'%
% load 'E:\在元智大学\MIT-BIT database\233.mat'%
% load 'E:\在元智大学\MIT-BIT database\234.mat'%dwt 和 WAF 两篇篇paper里用了

% load 'D:\心电图数据\simulatedECG.mat'
% multiLeadECG = val2(:,1:10000);

% multiLeadECG = val(:,1:end);

% Fs = 1000;
% Fs = 360;
% tic
% methold = 'dct'; %dct morph

switch methold
    case 'dct'
        [len nbrChl] = size(multiLeadECG);
        if len < nbrChl
            multiLeadECG = multiLeadECG';
            [len nbrChl] = size(multiLeadECG);
        end
        
        Len5Hz = round(5*len/(Fs/2));
        Len2dot5Hz = round(2.5*len/(Fs/2));        
        dctData = dct(multiLeadECG);%10000个点长度，15导程，耗时0.038583秒
        
        tmp = [zeros(Len5Hz,nbrChl); dctData(Len5Hz+1:end,:)];
        sumData = sum(abs(idct(tmp)),2);
        clear tmp;
        
        if len>20000
            idx2dot5Hz = round(2.5*20000/(Fs/2));
            dctSumData = abs(dct(sumData(1:20000)));%耗时0.006027秒
            maxv = 0.8*max(dctSumData(2:idx2dot5Hz));%以下三条指令耗时0.004121
            idx = find(dctSumData(2:idx2dot5Hz)>maxv);
            maxIdx = idx(1)+1;
            CFF = maxIdx*Fs/40000;
%             len
            maxIdx = round(maxIdx*len/20000);
        else
            dctSumData = abs(dct(sumData));%耗时0.006027秒
            maxv = 0.8*max(dctSumData(2:Len2dot5Hz));%以下三条指令耗时0.004121
            idx = find(dctSumData(2:Len2dot5Hz)>maxv);
            maxIdx = idx(1)+1;
            CFF = maxIdx*Fs/(2*len);
        end
  
        nbrComps = 10;
        step = floor(maxIdx/10);%frequence difference between two components is 0.1*CFF
        tmp = reshape(dctData(1:step*nbrComps,:), step, nbrComps, nbrChl);
        energy = reshape(sum(abs(tmp), 1), nbrComps, nbrChl);
        energy = energy';%the dimension of 'energy' is [nbrChl nbrComps]
        
        for t = 1:nbrChl;
            [minv minIdx(t)] = min(energy(t, 1:nbrComps-1));
            tmp = [dctData(1:minIdx(t)*step,t); zeros(len-minIdx(t)*step,1)];
            BLs(t, :) = (idct(tmp))';
        end
        cleanData = multiLeadECG' - BLs;
             

        meanv = mean(energy, 2);
        meanv = meanv(:, ones(1, 10));
        energy = energy-meanv;
        
        stdv = std(energy, 1, 2);
        stdv = stdv(:, ones(1, 10));
        energy = energy./stdv;
%         toc
        
%         cutIdx = floor(maxIdx)-1;
%         tmp = [ones(cutIdx,nbrChl); zeros(len-cutIdx,nbrChl)];
%         BLs1 = (idct(tmp.*dctData))';
%         cleanData1 = multiLeadECG' - BLs1;
%         
%         cutIdx = floor(maxIdx/2)-1;
%         tmp = [ones(cutIdx,nbrChl); zeros(len-cutIdx,nbrChl)];
%         BLs2 = (idct(tmp.*dctData))';
%         cleanData2 = multiLeadECG' - BLs2;
   
%         for t = 1:1
%             figure(1)
%             panel = 4;
%             subplot(panel,1,1)
%             plot(multiLeadECG(:,t))
%             hold on
%             plot(BLs(t, :), 'r')
%             hold off
%             subplot(panel,1,2)
%             plot(cleanData1(t, :))
%             subplot(panel,1,3)
%             plot(cleanData(t, :))
%             eng = energy(t, :);
%             subplot(panel,1,4)
%             plot(eng)
%             hold on
%             plot(minIdx(t), eng(minIdx(t)), 'r*')
%             hold off
%             
%             figure(2)
%             plot(eng)
%             hold on
%             plot(minIdx(t), eng(minIdx(t)), 'r*')
%             hold off
% 
%             figure(3)
%             fft_analyse(multiLeadECG(:, t), 1000);
%             subplot(2,1,1)
%             plot(abs(dctData(1:maxIdx,t)));
% %             pause;
%         end
        
                baseline = BLs;
                varargout(1) = {energy};
                varargout(2) = {minIdx};
                varargout(3) = {CFF};

        
    case 'wavelet'
        level = 20;
        [C,L,aCell cCell] = my_wavedec(srcData,level,'db4');
        [Ea,Ed] = wenergy(C,L);
        Ed = Ed./(L(2:end-1));
        Ed = fliplr(Ed);
        %         for i = 2:length(Ed)-1
        %             if Ed(i)<Ed(i-1) && Ed(i)<Ed(i+1)
        %                 cutoffi = i;
        %                 break;
        %             end
        %         end
        diffEd = diff(Ed);
        %         sumEd = sum(Ed);
        for i = 5:length(Ed)-1
            if Ed(i) < Ed(i-1) && Ed(i) < Ed(i+1)
                cutoffi = i;
                break;
            end
        end
        
        %         if cutoffi == []
        %         [maxv cutoffi] = max(diffEd);
        % %         cutoffi = cutoffi + 1;
        %         end
        
        if cutoffi == [];
            [maxv cutoffi] = max(diffEd);
            cutoffi = cutoffi - 1;
        end
        
        C = [aCell{cutoffi}, zeros(1,length(cCell{cutoffi}))];
        L = [L(level+2-cutoffi), L(level+2-cutoffi:end)];
        baseline = waverec(C,L,'db4');
        varargout(1) = {Ed};
        varargout(2) = {cutoffi};
    case 'polyfit'
        baseline = threshold_fit(srcData, 6, 20, 'up');
    case 'median'
        baseline = find_baseline_medianfilter(srcData, 201);
        baseline = find_baseline_medianfilter(baseline, 701);
    case 'morph'
        srcData = multiLeadECG(1,:);
        structOne = 40*trimf(1:201,[1 101 201]);
        structTwo = 80*trimf(1:301,[1 151 301]);
        tmp = (opening(srcData, structOne)+closing(srcData, structOne))/2;
        
        average = (opening(tmp, structTwo)+closing(tmp, structTwo))/2;
        
        baseline = tmp - average;
        
        cleanECG = srcData-baseline;
        subplot(2,1,1)
        plot(srcData);
        hold on
        plot(baseline, 'r');
        hold off
        subplot(2,1,2)
        plot(cleanECG);
        
end