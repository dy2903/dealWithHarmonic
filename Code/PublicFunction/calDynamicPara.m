
function [posOfHamonic ,HD ,  SINAD , ENOB , SFDR]= calDynamicPara(y,fs,fin)

	N   =  length(y);
	y   =  y - mean(y);
	% add window
	yWithWindow=  y(1:N)'.*blackman(N);
	yWithWindow=  yWithWindow';
	% ================get the frequency domain information
	Y          =   fft(yWithWindow,N);
	Y(1:3)     =   0;
	YdB        =   20*log10(abs(Y)*2/N);%
	%=====================the fundamental frequency =====================%	
	F_base     = max(YdB(1:N/2));
	posOfBase = find(YdB(1:N/2) == F_base);
	% rangeToInclude=max(round(N/500),8);	
	% =============power specturm============
	rangeToInclude = 7;
	powerSpectrum=(abs(Y)).^2;
	powerOfBase=sum(powerSpectrum(posOfBase - rangeToInclude : posOfBase + rangeToInclude));
	%=====================init=====================%	
	posOfHamonic=zeros(1,100);
	P_harmonics=zeros(1,100);
	HD=zeros(1,100);
	rangeOfHarmon=0;
%% %==================get the harmonic Position and Power=====================%
for orderOfHarmon=1:50
	% posOfBase-1:matlab begins with 1
    posTemp=rem((orderOfHarmon*(posOfBase-1)+1)/N,1);
	% to fold
    if posTemp>0.5
       posTemp=1-posTemp;
    end
    posOfHamonic(orderOfHarmon)=posTemp;
    ampOfHamonic=max(powerSpectrum(round(posTemp*N)-rangeOfHarmon:round(posTemp*N)+rangeOfHarmon));
	
    realPosOfHarmonic=find(powerSpectrum(round(posTemp*N)-rangeOfHarmon:round(posTemp*N)+rangeOfHarmon)==ampOfHamonic);
	
    realPosOfHarmonic=realPosOfHarmonic+round(posTemp*N)-rangeOfHarmon-1;
	% the power of special order of harmonic
    P_harmonics(orderOfHarmon)=sum(powerSpectrum(realPosOfHarmonic-1:realPosOfHarmonic+1));
	HD(orderOfHarmon)=YdB(round(posTemp*N))-F_base;
end         
	THD=sum(P_harmonics(2:100));
	THD_1=10*log10(powerOfBase/THD);%harmonic distortion
	max_harmonics_dB=max([YdB(1:posOfBase-rangeToInclude) YdB(posOfBase+rangeToInclude:N/2)]);
	P_noise=sum(powerSpectrum(1:N/2))-powerOfBase-THD;
	%************Dynamic Parameters*********
	SNR=10*log10(powerOfBase/P_noise);
	SINAD=10*log10(powerOfBase/(P_noise+THD));
	ENOB=(SINAD-1.76)/6.02;
	SFDR=F_base-max_harmonics_dB;
end




