[sig_t,fs] = audioread('eric.wav');
L = length(sig_t);
sound(sig_t,fs);

tvec = linspace(0,length(sig_t)/fs,length(sig_t));
%plot in frequency domain
sig_f = abs(fftshift(fft(sig_t)));
fvec = linspace(-fs/2,fs/2,length(sig_f));
subplot(2,1,2); plot(fvec,sig_f); title('Original Signal in Frequency');


% LPF construction cut-off 4kHz
n = length(sig_f);
sampPerFreq = int64(n/fs);
limit = sampPerFreq * (fs/2 - 4000);
sig_f([1:limit n-limit+1:end]) = 0;
figure;
subplot(2,1,2);
plot(fvec, sig_f);
title('Filtered signal in f-domain');
sig_t = real(ifft(ifftshift(sig_f)));
subplot(2,1,1);
plot(tvec, sig_t);
title('Filtered signal in t-domain');

sound(sig_t,fs);

