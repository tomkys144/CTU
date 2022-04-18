function [SD,Fzrc, Fmed, M1] = ekg_param_fce(seg,T,fs)
    %sd
    SD=std(seg);
    
    %Fzrc – frekvence dle počtu průchodů nulou
    sn=sign(seg); sn(sn==0)=1;
    zrc=sum(diff(sn)~=0);
    Fzrc=0.5*zrc/T;
    
    % mediánová frekvence
    P=abs(fft(seg)).^2;
    F=linspace(0, fs-fs/length(seg),length(seg));
    P=P(1:floor(end/2));
    F=F(1:floor(end/2));
    
    
    CDF=cumsum(P);
    CDF=CDF/max(CDF);
    Fmed=F(find(CDF>=0.5,1));
    
    % 1. spektrální moment
    M1=sum(F(:).*P(:))/sum(P);
end

