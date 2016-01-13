function drawPic (y,fs,fin,M , varargin)
		% the unit of Hz		
		unit = 10^6;
		% the fontsize
		fontSize = 10.5;
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
		%maximize the window
		% set(gcf,'outerposition',get(0,'screensize'));
		width=462;%宽度，像素数
		height=300;%高度
		left=200;%距屏幕左下角水平距离
		bottem=100;%距屏幕左下角垂直距离
		set(gcf,'position',[left,bottem,width,height])
		set(gca,'FontSize',fontSize);
		% *************begin to plot********************
		plot([0:N/2-1]*fs/(N*unit),YdB(1:N/2)-F_base,'Color', [0 0 0.54] , 'LineWidth',2 );	
		grid on;
		axis( [-1  (N/2-1)*fs/N/unit -150 10]);	
		% **************mark the fin*************
		finDraw = fin/unit;
		if unit == 10^6
			text((fin) / unit + 2 ,-50,['fin=',num2str(finDraw),'MHz'],'fontsize',fontSize,'Color','r');
			% text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'MHz'],'fontsize',fontSize,'Color','r');
		else
			text((fin) / unit + 2  ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',fontSize,'Color','r');
			% text((fin - 2.5*unit) / unit ,-50,['fin=',num2str(finDraw),'GHz'],'fontsize',fontSize,'Color','r');
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
		text(fin/unit,-10,['SINAD=',num2str(SINAD)],'fontname','Arial','fontsize',fontSize);
		text(fin/unit,-20 ,['ENOB=' num2str(ENOB)],'fontname','Arial','fontsize',fontSize);
		text(fin/unit,-30,['SFDR=' num2str(SFDR)],'fontname','Arial','fontsize',fontSize);
		axis manual
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
	
	
	% % **************mark the gain Error *************
	% for i = 1 : M / 2
		% gainFre  =  i  * fsPerChannel + fin  ;
		% if gainFre >= fs/2
			% gainFre = fs - gainFre;
		% end 
		% hGain = plot( gainFre / unit , YdB ( round ((gainFre *  N ) / fs ) )- F_base + 3  ,'mo' );
		% hold on ;
	% end
	% % **************mark the offset error *************
	% for i = 1 : M / 2
		% offsetFre = i * fsPerChannel; 
		% if offsetFre >= fs/2
			% offsetFre = fs - offsetFre ; 
		% end 
		% hOffset = plot (offsetFre / unit , YdB (round (offsetFre*N/fs)) - F_base + 3 , 'r*');
		% hold on ;
	% end
	% legend ([hGain,hOffset],'gain','offset');

	
		% ======================mark order==================
		order0 = [0 , fsPerChannel , 2*fsPerChannel];
		for i = 1 : length(order0)
			h0 = plot (order0(i)/unit , YdB (round (order0(i) * N / fs) + 1 ) - F_base , 'mo');
		end
		order1 = [fin , fsPerChannel - fin , fsPerChannel + fin , 2*fsPerChannel - fin];
		h1 = plot (order1/unit , YdB (round (order1*N/fs) + 1) - F_base , 'k^');
		order2 = [2*fin , fsPerChannel - 2*fin , fsPerChannel + 2*fin , 2*fsPerChannel - 2*fin , fsPerChannel , 2*fsPerChannel];
		h2 = plot (order2/unit , YdB (round (order2*N/fs) + 1) - F_base+ 1.5  , 'rd');
		order3 = [3*fin , fsPerChannel - 3*fin , fsPerChannel + 3*fin , 2*fsPerChannel - 3*fin , fsPerChannel - fin , fsPerChannel + fin , 2*fsPerChannel - fin ];
	
		h3 = plot (order3/unit , YdB (round (order3*N/fs) + 1) - F_base + 1.5, 'gs');
	
		legend([h0 , h1 , h2 , h3 ],'0st','1st','2nd','3rd');
end % the end of function ; 
		
		
		
		
		
		
		
		
		
		
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
		
	% if   2 == exist ('../../Data/decimaFre.mat' , 'file')
		% load ('../../Data/decimaFre.mat');			
		% [row , col] = size (decimaFre);
		% for r = 1 : row
			% for c = 1 : col
				% if (decimaFre (r,c) >= fs/2) & (decimaFre (r,c) < fs )
					% decimaFre (r,c)  =  fs / 2 - decimaFre (r,c);
				% end
				% if decimaFre (r,c) >= fs 
					% decimaFre (r,c) = fs - decimaFre (r,c);
				% end 
				% if decimaFre (r,c) < 0 
					% decimaFre (r,c) = fs + decimaFre (r,c);
				% end 
				% if r == 1 
					% plot (decimaFre (r,c)/unit , YdB (round (decimaFre (r,c)*N/fs) + 1) - F_base + 3 , 'mo');
				% end
				% if r == 2 
					% plot (decimaFre (r,c)/unit , YdB (round (decimaFre (r,c)*N/fs)+ 1) - F_base + 3 , 'cx');
				% end				
				% if r == 3 
					% plot (decimaFre (r,c)/unit , YdB (round (decimaFre (r,c)*N/fs)+ 1) - F_base + 3 , 'r+');
				% end				
				% if r == 4 
					% plot (decimaFre (r,c)/unit , YdB (round (decimaFre (r,c)*N/fs)+ 1) - F_base + 3 , 'g*');
				% end				
			% end 
		% end
		
		
		% plot ( (fsPerChannel + 2*fin ) , YdB (round ((fsPerChannel + 2*fin )*N/fs)+ 1) - F_base + 3 , 'r+') ;
		
		% plot ( (fsPerChannel + 3*fin ) , YdB (round ((fsPerChannel + 3*fin )*N/fs)+ 1)- F_base + 3 , 'g*') ;
	
	
	% end	
		