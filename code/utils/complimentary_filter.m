function rpy = complimentary_filter(data)
% FFT_FILTER() uses FFT removing the noise from original data
% Written by Qiong Wang at University of Pennsylvania
% 02/28/2014

% data_   = data;
% dataFFT = fft(data_);
% meanFFT = mean(abs(dataFFT), 2);
% thresh  = 1.1 * meanFFT;
% dataFFT(bsxfun(@le, abs(dataFFT), thresh)) = 0;
% data = ifft(dataFFT);
% figure(1); plot(data_'); title('Original Data');
% figure(2); plot(data');  title('Processed Data');

acc = data.imu(1 : 3, :);
vel = data.imu(4 : 6, :);



end