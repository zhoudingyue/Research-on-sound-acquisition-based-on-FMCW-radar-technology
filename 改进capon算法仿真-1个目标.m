
close all;clc;

source_number=1;
%��Ԫ��
sensor_number=4;
%��Ԫ��
N_x=2000; 
%�źų���
snapshot_number=N_x;
%������
w=[pi/4].';
%�ź�Ƶ��
l=sum(2*pi*3e8./w)/3;
%�źŲ��� 
d=0.5*l;
%��Ԫ���
snr=5;
%�����

source_doa=[0];%�����źŵ�����Ƕ�

A=[exp(-1j*(0:sensor_number-1)*d*2*pi*sin(source_doa(1)*pi/180)/l)].';%��������

s=sqrt(10.^(snr/10))*exp(1j*w*[0:N_x-1]);
%�����ź�
x=awgn(s,snr);
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1j*randn(sensor_number,N_x));%���˸�˹������������н����ź�

R=x*x'/snapshot_number;
iR=inv(R);
[V,D]=eig(R);
Un=V(:,1:sensor_number-source_number);
Gn=Un*Un';[U,S,V]=svd(R);
Un=U(:,source_number+1:sensor_number);
Gn=Un*Un';

searching_doa=-90:0.1:90;
%�����������ΧΪ-90~90�� 
for i=1:length(searching_doa) 
    a_theta=exp(-1j*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l);
    %Pmusic(i)=a_theta'*a_theta./abs((a_theta)'*Gn*a_theta); 
    Pmcapon(i)=1./abs((a_theta)'*iR^4*a_theta); 
    Pcapon(i)=1./abs((a_theta)'*iR*a_theta); 
end
plot(searching_doa,10*log10(Pmcapon),'k-',searching_doa,10*log10(Pcapon),'b--');
axis([-90 90 -20 50]);xlabel('�Ƕ�/degree');
ylabel('�źŹ���/dB');
legend('�Ľ���Capon�㷨','Capon�㷨');
grid on;