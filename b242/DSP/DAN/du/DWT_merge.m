function sig = DWT_merge(bands, b0)

    
    %band signals
    z0 = bands(:,1);
    z1 = bands(:,2);

    %derived HPF coefficients
    b1 = b0;
    b1(2:2:end) = -b1(2:2:end);

    %synthesis LPF coefficients
    M=length(b0)-1;
    bg0 = fliplr(b0);
   

    %synthesis HPF coefficients
    bg1 = fliplr(b1);
   

    %interpolation by a factor of 2
    x0=zeros(2*length(z0),1) ;
    x1=zeros(2*length(z1),1) ;

    x0(1:2:end)=z0 ;
    x1(1:2:end)=z1 ;
    
    %filtration of signal after interpolation
    LB_sig = filter(bg0,1,x0);
    UB_sig = filter(bg1,1,x1);
    
    %addition of the signals
    sig = 2*(LB_sig + UB_sig);
end