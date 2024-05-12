function [ Y ] = fx_FIR( fs, wc1 ,wc2 , signal)
%===============IIR����˲���===============   
Wn=[wc1*2 wc2*2]/fs;                              
[b,a]=butter(1,Wn);     
Y=filtfilt(b,a,signal); 

%===============FIR����˲���===============   
%b = fir1(50, [wc1*2/fs wc2*2/fs]);
%Y = filtfilt(b,1,signal);            

end