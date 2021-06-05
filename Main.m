[msg_t,fs] = audioread('eric.wav');
L = length(msg_t);
sound(msg_t,fs);

%plot in time domain 
tvec = linspace(0,length(msg_t)/fs,length(msg_t));
figure; subplot(2,1,1);
plot(tvec,msg_t); title('Msg Signal in Time');

%plot in frequency domain
Msg_f = abs(fftshift(fft(msg_t)));
fvec = linspace(-fs/2,fs/2,length(Msg_f));
subplot(2,1,2); plot(fvec, Msg_f); title('Msg Signal in Frequency Domain');

% acts as time delay between playing sound file before and after LPF
input('Press Enter to Continue...');

% LPF construction cut-off 4kHz
n = length(Msg_f);
sampPerFreq = int64(n/fs);
limit = sampPerFreq * (fs/2 - 4000);
Msg_f([1:limit n-limit+1:end]) = 0;
figure;
subplot(2,1,2);
plot(fvec, Msg_f); title('Filtered msg in f-domain');
msg_t = real(ifft(ifftshift(Msg_f)));
subplot(2,1,1);
plot(tvec, msg_t); title('Filtered msg in t-domain');

sound(msg_t,fs);

% NBFM mod
% beta << 1 for NBFM
fc = 100000; %10^5 Hz
fs = 5 * fc;
fDev = 50;
figure;
s_t = fmmod(msg_t, fc, fs, fDev);
plot(tvec ,msg_t ,'c' ,tvec ,s_t ,'b--')

figure;
S_f = abs(fftshift(fft(s_t)));
fvec = linspace(-fs/2,fs/2,length(S_f));
plot(fvec, S_f); title('FM signal in Frequency Domain');