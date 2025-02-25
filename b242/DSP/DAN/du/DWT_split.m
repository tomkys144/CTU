%function to split signal into two frequency bands
%sig = signal
%b0 = coefficients of LPF
%c = lower band signal
%d = upper band signal

function bands = DWT_split(sig, b0)
    %derived HPF coefficients
    b1 = b0;
    b1(2:2:end) = -b1(2:2:end);
    
    %filtration of signal to lower and upper frequency band
    LB_sig = filter(b0,1,sig);
    UB_sig = filter(b1,1,sig);
    
    %decimation by factor of 2
    LB_sig_dec = LB_sig(1:2:end);
    UB_sig_dec = UB_sig(1:2:end);
    
    bands = [LB_sig_dec, UB_sig_dec];
end