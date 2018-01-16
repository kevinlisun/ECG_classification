% function [baseline energy cutoffi maxi  idctData ] = find_baseline(srcData, methold)
function [baseline, varargout] = find_baseline(srcData, methold)
% nout = max(nargout,1)-1;
switch methold
    case 'dct'
        len = length(srcData);
        dctData = dct(srcData);
        
        nbrPoints = 48;
        nbrComps = nbrPoints/2;
        idctData = zeros(nbrComps, len);
        energy = zeros(1, nbrComps);
        %%%=============效率提高的地方
        w(1) = 1/sqrt(len);
        w(2:nbrPoints) = w(1)*sqrt(2);
        k = pi*0.5*0.0001;
        dctData(1:nbrPoints) = dctData(1:nbrPoints).*w(1:nbrPoints);

        count = 1;
        for i = 1:6:nbrPoints
            for n = 1:len
                m = k*(2*n-1);
                idctData(count,n) = dctData(i)*cos(m*(i-1))+...
                    dctData(i+1)*cos(m*(i));
                
                idctData(count+1,n) = dctData(i+2)*cos(m*(i+1))+...
                dctData(i+3)*cos(m*(i+2));
            
                idctData(count+2,n) = dctData(i+4)*cos(m*(i+3))+...
                dctData(i+5)*cos(m*(i+4));
                
%                 idctData(count+3,n) = dctData(i+6)*cos(m*(i+5))+...
%                 dctData(i+7)*cos(m*(i+6));
            end
            
            energy(count) = sqrt(sum(((idctData(count,:)).^2)));
            energy(count+1) = sqrt(sum(((idctData(count+1,:)).^2)));
            energy(count+2) = sqrt(sum(((idctData(count+2,:)).^2)));
%             energy(count+3) = sqrt(sum(((idctData(count+3,:)).^2)));
            count = count+3;
        end
        %%%=============
        slidwd = 4;
        for i=1:nbrComps-slidwd+1            
            [maxv maxi] = max(energy(i:i+slidwd-1));
            if maxi == slidwd
                break;
            end
        end
        
        maxi = maxi+i-1;
        
        [minv cutoffi] = min(energy(i:i+slidwd-1));
        if i == nbrPoints/2-3
            cutoffi = i-3;
        else
%             cutoffi = cutoffi + i - 1;
            cutoffi = maxi -1;
        end

        baseline = sum(idctData(1:cutoffi, :), 1);%注意
        cleanData = srcData - baseline;
        cleanData = cleanData -  median(cleanData);
        
        baseline = srcData - cleanData;
        varargout(1) = {energy};   
        varargout(2) = {cutoffi};
        varargout(3) = {maxi};
        varargout(4) = {idctData};
        
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
        structOne = 40*trimf(1:41,[1 21 41]);
        structTwo = 80*trimf(1:81,[1 41 81]);
        tmp = (opening(srcData, structOne)+closing(srcData, structOne))/2;
        
        average = (opening(tmp, structTwo)+closing(tmp, structTwo))/2;
        
        baseline = tmp - average;
        
end