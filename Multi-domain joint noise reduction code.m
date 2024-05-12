clear all;
%%
fid = fopen('data_chirp_leida.bin','r');
adcData = fread(fid , 'int16');
fclose(fid);
numADCSamples = 140; % number of ADC samples per chirp
numADCBits = 16; % number of ADC bits per sample
numRX = 4; % number of receivers
numLanes = 2; % do not change. number of lanes is always 2
fileSize = size(adcData, 1);
numChirps = fileSize/2/numADCSamples/numRX;
LVDS = zeros(1, fileSize/2);
%combine real and imaginary part into complex data
%read in file: 2I is followed by 2Q
counter = 1;
for i=1:4:fileSize-1
LVDS(1,counter) = adcData(i) + sqrt(-1)*adcData(i+2); 
LVDS(1,counter+1) = adcData(i+1)+sqrt(-1)*adcData(i+3); 
counter = counter + 2;
end
% create column for each chirp
LVDS = reshape(LVDS, numADCSamples*numRX, numChirps);
%each row is data from one chirp
LVDS = LVDS.';

%organize data per RX
adcData = zeros(numRX,numChirps*numADCSamples);
for row = 1:numRX
for i = 1: numChirps
adcData(row, (i-1)*numADCSamples+1:i*numADCSamples) = LVDS(i, (row-1)*numADCSamples+1:row*numADCSamples);
end
end
% return receiver data
retVal = adcData;
%%
retVal_1 = retVal(2:4,:);
retVal_1(1,:) = retVal_1(1,:)-mean(retVal_1(1,:));
retVal_1(2,:) = retVal_1(2,:)-mean(retVal_1(2,:));
retVal_1(3,:) = retVal_1(3,:)-mean(retVal_1(3,:));
N=140; % 采样点数
C=107800; % chirp数
hamming1=hamming(N);
retVal_1=retVal_1';
%%
carrierFreq = 77e9;
wavelength = physconst('LightSpeed')/carrierFreq;
%%
ula = phased.ULA('NumElements',3,'ElementSpacing',wavelength/2);
ula.Element.FrequencyRange = [77e9 81e9];
%%
lcmvbeamformer = phased.LCMVBeamformer('WeightsOutputPort',true);
%%
steeringvec = phased.SteeringVector('SensorArray',ula);
stv = steeringvec(carrierFreq,[19 -18 -19]);
%%
lcmvbeamformer.Constraint = stv;
lcmvbeamformer.DesiredResponse = [1;0;0];
%%
[yLCMV,wLCMV] = lcmvbeamformer(retVal_1);
yLCMV=yLCMV';
%%
sigRwin=zeros(N,C);
range_fft=zeros(N,C);
retVal_2 = reshape(yLCMV,N,C);
for ii=1:C
    sigRwin(:,ii)=hamming1.*retVal_2(:,ii);
    range_fft(:,ii)=fft(sigRwin(:,ii),N);
end
[e,y]=max(abs(range_fft(:,1)));
figure(1)
plot(abs(range_fft(:,1)))
fft_1=range_fft(8,:);
xiangwei = angle(fft_1);
xiangwei_1 = xiangwei;



%%
fs=48000;
[ y_ppf ] = fx_FIR( fs,100,1000,xiangwei);
y_ppf=v_specsub(y_ppf,fs);%使用频谱减法执行语音增强
%y_ppf=v_specsub(y_ppf,fs);%使用频谱减法执行语音增强
% y_ppf(74300:74800)=0;
% y_ppf=y_ppf(28180:100180);
y_ppf=y_ppf(8000:80000);
y_ppf=y_ppf/max(y_ppf);
sound(y_ppf,fs);
figure(2)
plot(y_ppf);
title('雷达采集bull信号时域波形');
xlim([0 72000])

%%
figure(3)
gnew_fft=fft(y_ppf);
n=length(y_ppf);
P2 = abs(gnew_fft/n); %n为序列的长度
P1 = P2(1:n/2+1);  %取单边谱
P1(2:end-1) = 2*P1(2:end-1); %幅值修正，第一个0频率点和最后一个点n/2+1均不需要乘2
f = 48e3*(0:(n/2))/n; %横轴频率向量
P1=P1./max(P1);
figure(3)
plot(f,P1);
axis([0 1.5e3 0 1]);
title('雷达采集bull信号频谱图');
%%
window = kaiser(2048);
[B, F, T, P] = spectrogram(y_ppf,window,2040,2048,48000,'yaxis');
figure(4)
imagesc(T,F,20*log10((abs(B))));
set(gca,'YDir','normal')%设置y轴数值为正常显示
ylim([0,1300]);%y轴范围
h = colorbar;
h.Label.String = 'Power(dB)';
title('雷达采集bull时频图')
xlabel('时间/s');
ylabel('频率/hz')
%%
% y_ppf_2=y_ppf_1(69000:94000);
% audiowrite('C:\Users\Administrator\Desktop\语音信号评估\代码\red_Yeah_daizu.wav',y_ppf_2,48e3);