function y = LPF(x, M)
%implement lowpass filter, x is the input, M is the cutoff
%frequency(normalized to 1), y is the output
xF = fft(x);
L = round((length(xF)+1)/2/M);
xF(L+1:length(xF)-L+1) = 0;
y = ifft(xF);