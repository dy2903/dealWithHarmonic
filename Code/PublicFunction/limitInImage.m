function [data] = limitInImage (dataSource,fs)
	for i = 1 : length (dataSource)
		if (dataSource(i) >= fs/2) & (dataSource(i) < fs )
			dataSource(i)  =  fs / 2 - dataSource(i);
		end
		if dataSource(i) >= fs 
			dataSource(i) = fs - dataSource(i);
		end 
		if dataSource(i) < 0 
			dataSource(i) = fs + dataSource(i);
		end 
	end
	data = dataSource;
end

