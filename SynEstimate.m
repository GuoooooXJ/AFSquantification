function [t,cfs,Metric] = SynEstimate(time,signal,fs,layerNum,basis,frequencyBand)
%AFS quantification using staionary wavelet transform.
%   Use as:
%       [t,cfs,Metric] = SynEstimate(time,signal,fs,layerNum,basis,frequencyBand)
%   Input:
%       - time, original time
%       - signal, raw signal(after 2-90hz filtering is supposed)
%       - fs, sampling rate of raw signal(384 in this study)
%       - layerNum, decomposition layer number of staionary wavelet
%       transform(6 in this study)
%       - basis, wavelet function('sym8' in this study)
%       - frequencyBand, jth layer in decomposition(4 in this study is low beta band)
%   Output:
%       - t, cutted time
%       - cfs, stationary wavelet coefficients
%       - Metric, AFS quantification sequence
%
%
%   Author   : Xuanjun Guo
%   Created  : Jan 30, 2024
%   Modified : Feb 1, 2024


%% Compute SWT coefficients sequence
[swa,swd] = swt(signal,layerNum,basis);

windowlength = 0.6;%Total /s
%windowlength = 0.28;%Shorter /s

step = 1;
thrswin = round(fs * windowlength);
Signal = swd(frequencyBand,:);
nStepThrs = ceil(thrswin/step);
nStepTemp = ceil((thrswin/2-step/2)/step);
    
%% Detect synchronization state
startPointThrs = nStepThrs*step + 1;
startPointTemp = nStepTemp*step + 1;
endPoint = startPointTemp + step - 1;
nStep = floor((length(Signal)-(startPointThrs-1))/step);

cfs = zeros(1, step*nStep);
thrs  = zeros(1, step*nStep);
    
for iStep = 1:nStep
    idx = (1:step)+(iStep-1)*step;

    % Extract coefficients
    cfsThrsOri  = Signal((1:thrswin)+(iStep-1)*step);
    cfsThrs = cfsThrsOri;
    cfs(idx) = Signal((startPointTemp:endPoint)+(iStep-1)*step);
    
    % Compute threshold
    cfsThrs = controlChart(cfsThrs);
    lambda = Estimation(cfsThrs,frequencyBand);
    thrs(idx)  = lambda;
    
end
    
t = time(startPointTemp:startPointTemp+nStep*step-1);
Metric = thrs;


end

