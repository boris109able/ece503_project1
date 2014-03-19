function y = Quantizer(x, Xm, B)
%x is the input of the quantizer
%2Xm is the full-scale range
%B+1 is the number of quantizer bits

%y is the output of the quantizer

Delta = Xm/2^B;
% the i th border is -9*Delta/2+i*Delta
if (x <= -(2^(B+1)+1)*Delta/2)%check if the input less than the left extreme value
    y =  -2^B*Delta;
elseif ((x > (2^(B+1)-1)*Delta/2))%check if the input greater than the left extreme value
    y = (2^B-1)*Delta;
else%use binary search to find the corresponding bin then the output
    lo = 0;
    hi = 2^(B+1);
    mid = floor((hi+lo)/2);
    while (mid ~= lo)
        if (x <= -(2^(B+1)+1)*Delta/2+mid*Delta)
            hi = mid;
        else
            lo = mid;
        end
        mid = floor((hi+lo)/2);
    end
    y = (-2^B+lo)*Delta;
end
  
         

