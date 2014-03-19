function y = testQuantizer()
%to test the Quantizer
Xm = 10;
Num = 10^4;

for B = 1:15
    Delta = Xm/2^B;
    a = (-2^(B+1)-1)*Delta/2;
    b = (2^(B+1)-1)*Delta/2;
    input = a+(b-a).*rand(1,Num);
    for i = 1:length(input)
        output(i) = Quantizer(input(i), Xm, B);
    end
    varError(B) = var(input-output);
    varInput(B) = var(input);
    SNRTest(B) = 10*log10(varInput(B)/varError(B));
    SNRTheory(B) = 6.02*B+10.8-20*log10(Xm/sqrt(varInput(B)));
end
bits = 2:16;
h = plot(bits, SNRTest,'--rs', bits, SNRTheory, 'blue');
legend(h, 'Test', 'Theory','location','northwest');
xlabel('Number of bits of quantizer','FontSize',15);
ylabel('SNR(dB)','FontSize',15);
title('Standard Uniform Quatization','FontSize', 15);
% B=2;
% Delta = Xm/2^B;
%     a = (-2^(B+1)-1)*Delta/2;
%     b = (2^(B+1)-1)*Delta/2;
%     input = a+(b-a).*rand(1,Num);
%     for i = 1:length(input)
%         output(i) = Quantizer(input(i), Xm, B);
%     end
% error = output-input;
% h1 = plot(output-input);
% %legend(h1, 'input', 'output');



