% Calculate the Dynamic Parameter and draw the Spectrum
function [SINAD , ENOB , SFDR] = g_calDynamicParam (y , fs , fin , varargin )

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
	noplot=0;	
	%=====================Draw the pic =====================%	
if noplot==0
	%maximize the window
	set(gcf,'outerposition',get(0,'screensize'));
	set(gca,'FontSize',18);
	% the unit of Hz
	unit = 10^6;
	plot([0:N/2-1]*fs/(N*unit),YdB(1:N/2)-F_base,'LineWidth',1);	
	grid on;
	axis( [0  (N/2-1)*fs/N/unit -150 10]);	
	if unit == 10^6
		xlabel ('frequency(MHz)', 'fontsize',20);
	else
		xlabel ('frequency(GHz)', 'fontsize',20);
	end
	% xlabel('frequency(GHz)','fontsize',20);
    ylabel('Power Magnitude(dB)','fontsize',20);
	% ***************to show the dynamic parameters************
	finDraw = fin/unit;
	if unit == 10^6
		text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'MHz'],'fontsize',20,'Color','r');
	else
		text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',20,'Color','r');
	end
	text(5/(4 * fin),-10,['SINAD=',num2str(SINAD)],'fontname','Arial','fontsize',20);
	text(5/(4 * fin),-10,['SINAD=',num2str(SINAD)],'fontname','Arial','fontsize',20);
	text(5/(4 * fin),-20,['ENOB=' num2str(ENOB)],'fontname','Arial','fontsize',20);
	text(5/(4 * fin),-30,['SFDR=' num2str(SFDR)],'fontname','Arial','fontsize',20);
	axis manual
    hold on;
	% ***************to show the harmonic ************
		% locationHarmonic = indexHarmonList * fs / (N * 1e9) ; 	
		locationHarmonic = posOfHamonic*fs/unit;
	plot(locationHarmonic(2),HD(2),'mo',...
		locationHarmonic(3),HD(3),'cx',...
		locationHarmonic(4),HD(4),'r+',...
		locationHarmonic(5),HD(5),'g*',...
		locationHarmonic(6),HD(6),'bs',...
		locationHarmonic(7),HD(7),'bd',...
		locationHarmonic(8),HD(8),'kv',...
		locationHarmonic(9),HD(9),'y^',...
		'LineWidth',2.5	);	
		
		
    h=legend('1st','2nd','3rd','4th','5th','6th','7th','8th','9th');
    set(h,'Fontsize',15);
    hold off;
end


	% error (nargchk(3 , 4 , nargin));
	% if nargin == 4
		% indexListTemp = varargin{1};
		% indexList = (indexListTemp);
	% end
	
	% N = length (data); 
	% D_out = data;
	% %% calculation
	% D_out=D_out-mean(D_out);
	% D_out_wd=D_out(1:N)'.*blackman(N);
	% D_out_wd=D_out_wd';
	% D_out_wd_spec=fft(D_out_wd,N);
	% D_out_wd_spec(1:3)=0;
	% D_out_wd_dB=20*log10(abs(D_out_wd_spec)*2/N);

	% fund_signal_dB=max(D_out_wd_dB(1:N/2));
	% fund_signal_location=find(D_out_wd_dB(1:N/2)==fund_signal_dB);
	% range=max(round(N/500),8);
	% power_spectrum=(abs(D_out_wd_spec)).^2;

	% P_fund_signal=sum(power_spectrum(fund_signal_location-range:fund_signal_location+range));
	% harmonics_locations=zeros(1,10);
	% P_harmonics=zeros(1,10);
	% HD=zeros(1,100);

	% range_harmonics=0;
	
	% % ==============================Harmonics====================
% for num_harm=1:10
    % location=rem((num_harm*(fund_signal_location-1)+1)/N,1);
    % if location>0.5
       % location=1-location;
    % end
    % harmonics_locations(num_harm)=location;
    % harm_peak=max(power_spectrum(round(location*N)-range_harmonics:round(location*N)+range_harmonics));
    % harm_bin=find(power_spectrum(round(location*N)-range_harmonics:round(location*N)+range_harmonics)==harm_peak);
    % harm_bin=harm_bin+round(location*N)-range_harmonics-1;
    % P_harmonics(num_harm)=sum(power_spectrum(harm_bin-1:harm_bin+1));
	% HD(num_harm)=D_out_wd_dB(round(location*N))-fund_signal_dB;
    
