function [h, p] = my_ttest2(x1, x2, alpha)
    n1 = length(x1);
    n2 = length(x2);

    s1 = std(x1);
    s2 = std(x2);

    sp = sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2));

    mu1 = mean(x1);
    mu2 = mean(x2);

    t = (mu1 - mu2) / (sp * sqrt(1/n1 + 1/n2));
    
    df = n1 + n2 - 2;
    
    p = 2*(min([cdf('T',t,df), 1-cdf('T',t,df)]));
    
    h = double(p < alpha);
