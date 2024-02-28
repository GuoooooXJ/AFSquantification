function [s_out,t_out] = Bandpass(filterPara,fs,s_in,t_in)


ap = 1;

lp_h = fdesign.lowpass('n,fp,ap',10,filterPara.fp_lowpass,ap,fs);%24Hz lowpass
lp_Hd = design(lp_h,'cheby1');
s_lp1 = filtfilt(lp_Hd.sosMatrix,lp_Hd.ScaleValues,s_in);

hp_h = fdesign.highpass('n,fp,ap',8,filterPara.fp_highpass,ap,fs);%12Hz highpass
hp_Hd = design(hp_h,'cheby1');
s_hp1 = filtfilt(hp_Hd.sosMatrix,hp_Hd.ScaleValues,s_lp1);



%s_lp1 = lowpass(s_in,filterPara.fp_lowpass,fs);
%s_hp1 = highpass(s_lp1,filterPara.fp_highpass,fs);
%{
lp_h = fdesign.lowpass('n,fp,ap',8,filterPara.fp_lowpass,ap,fs);%24Hz lowpass
lp_Hd = design(lp_h,'cheby1');
s_lp2 = filtfilt(lp_Hd.sosMatrix,lp_Hd.ScaleValues,s_in);

hp_h = fdesign.highpass('n,fp,ap',6,filterPara.fp_highpass,ap,fs);%12Hz highpass
hp_Hd = design(hp_h,'cheby1');
s_hp2 = filtfilt(hp_Hd.sosMatrix,hp_Hd.ScaleValues,s_lp2);

figure
plot(t_in(fs:end-fs),s_hp1(fs:end-fs),t_in(fs:end-fs),s_hp2(fs:end-fs))
legend('High order','Low order')
%}

s_out = s_hp1(fs:end-fs);
t_out = t_in(fs:end-fs);

end