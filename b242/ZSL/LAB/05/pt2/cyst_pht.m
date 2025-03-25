%  Create a computer model of a cyst phantom. The phantom contains
%  fiven point targets and 6, 4, 2 mm diameter waterfilled cysts
% All scatterers are situated in a box of (x,y,z)=(20,10,40) mm and the box starts 
%  30 mm from the transducer surface.
%
%  Calling: [positions, amp] = cyst_phantom (N);
%
%  Parameters:  N - Number of scatterers in the phantom
%
%  Output:      positions  - Positions of the scatterers.
%               amp        - amplitude of the scatterers.

function [positions, amp] = cyst_pht (N)

x_size = 40/1000;   %  Width of phantom [mm]
y_size = 10/1000;   %  Transverse width of phantom [mm]
z_size = 50/1000;   %  Height of phantom [mm]
z_start = 30/1000;  %  Start of phantom surface [mm];

%  Create the general scatterers
% 
x = (rand (N,1)-0.5)*x_size;
y = (rand (N,1)-0.5)*y_size;
z = rand (N,1)*z_size + z_start;

%  Generate the amplitudes with a Gaussian distribution

amp=randn(N,1);

%  Make the cyst and set the amplitudes to zero inside
r = [5 3 1]/2/1000;
xc = -5/1000;
xs = 5/1000;
zc = [10 20 30]/1000 + z_start;
zs = -[10 20 30]/1000 + z_start + z_size;

for i = 1:length(r)
    insidec = ( ((x-xc).^2 + (z-zc(i)).^2) < r(i)^2);
    insides = ( ((x-xs).^2 + (z-zs(i)).^2) < r(i)^2);

    amp(insidec) = 0;
    amp(insides) = 10*amp(insides);
end

positions=[x y z];

