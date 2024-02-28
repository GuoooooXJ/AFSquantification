function [t,cfs,thrs,Metric] = SynEstimate(time,signal,fs,layerNum,basis,frequencyBand)
% Compute SWT coefficients sequence
[swa,swd] = swt(signal,layerNum,basis);
%swd = swd(:,fs:end-fs);
%time = time(:,fs:end-fs);

windowlength = 0.6;%Total /s
%windowlength = 0.28;%Shorter /s

step = 1;
thrswin = round(fs * windowlength);
Signal = swd(frequencyBand,:);
nStepThrs = ceil(thrswin/step);
nStepTemp = ceil((thrswin/2-step/2)/step);
    
% Detect synchronization state
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

