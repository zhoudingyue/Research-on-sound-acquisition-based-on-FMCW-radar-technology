function [ Y ] = fx_FIR( fs, wc1 ,wc2 , signal)
%===============IIR设计滤波器===============   
Wn=[wc1*2 wc2*2]/fs;                              
[b,a]=butter(1,Wn);     
Y=filtfilt(b,a,signal); 

%===============FIR设计滤波器===============   
%b = fir1(50, [wc1*2/fs wc2*2/fs]);
%Y = filtfilt(b,1,signal);            

end