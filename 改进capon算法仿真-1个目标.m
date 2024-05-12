
close all;clc;

source_number=1;
%信元数
sensor_number=4;
%阵元数
N_x=2000; 
%信号长度
snapshot_number=N_x;
%快拍数
w=[pi/4].';
%信号频率
l=sum(2*pi*3e8./w)/3;
%信号波长 
d=0.5*l;
%阵元间距
snr=5;
%信噪比

source_doa=[0];%两个信号的入射角度

A=[exp(-1j*(0:sensor_number-1)*d*2*pi*sin(source_doa(1)*pi/180)/l)].';%阵列流型

s=sqrt(10.^(snr/10))*exp(1j*w*[0:N_x-1]);
%仿真信号
x=awgn(s,snr);
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1j*randn(sensor_number,N_x));%加了高斯白噪声后的阵列接收信号

R=x*x'/snapshot_number;
iR=inv(R);
[V,D]=eig(R);
Un=V(:,1:sensor_number-source_number);
Gn=Un*Un';[U,S,V]=svd(R);
Un=U(:,source_number+1:sensor_number);
Gn=Un*Un';

searching_doa=-90:0.1:90;
%线阵的搜索范围为-90~90度 
for i=1:length(searching_doa) 
    a_theta=exp(-1j*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l);
    %Pmusic(i)=a_theta'*a_theta./abs((a_theta)'*Gn*a_theta); 
    Pmcapon(i)=1./abs((a_theta)'*iR^4*a_theta); 
    Pcapon(i)=1./abs((a_theta)'*iR*a_theta); 
end
plot(searching_doa,10*log10(Pmcapon),'k-',searching_doa,10*log10(Pcapon),'b--');
axis([-90 90 -20 50]);xlabel('角度/degree');
ylabel('信号功率/dB');
legend('改进的Capon算法','Capon算法');
grid on;