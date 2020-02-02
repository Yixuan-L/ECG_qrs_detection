function [ecg1] = butthigh(ecg,fs)
%% high-pass filter for baseline rejection
wp=1;
ws=0.5;
Rp=0.3;
Rs=2;
[N1,Wn1]=buttord(wp/(fs/2),ws/(fs/2),Rp,Rs);
[b1,a1]=butter(N1,Wn1,'high');
ecg1 = filtfilt(b1, a1, ecg);
end

