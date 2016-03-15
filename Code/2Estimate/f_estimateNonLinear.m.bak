
% Estimate Timing
function [ nonLinearParams ]  = f_estimateNonLinear(data, fin,order, NumChannel,fs_adc)
	testSampPoint = length (data); 
	N             = testSampPoint;
    Ts            = 1/fs_adc;
    fsPerChannel  = fs_adc/NumChannel;
	M             = NumChannel;
% # ********************* % Estimate NonLinear***********
    dataWithWindow     =  data  .*  hanning(testSampPoint)';
    dataAfterFFT       =  fft  (dataWithWindow);
    decimationInFre  =  zeros(order,NumChannel);
	YdB        =   20*log10(abs(dataAfterFFT)*2/N);%
% # ************ get the point with misError************
	t_m = zeros(order+1 , NumChannel);
	t_mTmp = zeros (order + 1 , NumChannel );
	decimaFre = zeros (order + 1 , M);
	for l = 1 : order + 1
		for m = 1 : M
			decimaFre(l , m)= -(l - 1) * fin + ( m - 1) * fs_adc / M ;
			if decimaFre(l , m) <  0 
				fre2Point = (N / fs_adc) * (decimaFre(l , m) + fs_adc);
				t_m (l , m) = dataAfterFFT (fix(fre2Point) + 1);
				t_mTmp (l , m) = YdB(fix(fre2Point) + 1);
			else
				fre2Point = (N / fs_adc) * (decimaFre(l , m));
				t_m (l , m) = dataAfterFFT (fix(fre2Point) + 1);
				t_mTmp (l , m) = YdB(fix(fre2Point) + 1);
			end
		end
	end
	save('../../Data/decimaFre.mat','decimaFre' );
	% unit = 1e6;
	% decimaFre = decimaFre / unit;
	
	% *************** get the s_m ****************
	s_m = zeros (order+1 , M);
	s_m( order + 1  , :) = t_m (order + 1 , :);
	s_m (order  , : ) = t_m (order , :);
	s_m (2 , :) = t_m (2 , :) + 3 * t_m (4 , :);
	s_m ( 1 , :) = t_m (1 , :) + 2 * t_m (3 , :);
	
	s_addParam = zeros (order + 1, M);
	% for l = 1 : order + 1
		% s_addParam (l , :) = s_m(l , :) * (M * Ts * 2^(l - 1)) / pi;
	% end
	s_addParam = s_m  ; 
	%s_addParam = s_m * Ts / 2/pi ; 
	C_estim = zeros (order+1 , M);
	% C_estim = ifft (s_addParam , M);
	% C_estim = (ifft (s_addParam' , M))';
	for i = 1 : order + 1
		C_estim (i , :) = ifft (s_addParam (i , :) , M);
	end
	C_estim = abs (C_estim);
	% nonLinearParams = abs (C_estim);
	
% ================for Test ****************	
	load ('../../Data/Parameter.mat' );
	ratio = C_estim ./ nonLineError; 
	% ratioMean = (mean (ratio'))';
	ratioTrans = ratio';
	ratioMean = mean (ratioTrans);	
	ratioTmp = ratioMean' * ones (1 , order + 1);
	
	
	
	nonLinearParams = C_estim ./ ratioTmp;
	
	% nonLinearTmp = reshape (nonLinearParams , 1 , []);
	residualErrors =  abs (nonLinearParams - nonLineError) ./ nonLineError;
	meanResidual = mean (reshape (residualErrors , 1 , []));
	
   
end














    % for i = 1:NumChannel
        % if (fin + (i-1)*fsPerChannel <=  fs_adc)
             % decimationInFre(i) =  dataAfterFFT(fix((i-1)*testSampPoint/NumChannel+fin*testSampPoint/fs_adc+1));
        % else
            % decimationInFre(i)  =  dataAfterFFT(fix((i-1)*testSampPoint/NumChannel+fin*testSampPoint/fs_adc+1-testSampPoint));
        % end
    % end
    % decimationInFre = decimationInFre*Ts/2/pi;
	 % % # ********************* IFFT**************#########
    % A_time_domain = ifft(decimationInFre,NumChannel);
    % % # *********************get the angle **************#########
    % pha         =  zeros(1,NumChannel);
    % for   i     = 1:NumChannel
        % pha(i)  =  angle (A_time_domain(i));
    % end
      % for i      = 2:NumChannel
        % pha(i)  =   pha(i) - pha(1);
      % end
     % pha(1)  =  0;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % # *********** result *********** 
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 % nonLinear = pha*fs_adc/fin/2/pi ;