function anglesFeatures = extractFeaturesFromAngles(angles)
    clear anlge
    [lengthOfPath, numAnglesMetrics] = size(angles);
    numFeatures = 1;
    features = zeros(numAnglesMetrics, numFeatures);
    signalNames = ['phi', 'theta', 'psi', 'u', 'v', 'w', 'p', 'q', 'r'];

    for angIndex = 1:numAnglesMetrics
        currentMetric  = angles(:,angIndex);
        % dominantFrequency =  extractDominatFrequency(currentMetric,angIndex);
        % %phase = angle(currentMetric)
        % %metricRMS = rms(currentMetric);
        % centered_angles = currentMetric - mean(currentMetric);
        % %zero_crossing_rate = sum(abs(diff(centered_angles > 0)));
        % NumZeroCrossings = sum(diff(sign(currentMetric)) ~= 0);
        % NumZeroCrossingsCentered = sum(diff(sign(centered_angles)) ~= 0);
        % [dominantFrequency, NumZeroCrossings NumZeroCrossingsCentered]

        %spectral_centroid = mean((1:length(Y)).*Y)/sum(Y)
        %[dominatingFrequency, ZCcount, ZCCenteredcount] = extractFeatures(currentMetric, signalNames(angIndex), angIndex);
      
        [dominatingFrequency, numPeriods, zeroCrosscount]= extractFeatures(currentMetric, signalNames(angIndex), -1);
        %features(angIndex,: ) =extractFeatures(currentMetric, signalNames(angIndex), -1);
        %features(angIndex,: ) =[dominatingFrequency, ZCcount, ZCCenteredcount];
        features(angIndex,: ) =numPeriods;
    end
    features;
    features = features';
    anglesFeatures = features(:)';

   

    
end


% function dominating_frequency =  extractDominatFrequency(measurement,angIndex)
%     if nargin < 2
%         angIndex = 1;
%     end
%     signalNames = ["phi", "theta", "psi", "u", "v", "w", "p", "q", "r"];
% 
%     Fs = 1;
% 
% 
%     N = length(measurement);
%     t = 1:N;
%     halfway = floor(N/2) + 1;
%     Y = fft(measurement);
%     P2 = abs(Y/N); % Two-sided spectrum
%     P1 = P2(1:halfway); %N/2+1); % Single-sided spectrum
%     P1(2:end-1) = 2*P1(2:end-1); % Adjust amplitude
% 
%     % Frequency vector
%     f = Fs*(0:(N/2))/N;
% 
%     % Find the dominating frequency
%     [~, maxIndex] = max(P1);
%     dominating_frequency = f(maxIndex);
% 
%     % figure(angIndex+10)
%     % subplot(3,1,1);
%     % plot(t, measurement);
%     % title(['Signal: ', signalNames(angIndex)]);
%     % xlabel('Time (s)');
%     % ylabel('Amplitude');
%     % 
%     % % Plot the FFT result with dominating frequency in title
%     % subplot(3,1,2);
%     % plot(f, P1);
%     % title(['Single-Sided Amplitude Spectrum (Dominating Frequency: ', num2str(dominating_frequency), ' Hz)']);
%     % xlabel('Frequency (f)');
%     % ylabel('|P1(f)|');
%     % 
%     % % Plot the FFT result (Y)
%     % subplot(3,1,3);
%     % plot(f, abs(Y(1:halfway))/N);
%     % title('FFT Result (Y)');
%     % xlabel('Frequency (f)');
%     % ylabel('|Y(f)|');
% end