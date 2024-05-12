function sk = spectral_kurtosis(x, Fs, win_size, hop_size)
% ����ÿ֡��Spectral Kurtosis

% ����˵����
% x: ��Ƶ�ź�
% Fs: ������
% win_size: ���ڴ�С
% hop_size: ֡��

N = length(x); % ��Ƶ�źŵĳ���
num_frames = floor((N-win_size)/hop_size) + 1; % ����֡��

sk = zeros(num_frames, 1); % ��ʼ��Spectral Kurtosis

for i = 1:num_frames
    % ��֡
    start_idx = (i-1) * hop_size + 1;
    end_idx = start_idx + win_size - 1;
    x_frame = x(start_idx:end_idx);
    
    % ���������
    X = abs(fft(x_frame .* hamming(win_size)));
    
    % ����Spectral Kurtosis
    sk(i) = sum((1/win_size) * (X.^4)) / (sum((1/win_size) * (X.^2)))^2;
end
end
