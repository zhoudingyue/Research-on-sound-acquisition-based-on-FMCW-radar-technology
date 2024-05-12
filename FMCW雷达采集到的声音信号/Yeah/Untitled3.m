clc;
clear all;

for i = 1:1

% ¶ÁÈ¡ÒôÆµÎÄ¼ş
    [x1, Fs1] = audioread('blue_leida.wav');
    [x2, Fs2] = audioread('Yeah.wav');
    [ x1 ] = fx_FIR( Fs1,randi([50 120]),randi([800 1200]),x1);
    x3 = x1(5001:30001)*4+x2;
    audiowrite([num2str(i) '.wav'],x3,Fs2);
end
