clc;
clear all;

for i = 1:500

% ��ȡ��Ƶ�ļ�
    [x1, Fs1] = audioread('���ϴ�_blue.wav');
    x1=awgn(x1,15);
   
    audiowrite([num2str(i) '.wav'],x1,Fs1);
end
