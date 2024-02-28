%% Load signal
load("MATRIX_DBS.mat")
nside = length(MATRIX_DBS.fs);

TotalPowerONDBS = cell(nside,1);
TotalThrONDBS = cell(nside,1);
TotalFreStdONDBS = cell(nside,1);

TotalPowerOFFDBS = cell(nside,1);
TotalThrOFFDBS = cell(nside,1);
TotalFreStdOFFDBS = cell(nside,1);

meanWin = 0.6;
%% Low beta
layerNum = 6;
basis = 'sym8';
frequencyBand = 4;
filterPara.fp_highpass=12;
filterPara.fp_lowpass=24;

for iside= 1:nside 
    fs=MATRIX_DBS.fs(iside);
    fsResample = 384;
    disp(['Sub: ' num2str(iside)]);
    %% Signal
    signal_base=MATRIX_DBS.signal_base{iside};
    signal_DBS=MATRIX_DBS.signal_dbs{iside};
    
    signal_base_Resample = resample(signal_base,fsResample,fs);
    signal_DBS_Resample = resample(signal_DBS,fsResample,fs);

    %% cut signal to swt
    n  = fix(length(signal_base_Resample)/(2^layerNum));
    signal_base_Resample = signal_base_Resample(1:n*(2^layerNum));

    n  = fix(length(signal_DBS_Resample)/(2^layerNum));
    signal_DBS_Resample = signal_DBS_Resample(1:n*(2^layerNum));

    %% Amplitude and frequency stability(AFS)
    timeOn = (1:1:length(signal_DBS_Resample))/fsResample;
    timeOff = (1:1:length(signal_base_Resample))/fsResample;
    [~,CoffOn,AFSOn] =  SynEstimate(timeOn,signal_DBS_Resample',fsResample,layerNum,basis,frequencyBand);
    [~,CoffOff,AFSOff] =  SynEstimate(timeOff,signal_base_Resample',fsResample,layerNum,basis,frequencyBand);
    
    %% Amplitude based on band-pass filter
    [bpOn,~] = Bandpass(filterPara,fsResample,signal_DBS_Resample',timeOn);
    powerOn = smoothdata(abs(bpOn),"movmedian",round(meanWin*fsResample));

    [bpOff,~] = Bandpass(filterPara,fsResample,signal_base_Resample',timeOff);
    powerOff = smoothdata(abs(bpOff),"movmedian",round(meanWin*fsResample));

    %% Frequency stability
    insFreq = fsResample/(2*pi)*diff(unwrap(angle(hilbert(bpOn))))';
    windowed_data = buffer(insFreq, round(meanWin*fsResample), round(meanWin*fsResample)-1, 'nodelay');
    FreStdOn = var(windowed_data);

    insFreq = fsResample/(2*pi)*diff(unwrap(angle(hilbert(bpOff))))';
    windowed_data = buffer(insFreq, round(meanWin*fsResample), round(meanWin*fsResample)-1, 'nodelay');
    FreStdOff = var(windowed_data);

    TotalPowerONDBS(iside) = {powerOn};
    TotalThrONDBS(iside) = {AFSOn};
    TotalFreStdONDBS(iside) = {FreStdOn};

    TotalPowerOFFDBS(iside) = {powerOff};
    TotalThrOFFDBS(iside) = {AFSOff};
    TotalFreStdOFFDBS(iside) = {FreStdOff};

end