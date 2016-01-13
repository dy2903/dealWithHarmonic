function drawPic (y,fs,fin,M , varargin)
		N   =  length(y);
		fsPerChannel = fs / M;
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
		% the unit of Hz		
		unit = 10^6;
		%maximize the window
		set(gcf,'outerposition',get(0,'screensize'));
		set(gca,'FontSize',18);
		% *************begin to plot********************
		plot([0:N/2-1]*fs/(N*unit),YdB(1:N/2)-F_base,'LineWidth',1 );	
		grid on;
		axis( [0  (N/2-1)*fs/N/unit -150 10]);	
		% **************mark the fin*************
		finDraw = fin/unit;
		if unit == 10^6
			text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'MHz'],'fontsize',20,'Color','r');
		else
			text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',20,'Color','r');
		end		
		% choose the xlabel
		if unit == 10^6
			xlabel ('frequency(MHz)', 'fontsize',20);
		else
			xlabel ('frequency(GHz)', 'fontsize',20);
		end
		ylabel('Power Magnitude(dB)','fontsize',20);
	hold on 
		
	% ***************to show the harmonic ************
	if nargin >= 5
		% posOfHamonicTmp = varargin{1};
		% HDTmp = varargin {2};
		posOfHamonic = (varargin{1});
		HD = (varargin {2});		
		locationHarmonic = posOfHamonic*fs/unit;
		
		for i = 2 : 5
			plot (locationHarmonic (i) , HD (i) , 'k^');
			tmp = stem(locationHarmonic (i) , HD (i) , 'k^','LineWidth',1.5);
			set(tmp, 'BaseValue', -150);
			text(locationHarmonic(i),HD(i) + 3,['H',num2str(i)],'fontname','Arial','fontsize',20);
			legend ('harmonic');
		end	
		hold on;
	end 
	% **************mark the gain Error *************
	for i = 1 : M / 2
		gainFre  =  i  * fsPerChannel + fin  ;
		if gainFre >= fs/2
			gainFre = fs - gainFre;
		end 
		stemTmp = stem( gainFre / unit , YdB ( round ((gainFre *  N ) / fs ) )- F_base + 3  ,'mo' ,'LineWidth',1.5);
		hGain = plot( gainFre / unit , YdB ( round ((gainFre *  N ) / fs ) )- F_base + 3  ,'mo' );
		set(stemTmp , 'BaseValue', -150);
		hold on ;
	end
	% **************mark the offset error *************
	for i = 1 : M / 2
		offsetFre = i * fsPerChannel; 
		if offsetFre >= fs/2
			offsetFre = fs - offsetFre ; 
		end 
		stemTemp = stem (offsetFre / unit , YdB (round (offsetFre*N/fs)) - F_base + 3 , 'r*', 'LineWidth' ,1.5);
		hOffset = plot (offsetFre / unit , YdB (round (offsetFre*N/fs)) - F_base + 3 , 'r*');
		set(stemTemp, 'BaseValue', -150);
		hold on ;
	end
	legend ([hGain,hOffset],'gain','offset');
	% ***************to show the dynamic parameters************
	if nargin >= 8		
		SINAD = (varargin{3});
		ENOB = (varargin{4});
		SFDR = (varargin{5});
		text(5/(4 * fin),-10,['SINAD=',num2str(SINAD)],'fontname','Arial','fontsize',20);
		text(5/(4 * fin),-20,['ENOB=' num2str(ENOB)],'fontname','Arial','fontsize',20);
		text(5/(4 * fin),-30,['SFDR=' num2str(SFDR)],'fontname','Arial','fontsize',20);
		axis manual
		% hold on;
		hold off;
	end
end
		
		% plot(locationHarmonic(2),HD(2),'mo',...
			% locationHarmonic(3),HD(3),'cx',...
			% locationHarmonic(4),HD(4),'r+',...
			% locationHarmonic(5),HD(5),'g*',...
			% locationHarmonic(6),HD(6),'bs',...
			% locationHarmonic(7),HD(7),'bd',...
			% locationHarmonic(8),HD(8),'kv',...
			% locationHarmonic(9),HD(9),'y^',...
			% 'LineWidth',2.5	);	
		% h=legend('1st','2nd','3rd','4th','5th','6th','7th','8th','9th');
		% set(h,'Fontsize',15);