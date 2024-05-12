clc;
clear all;

for i = 1:500

% ¶ÁÈ¡ÒôÆµÎÄ¼ş
    [x1, Fs1] = audioread('blue_leida.wav');
    
    [ x1 ] = fx_FIR( Fs1,randi([50 120]),randi([800 1200]),x1);
   
    audiowrite([num2str(i) '.wav'],x1,Fs1);
end
