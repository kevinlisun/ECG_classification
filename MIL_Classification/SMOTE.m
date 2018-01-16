function [ syntheticInst ] = SMOTE( organInst, N, k )

    %k为选择的近邻数
    %N为生成后总样本数
    orgNum = size( organInst, 1 );
    synNum = N - orgNum;
    syntheticInst = organInst;
    
    if synNum== 0
        syntheticInst = organInst;
        return;
    end
    
    if( synNum >= orgNum )
        iter = fix(synNum/orgNum);
        for i = 1:iter
            [ tempSynth ] = Synthetize( organInst, [1:orgNum], k );
            syntheticInst = [ syntheticInst; tempSynth ];
        end
        synNum = synNum - iter*orgNum;
    end

    if synNum == 0
        return;
    end
    
    if( synNum < orgNum )
        list = randperm( orgNum );
        [ tempSynth ] = Synthetize( organInst, list(1:synNum), k );
        syntheticInst = [ syntheticInst; tempSynth ];
    end
    
    
       
        
        