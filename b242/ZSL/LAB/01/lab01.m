%% 1 Introduction to Matlab

img = imread("ct_brain.jpg");
figure
histogram(img)

im_skull = ones(size(img)) * 255;
im_skull(img < 200) = 0;
figure
imshow(im_skull);

im_brain = ones(size(img)) * 255;
im_brain(img < 50) = 0;
im_brain(img > 200) = 0;
figure
imshow(im_brain)

gaussfilt = fspecial('gaussian',15,5);
im_filt = conv2(gaussfilt,img);
figure
histogram(im_filt)

im_brain = ones(size(im_filt)) * 255;
im_brain(im_filt < 20) = 0;
im_brain(im_filt > 120) = 0;
figure
imshow(im_brain)
%% 2 Hypothesis testing
n1 = 47;
n2 = 43;
mu1 = 7;
mu2 = 11;
sigma1 = 5;
sigma2 = 4;
 
% generate two random samples taken from normal distributions with different parameters
x1 = sigma1 * randn([n1 1]) + mu1;
x2 = sigma2 * randn([n2 1]) + mu2;
 
% compute the test statistics
t_obs = (mean(x1) - mean(x2))/sqrt((std(x1)/sqrt(n1))^2 + (std(x2)/sqrt(n2))^2);
 
% compute degrees of freedom
df = floor((var(x1)/n1 + var(x2)/n2)^2/(((var(x1)^2)/(n1^2*(n1-1))) + ((var(x2)^2)/(n2^2*(n2-1)))));
 
% estimate p-value
2*(min([cdf('T',t_obs,df), 1-cdf('T',t_obs,df)]))
 
% compare the value to the Matlab ttest2 function for two sample Welch's t test
[h, p] = ttest2(x1,x2)

[hm, pm] = my_ttest2(x1, x2, 0.05)

%% 3 Multiple comparison
load("multidata.mat")

cond = d(:,1);
var1 = d(:,2);
var2 = d(:, 3);

labels = unique(cond);

P1 = NaN(length(labels));
P2 = NaN(length(labels));

for i = 1 : length(labels)
    for j = i + 1 : length(labels)

        [~, P1(i,j)] = ttest2(var1(cond == labels(i)), var1(cond == labels(j)));
        [~, P2(i,j)] = ttest2(var2(cond == labels(i)), var2(cond == labels(j)));

    end
end

alpha = 0.05;

adj_alpha = 0.05/nchoosek(length(labels), 2);

P1 < alpha
P1 < adj_alpha

P2 < alpha
P2 < adj_alpha
