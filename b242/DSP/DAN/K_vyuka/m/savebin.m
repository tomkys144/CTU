function savebin(filename,x);

%Function SAVEBIN: Saving vector as INTEGER binary data file.
%
%Usage: savebin(filename,x);
%  filename  - desired name of binary data file 
%  x         - vector with data to saving
%


%                       Made by PP
%                      28 March 1995
%                    CTU FEL,  Prague  

if nargin>2,
  disp('ERROR: Too many parameters of loadbin !');
  return;
end;

MAXINT=32768 ;

y=x';
x=y(:);

len=length(x);

%  File opening
%%%%%%%%%%%%%%%

F=fopen(filename,'wb');
if F==-1, 
  disp('Error: Signal file was not open !');  
  return; 
end; 


%  Writing of signal samples to BIN-file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxval=max(abs(x));

if  maxval>1,
  disp('Warning: Data exceeded range <-1, 1> !');
end;

x=floor(x.*MAXINT);
count=fwrite(F,x,'short'); 

if ~(count==len), 
  disp('Error: Data was not successfully written!Output may be distorted! ');
  return;
end;

bits=ceil(log(max(x))/log(2));
if bits<8,
  disp(sprintf('WARNING: Maximal value was written only into %.0f bits!',bits));
else
  disp(sprintf('Maximal value was written into %.0f bits.',bits));
end; 


%  File closing end exit
%%%%%%%%%%%%%%%%%%%%%%%%

fclose(F);

disp(sprintf('%.0fx2 bytes were successfully written into %s file.',len,filename));
