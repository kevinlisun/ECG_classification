function denoiseData = denoise_HF(multiLeadECG, Fs)
[len nbrChl] = size(multiLeadECG);
if len < nbrChl
    multiLeadECG = multiLeadECG';
    [len nbrChl] = size(multiLeadECG);
end

Len45Hz = round(45*len/(Fs/2));
dctData = dct(multiLeadECG);
tmp = [dctData(1:Len45Hz,:); zeros(len-Len45Hz,nbrChl)];
denoiseData = (idct(tmp))';