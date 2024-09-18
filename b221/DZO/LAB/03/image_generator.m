function [I] = image_generator(sig_type, imsize, varargin)
%IMAGE_GENERATOR - generates 2d signals
%
% [I] = image_generator(sig_type, params)
%   
%   sig_type - string {'constant','harmonic','square','circ','Gaussian','Gabor'}
%   params - list of parameters depending on signal type    
%       'constant':  a (dc component)
%       'harmonic':  u,v,phi (horizontal and vertical frequency in range 0..pi, pi is the Nyquist frequency, phase 0..pi)
%       'square':  s (half-side of the square in pixels)
%       'circ':    r (radius of the circle in pixels)
%       'Gaussian': sigma (standard deviation in pixels)
%       'Gabor': u0,v0,sigma (normalized horizontal,vertical frequency 0..pi, standard deviation)
%
% Example: 
%   I = image_genrator('Gaussian',[512,512],20);
%

I = zeros(imsize); %init (in case something is not implemented)

center = imsize/2;
if ~mod(imsize,2)
    center = center + 0.5;
end
switch sig_type
    case 'constant'  %a
        a = varargin{1};
        I(:) = a;
    case 'harmonic'  %u, v
        u = varargin{1}; v = varargin{2}; phi = varargin{3};
        for i=1:imsize(1)
            for j=1:imsize(2)
                I(i,j) = cos(u*j + v*i + phi);
            end
        end
    case 'square'    %s
        s = varargin{1};

        I(center - s - 0.5 : center + s + 0.5, center - s - 0.5 : center + s + 0.5) = 1;
    case 'circ'      %r
        r = varargin{1};
        for i=1:imsize(1)
            for j=1:imsize(2)
                rij = sqrt((i-center(1))^2+(j-center(2))^2);
                if rij <= r
                    I(i,j) = 1;
                end
            end
        end
    case 'Gaussian'  %sigma
        sigma = varargin{1};
        for i=1:imsize(1)
            for j=1:imsize(2)
                I(i,j) = exp(-(((i-center(1))^2)/(2*sigma^2) + ((j-center(2))^2)/(2*sigma^2)));
            end
        end
    case 'Gabor'     %u0,v0,sigma  (OPTIONAL)
        u0 = varargin{1}; v0 = varargin{2}; sigma = varargin{3};
        for i=1:imsize(1)
            for j=1:imsize(2)
                I(i,j) = cos(u0*i + v0*j)*exp(-(((i-center(1))^2)/(2*sigma^2) + ((j-center(2))^2)/(2*sigma^2)));
            end
        end
    otherwise
        error('Unknown signal type.')
end



