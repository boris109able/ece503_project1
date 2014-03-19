function o = withNoise(M)
%to implement oversampled uniform quantization with noise shaping
Xm = 10;
Num = 2*10^4;%length of input signal
%M = 4;

for B = 1:15
    Delta = Xm/2^B;
    a = (-2^(B+1)-1)*Delta/2;
    b = (2^(B+1)-1)*Delta/2;
    input = a+(b-a).*rand(1,Num);
    %lowpass filter
    input2 = LPF(input, M);
    
    input2Min = min(input2);
    input2Max = max(input2);
    inputRaw = (b-a)/(input2Max-input2Min).*(input2-input2Min)+a;%scale the to make the input signal not saturate the quantizer
    
    %input2 is the actual input to be considered in SNR
    %input3 = upsample(inputRaw, M);
     for i = 1:length(inputRaw)
         if i==1
             x1(i) = inputRaw(i);
             x2(i) = x1(i);
             y(i) = Quantizer(x2(i), Xm, B);
         else
             x1(i) = inputRaw(i) - y(i-1);
             x2(i) = x1(i) + x2(i-1);
             y(i) = Quantizer(x2(i), Xm, B);
         end
     end

    %signal1 = inputRaw;
%     noise1 = xHat-inputRaw;
%     figure(1);plot(abs(fft(xHat)));title('xHat');
%     figure(2);plot(abs(fft(signal1)));title('signal1');
%     figure(3);plot(abs(fft(noise1)));title('noise1');

    %lowpass filter
    output1 = LPF(y, M);
%     signal2 = LPF(signal1, M);
%     noise2 = LPF(noise1, M);
%     figure(4);plot(abs(fft(output1)));title('output1');
%     figure(5);plot(abs(fft(signal2)));title('signal2');
%     figure(6);plot(abs(fft(noise2)));title('noise2');

    %downsample
    output2 = downsample(output1, M);
%     signal3 = downsample(signal2, M);
%     noise3 = downsample(noise2, M);
%     figure(7);plot(abs(fft(output2)));title('output2');
%     figure(8);plot(abs(fft(signal3)));title('signal3');
%     figure(9);plot(abs(fft(noise3)));title('noise3');
 
    varError(B) = var(output2-inputRaw(1:M:end));
    varInput(B) = var(inputRaw(1:M:end));
    SNRTest(B) = 10*log10(varInput(B)/varError(B));
    SNRTheory(B) = 6.02*B+5.62-20*log10(Xm/sqrt(varInput(B)))+30*log10(M);
end
bits = 2:16;
h = plot(bits, SNRTest,'--rs', bits, SNRTheory, 'blue');
legend(h, 'Test', 'Theory','location','northwest');
xlabel('Number of bits of quantizer','FontSize',15);
ylabel('SNR(dB)','FontSize',15);
str = sprintf('Oversampled Uniform Quantization with Noise Shaping M= %u', M);
title(str, 'FontSize', 15);
    