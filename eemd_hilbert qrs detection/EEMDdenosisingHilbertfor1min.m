
clear all;

close all;
clc;
%%mit-bih dataset 1min
%% load ref
data=importdata('100.txt');
ref0=data.textdata(:,1);
ref1=ref0(2:length(ref0),1);
reff=round(str2num(char(ref1))*360);
reff=reff';


%% Data Loading
ecg=load ('100m.mat');          % loading the signal 
         % loading the signal 
ecg=struct2cell(ecg);
ecg=cell2mat(ecg);
ecg0=ecg(1,:);              %Noisy ecg
Fs =360;                    % sampling frequecy

t =linspace(0,length(ecg0)/Fs,length(ecg0)); %time vector
[ecg1] = butthigh(ecg0,Fs);
%% ECG signal denoising
imf=eemd(ecg1,.2,70); %Apply the EEMD to the noisy signal .2->ratio of the standard deviation 70->ensemble number
imfs=imf';             %transpose the imf's matrix
reconstruction=imfs(4,:)+imfs(5,:)+imfs(6,:);  %We consider that these 3 imf's possess the important information


%% Emphasizing R peaks of the ECG
%Getting the maxima and minima of the ECG signal, to emphasize the R peaks
decg=(1/Fs)*(diff(reconstruction));  %derivative of the ecg
hecg=hilbert(decg); %hilbert transform of the derivative. 
envelope=abs(hecg);  %It returns the envelope of the ecg
Sfilter=smooth(envelope,40);
% %% R peaks detection 


maximum1=(max(envelope(360:3240)));
maximum2=(max(envelope(3960:6840)));
maximum3=(max(envelope(7560:10440)));
maximum4=(max(envelope(11160:14040)));
maximum5=(max(envelope(14760:17640)));
maximum6=(max(envelope(18360:21240)));
maxarry=[maximum1,maximum2,maximum3,maximum4,maximum5,maximum6];
maximum=min(maxarry);
Threshold=.6*(maximum); 
[pks,locs] = findpeaks(envelope,'MinPeakHeight',Threshold);

difloc=diff(locs);
k=1;
for i=1:length(difloc)
    if difloc(i)>50
        k=k+1;  %number of rpeaks
       realloc(k-1)=locs(i);
       realloc(k)=locs(i+1);
    end
end



%% result evaluation
for i=1:length(realloc)
     for j=1:length(reff)
         if  abs(realloc(i)-reff(j))<27
  %a matched QRS annotation should lie in 75 ms duration centered by the reference QRS annotation
           
            finalrpeak(i)=realloc(i);  
         %num(finalrpeak):Õý¼ìtp
         %if num(finalrpeak)<num(realloc),false positive exist
         %if num(finalrpeak)=num(realloc),fp=0;
         %if num(realloc)<num(reff),missed peaks exist(fn);
            break
         end
     end
end
finalrpeak=finalrpeak(find(finalrpeak~=0));
plot(ecg1)
hold on;
plot(finalrpeak,ecg1(finalrpeak),'o')
%plot(realloc,ecg1(realloc),'o')

hold on;t(reff,ecg1(reff),'x')

%legend('ECG','R peaks','Location','NorthWest');


