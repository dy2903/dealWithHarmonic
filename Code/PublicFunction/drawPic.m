function drawPic (y,fs,fin,M , varargin)
		% the unit of Hz		
		unit = 10^6;
		% the fontsize
		fontSize = 13.125;
		orderToShow = 3;
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
		% *************begin to plot, 1 ~fs/2********************
		plot([0:N/2-1]*fs/(N*unit),YdB(1:N/2)-F_base,'Color', [0 0 0.54] , 'LineWidth',2 );	
		grid on;
		axis( [-1  (N/2-1)*fs/N/unit -140 10]);	
		% **************mark the fin*************
		finDraw = fin/unit;
		if unit == 10^6
			text((fin) / unit + 2 ,-50,['fin=',num2str(finDraw),'MHz'],'fontsize',fontSize,'Color','r');
		else
			text((fin) / unit + 2  ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',fontSize,'Color','r');
		end	
		% choose the xlabel
		if unit == 10^6
			xlabel ('Frequency(MHz)', 'fontsize',fontSize);
		else
			xlabel ('Frequency(GHz)', 'fontsize',fontSize);
		end
		ylabel('Power Magnitude(dB)','fontsize',fontSize);
		hold on 
	
		% ***************to show the dynamic parameters************
	if nargin >= 8		
		SINAD = (varargin{3});
		ENOB = (varargin{4});
		SFDR = (varargin{5});
		dynamicArrays = strcat ({'SINAD=','ENOB=','SFDR='},{num2str(SINAD),num2str(ENOB),num2str(SFDR)});
		for i = 1 : length (dynamicArrays)
			text(fin/unit , -10*i , dynamicArrays(i));
		end	
		% axis manual
		hold on;
	end
		
	% % ***************to show the harmonic ************
	% if nargin >= 5
		% posOfHamonic = (varargin{1});
		% HD = (varargin {2});		
		% locationHarmonic = posOfHamonic*fs/unit;
		% for i = 2 : orderToShow 
			% plot (locationHarmonic (i) , HD (i) , 'k^');
			% text(locationHarmonic(i),HD(i) + 3,['H',num2str(i)],'fontname','Arial','fontsize',fontSize);
			% legend ('harmonic');
		% end	
		% hold on;
	% end 
	
	
	% =========================mark the gain and offset===============
	% m = [1 : M ];
	% gainPositive = m*fsPerChannel + fin;
	% gainNeg = m*fsPerChannel - fin;
	% offsetFre = m*fsPerChannel ; 
	% gainPositive = limitInImage (gainPositive,fs);
	% gainNeg = limitInImage (gainNeg, fs);
	% offsetFre = limitInImage (offsetFre,fs);
	% gainFre = [gainPositive , gainNeg];
	% hGain = plot( gainFre/ unit , YdB ( round ((gainFre *  N ) / fs ) + 1  )- F_base + 3  ,'mo' );
	% hOffset  = plot( offsetFre/ unit , YdB ( round ((offsetFre *  N ) / fs ) + 1  )- F_base + 3  ,'r*' );
	% legend ([hGain,hOffset] , 'gainError/timeError','offsetError');
	
	
		% ======================mark order==================
		order0 = [0 , fsPerChannel , 2*fsPerChannel];
		order1 = [fin , fsPerChannel - fin , fsPerChannel + fin , 2*fsPerChannel - fin];
		order2 = [2*fin , fsPerChannel - 2*fin , fsPerChannel + 2*fin , 2*fsPerChannel - 2*fin , fsPerChannel , 2*fsPerChannel];
		order3 = [3*fin , fsPerChannel - 3*fin , fsPerChannel + 3*fin , 2*fsPerChannel - 3*fin , fsPerChannel - fin , fsPerChannel + fin , 2*fsPerChannel - fin ];
		h0 = plot (order0/unit , YdB (round (order0*N/fs) + 1) - F_base , 'mo');
		h1 = plot (order1/unit , YdB (round (order1*N/fs) + 1) - F_base , 'k^');
		h2 = plot (order2/unit , YdB (round (order2*N/fs) + 1) - F_base+ 2.5  , 'rd');
		h3 = plot (order3/unit , YdB (round (order3*N/fs) + 1) - F_base + 2.5, 'gs');
		legend([h0 , h1 , h2 , h3 ],'0st','1st','2nd','3rd');
		
		% ==============save the figure ================
		% set(gcf,'outerposition',get(0,'screensize'));
		set(gcf,'unit','centimeters','position',[3,5,15.0283 ,9.5 ]);
		set(gca,'Position',[.15,.15,.8,.75]);
		set(get(gca,'XLabel'),'FontSize',fontSize);
		set(gcf,'color','white','paperpositionmode','auto');
		fileName =['../../Figure/' ,'modelWithError'];
		% saveas  (gcf , [fileName , '.eps'],'psc2');
		saveas  (gcf , fileName, 'fig');
end % the end of function ; 
		
