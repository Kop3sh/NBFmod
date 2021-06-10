clear
clc
close all


[msg_t,fs] = audioread('eric.wav');
L = length(msg_t);
% sound(msg_t,fs);

%plot in time domain 
tvec = linspace(0,length(msg_t)/fs,length(msg_t));
figure(1); 
subplot(2,1,1); plot(tvec,msg_t); title('Msg Signal in Time');

%plot in frequency domain
Msg_f = abs(fftshift(fft(msg_t)));
fvec = linspace(-fs/2,fs/2,length(Msg_f));
subplot(2,1,2); plot(fvec, Msg_f); title('Msg Signal in Frequency Domain');

% acts as time delay between playing sound file before and after LPF
% input('Press Enter to Continue...');

% LPF construction cut-off 4kHz------------------------------------------
% n = length(Msg_f);
% sampPerFreq = floor(n/fs);
% limit = sampPerFreq * (fs/2 - 4000);
% Msg_f([1:limit n-limit+1:end]) = 0;
% figure;
% subplot(2,1,2); plot(fvec, Msg_f); title('Filtered msg in f-domain');
% msg_t = real(ifft(ifftshift(Msg_f)));
% subplot(2,1,1);
% plot(tvec, msg_t); title('Filtered msg in t-domain');

% mean(Msg_f)
% sound(msg_t,fs);

% NBFM mod ---------------------------------------------------------------
% beta << 1 for NBFM
% const params
fc = 100000;        %10^5 Hz
fs_new = 5 * fc;    %new sampling feq (upsampling)
A = 10;             %amplitude
Kf = 2*pi*10e-2;    %frequency sensetivity

msg_t_resam = resample(msg_t,fs_new,fs);
tvec_new = linspace(0,length(msg_t_resam)/fs_new,length(msg_t_resam));

phi = cumsum(msg_t_resam);
s_t = A*cos((2*pi*fc*tvec_new)' + Kf * phi);
s_f = abs(fftshift(fft(s_t)));
fvec_new = linspace(-fs_new/2,fs_new/2,length(s_f));
figure(2);
plot(fvec_new, s_f); title('FM signal in Frequency Domain');


% demod----------------------------------------------------------------
y = diff(s_t);
r3_t = [y ;0];
figure(3);
subplot(2,1,1); plot(tvec_new, r3_t); title('recieved signal after diff in t-domain');
r3_f = abs(fftshift(fft(r3_t)));
subplot(2,1,2); plot(fvec_new, r3_f); title('recieved signal after diff in f-domain');

env = abs(hilbert(real(r3_t)));     %ED
r2_t = env - mean(env);             % DC blocking (cap)
figure(4);
subplot(2,1,1); plot(tvec_new,r2_t); title('envelope in t-domain');
r2_f = abs(fftshift(fft(r3_t)));
subplot(2,1,2); plot(fvec_new, r2_f); title('enevlope in f-domain');
% LPF construction cut-off 4kHz------------------------------------------
% env_f = abs(fftshift(fft(r2_t)));
% fvec = linspace(-fs_new/2,fs_new/2,length(env));
% n = length(s_t);
% sampPerFreq = floor(n/fs_new);
% limit = sampPerFreq * (fs_new/2 - 4000);
% env_f([1:limit n-limit+1:end]) = 0;
% figure(4);
% subplot(2,1,2); plot(fvec, env_f); title('Filtered msg in f-domain');
% r2_t = real(ifft(ifftshift(env_f)));
% subplot(2,1,1);
% y = diff(r2_t);

r1_t = resample(r2_f,fs,fs_new);
sound(r1_t,fs);
