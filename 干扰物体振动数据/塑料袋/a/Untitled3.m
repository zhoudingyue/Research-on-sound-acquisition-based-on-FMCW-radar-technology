clc;
clear all;

for i = 1:500

% 读取音频文件
    [x1, Fs1] = audioread('塑料袋_blue.wav');
    x1=awgn(x1,15);
   
    audiowrite([num2str(i) '.wav'],x1,Fs1);
end