% end    
     
	% THD=sum(P_harmonics(2:5));
	% THD_1=10*log10(P_fund_signal/THD);
	% max_harmonics_dB=max([D_out_wd_dB(1:fund_signal_location-range) D_out_wd_dB(fund_signal_location+range:N/2)]);
	% P_noise=sum(power_spectrum(1:N/2))-P_fund_signal-THD;

	% SNR=10*log10(P_fund_signal/P_noise);
	% SINAD=10*log10(P_fund_signal/(P_noise+THD));
	% ENOB=(SINAD-1.76)/6.02;
	% SFDR=fund_signal_dB-max_harmonics_dB;
	% set(gcf,'outerposition',get(0,'screensize'));
	% set(gca,'FontSize',18);
	% plot([0:N/2-1]*fs/(N*10^9),D_out_wd_dB(1:N/2)-fund_signal_dB,'LineWidth',1);	
	% grid on;

	% axis( [0  (N/2-1)*fs/N/10^9 -100 10]);	

	% xlabel('frequency(GHz)','fontsize',20);
    % ylabel('Amplitude(dB)','fontsize',20);

	% % =========================Mark the Figure====================
	% finDraw = fin/10^9;

	% text((fin - 2.5*10^9) / 10^9 ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',20,'Color','r');
	% text(5/(4 * fin),-10,['SINAD=',num2str(SINAD)],'fontsize',20);
	% text(5/(4 * fin),-20,['ENOB=' num2str(ENOB)],'fontsize',20);
	% text(5/(4 * fin),-30,['SFDR=' num2str(SFDR)],'fontsize',20);
	% axis manual
    % hold on;
	
	% % ========================Harmonics================================
	% plot(harmonics_locations(2)*fs/10^9,HD(2),'mo',harmonics_locations(3)*fs/10^9,HD(3),'cx',harmonics_locations(4)*fs/10^9,HD(4),'r+',harmonics_locations(5)*fs/10^9,HD(5),'g*',...
    % harmonics_locations(6)*fs/10^9,HD(6),'bs',harmonics_locations(7)*fs/10^9,HD(7),'bd',harmonics_locations(8)*fs/10^9,HD(8),'kv',harmonics_locations(9)*fs/10^9,HD(9),'y^', 'LineWidth',2.5);
    % h=legend('1st','2nd','3rd','4th','5th','6th','7th','8th','9th');
    % set(h,'Fontsize',15);
    % hold on;
	% %===================Find the max index , frequency in range of 200MHz,and Mark====================	
	% % the OverLoad of Function
	% if nargin == 3
		% [spectrumMaxList , spectrumMaxFreq  , spectrumMaxIndex] = h_localMax (data , fs);
		% for i = 1 : length (spectrumMaxFreq)
			% if spectrumMaxFreq (i)  >= fs / 2
				% spectrumMaxFreq (i) = fs - spectrumMaxFreq (i);
			% end
		% end
		% plot (spectrumMaxFreq / 1e9 , spectrumMaxList , 'gs');
	% end 
	
	% if nargin == 4
		% [maxListByIndexBefore , freqListByIndexBefore , indexListByIndexBefore] = h_getMaxByIndex (data , fs ,indexList);
		% for i = 1 : length (freqListByIndexBefore)
			% if freqListByIndexBefore (i)  >= fs / 2
				% freqListByIndexBefore (i) = fs - freqListByIndexBefore (i);
			% end
		% end
		% plot (freqListByIndexBefore / 1e9 , maxListByIndexBefore , 'gs');
	% end

	% h=legend('1st','2nd','3rd','4th','5th','6th','7th','8th','9th' , 'LocalMax');
    % set(h,'Fontsize',15);
    % hold off;	
	
	
% end