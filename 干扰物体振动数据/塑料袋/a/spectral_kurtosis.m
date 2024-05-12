function sk = spectral_kurtosis(x, Fs, win_size, hop_size)
% 计算每帧的Spectral Kurtosis

% 参数说明：
% x: 音频信号
% Fs: 采样率
% win_size: 窗口大小
% hop_size: 帧移

N = length(x); % 音频信号的长度
num_frames = floor((N-win_size)/hop_size) + 1; % 计算帧数

sk = zeros(num_frames, 1); % 初始化Spectral Kurtosis

for i = 1:num_frames
    % 分帧
    start_idx = (i-1) * hop_size + 1;
    end_idx = start_idx + win_size - 1;
    x_frame = x(start_idx:end_idx);
    
    % 计算幅度谱
    X = abs(fft(x_frame .* hamming(win_size)));
    
    % 计算Spectral Kurtosis
    sk(i) = sum((1/win_size) * (X.^4)) / (sum((1/win_size) * (X.^2)))^2;
end
end
