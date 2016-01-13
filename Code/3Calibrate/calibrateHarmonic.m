
% Estimate Timing
function  [SINAD , ENOB , SFDR] = calibrateHarmonic(data, fin,order, NumChannel,fs_adc , C_estimate)
	testSampPoint = length (data); 
	N             = testSampPoint;
    Ts            = 1/fs_adc;
	fs = fs_adc;
    fsPerChannel  = fs_adc/NumChannel;
	M             = NumChannel;
	y = data;
	
	% -------------------- F_l -------------------------
	F_l = zeros (order + 1 , N );
	for l = 1 : order + 1
		for i = 1 : N 
			F_l (l , i) = C_estimate(l , (mod ((i - 1) , M ) ) +  1 );
		end 
	end
	F_l(2 , :) = F_l (2 , :) - ones (1 , N);
    
    	 path(path,'F:\1TheisProject\WithHarmonic\dealWithHarmonic\PublicFunction');

	% --------------------stage 1 -------------------------
	y0 = y - F_l (1 , :) ;
	figNum = 1;
	figure (figNum);
	[posOfHarmonic ,HD, SINAD , ENOB , SFDR] = calDynamicPara (y0 , fs , fin  );
	 drawPic (y0,fs,fin,M , posOfHarmonic , HD,SINAD, ENOB, SFDR);
	
	% --------------------stage 2 -------------------------
	y01 = 1 ./ (F_l (2 , :) + 1 ) .* y0 ; 
	figNum = figNum + 1;
	figure (figNum);
	[posOfHarmonic ,HD, SINAD , ENOB , SFDR] = calDynamicPara (y01 , fs , fin  );
	 drawPic (y01,fs,fin,M , posOfHarmonic , HD,SINAD, ENOB, SFDR);
	
	% --------------------stage 3 -------------------------
	 y012 = y01 - (y01).^2 .* (F_l (3 , :) ./ (1 + F_l( 2 , :)));
	figNum = figNum + 1; 
	figure (figNum);
	 [posOfHarmonic ,HD, SINAD , ENOB , SFDR] = calDynamicPara (y012 , fs , fin  );
	drawPic (y012,fs,fin,M , posOfHarmonic , HD,SINAD, ENOB, SFDR);

	% --------------------stage 4 -------------------------
	e3 = (F_l (4 , :) ./ (1 + F_l(2 , :)) - 2 * (F_l(3 , :) ./ (F_l(2 , :) + 1)).^2) .* (y01).^2 .* y012;
	y0123 = y012 - e3;
	figNum = figNum + 1; 
	figure (figNum);
	 [posOfHarmonic ,HD, SINAD , ENOB , SFDR] = calDynamicPara (y0123 , fs , fin  );
	drawPic (y0123,fs,fin,M , posOfHarmonic , HD,SINAD, ENOB, SFDR);

