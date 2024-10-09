function [dominatingFrequency, AutoCorrNum_periods, ZCCenteredcount] = extractFeatures(measurement)
    if nargin < 2
        figureNumber = 0;
    end
    
    Fs = 1/0.05;
    
    N = length(measurement);
    t = 1:N;

    halfway = floor(N/2) + 1;
    Y = fft(measurement);
    P2 = abs(Y/N); % Two-sided spectrum
    P1 = P2(1:halfway); %N/2+1); % Single-sided spectrum
    P1(2:end-1) = 2*P1(2:end-1); % Adjust amplitude
    
    % Frequency vector
    f = Fs*(0:(N/2))/N;
    
    % Find the dominating frequency
    [~, maxIndex] = max(P1);
    dominatingFrequency = f(maxIndex);

    centeredMeasurement = measurement - mean(measurement);
    [ZCRate, ZCcount] = zerocrossrate(measurement); 
    [ZCCenteredRate,ZCCenteredcount] = zerocrossrate(centeredMeasurement);

    [autocorrelation, lag] = xcorr(measurement, 'coeff');
    [autoCorrPeaks,autoCorrlocs] = findpeaks(autocorrelation, 'MinPeakDistance',floor(N/100)); % 1% ?
    
    autoCorrPeaksKeept = []; %autoCorrPeaks(autoCorrPeaks> 0.01);
    autoCorrlocsKeept = [];
    for peakIdx = 1:length(autoCorrPeaks)
        if autoCorrPeaks(peakIdx) > 0.01
            autoCorrPeaksKeept = [autoCorrPeaksKeept; autoCorrPeaks(peakIdx)];
            autoCorrlocsKeept = [autoCorrlocsKeept; autoCorrlocs(peakIdx)];
        end
    end

    AutoCorravg_peak_distance = mean(diff(autoCorrlocsKeept));
    if AutoCorravg_peak_distance > 0
        AutoCorrNum_periods = length(autoCorrlocsKeept); %round(length(measurement) / AutoCorravg_peak_distance);
        
    else
        AutoCorrNum_periods = 0;
    end

    [peaks,locs] = findpeaks(measurement, 'MinPeakDistance',floor(N/100));
    avg_peak_distance = mean(diff(locs));
    if avg_peak_distance > 0
        num_periods = round(length(measurement) / avg_peak_distance);

    else
        num_periods = 0;
    end


    %NumZeroCrossings = sum(diff(sign(measurement)) ~= 0);
    %NumZeroCrossingsCentered = sum(diff(sign(centered_angles)) ~= 0);

    if figureNumber > 0
        figure(figureNumber)
        subplot(4,1,1);
        plot(t, measurement);
        hold on
        plot(t,centeredMeasurement);
        legend('measured', 'centered measurement')
        title(['Signal: ', measurementName, ' with zeroCrossings ', num2str(ZCcount), ' and rate ', num2str(ZCRate) ]);
        xlabel('Time (s)');
        ylabel('Amplitude');

        subplot(4,1,2)
        plot(t, measurement);
        hold on
        plot(t(locs), peaks, 'ro', 'DisplayName', 'Detected Peaks');
        title(['Autocorrelation with num periods: ', num2str(num_periods) ]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        legend('measured', 'peaks')

        subplot(4,1,3);
        % plot(t, centeredMeasurement);
        % title(['Signal: ', measurementName, 'centered around zero,  with zeroCrossings ', num2str(ZCCenteredcount), ' and rate ', num2str(ZCCenteredRate)]);
        % xlabel('Time (s)');
        % ylabel('Amplitude');
        plot(lag,autocorrelation);
        hold on
        plot(lag(autoCorrlocs), autoCorrPeaks, 'ro', 'DisplayName', 'Detected Peaks');
        hold on
        plot(lag(autoCorrlocsKeept), autoCorrPeaksKeept, 'go', 'DisplayName', 'vaild Peaks');
        title(['Autocorrelation with num periods: ', num2str(AutoCorrNum_periods) ]);
        xlabel('Lag');
        ylabel('Autocorrelation');
        legend('autocorrelation', 'all peaks', 'peaks > 0.1')
         
    
    
        % Plot the FFT result (Y)
        subplot(4,1,4);
        plot(f, abs(Y(1:halfway))/N);
        title(['FFT Result (Y) (Dominating Frequency: ', num2str(dominatingFrequency), ' Hz)']);
        xlabel('Frequency (f)');
        ylabel('|Y(f)|');
        set(gcf,'position',[1000 200 800 1200])
    end

end

% function anglesFeatures = extractFeaturesFromAngles(angles)
%     clear anlge
%     [lengthOfPath, numAnglesMetrics] = size(angles);
%     numFeatures = 3;
%     features = zeros(numAnglesMetrics, numFeatures);
% 
%     for angIndex = 1:numAnglesMetrics
%         currentMetric  = angles(:,angIndex);
%         dominantFrequency =  extractDominatFrequency(currentMetric,angIndex);
%         %phase = angle(currentMetric)
%         %metricRMS = rms(currentMetric);
%         centered_angles = currentMetric - mean(currentMetric);
%         %zero_crossing_rate = sum(abs(diff(centered_angles > 0)));
%         NumZeroCrossings = sum(diff(sign(currentMetric)) ~= 0);
%         NumZeroCrossingsCentered = sum(diff(sign(centered_angles)) ~= 0);
%         [dominantFrequency, NumZeroCrossings NumZeroCrossingsCentered]
% 
%         %spectral_centroid = mean((1:length(Y)).*Y)/sum(Y)
%         features(angIndex,: ) = [dominantFrequency, NumZeroCrossings NumZeroCrossingsCentered];
%     end
%     features = features';
%     anglesFeatures = features(:)';
% 
% 
% end


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
