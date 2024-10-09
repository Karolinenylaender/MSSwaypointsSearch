function [numPeaks, validPeaks] = CalculateNumberOfPeaks(measurement)
    neighborhoodSize = floor(length(measurement)/100);
    threshold = 0.01;

    [autocorrelation, ~] = xcorr(measurement, 'coeff');
    [peaks,~] = findpeaks(autocorrelation, 'MinPeakDistance',neighborhoodSize);
    
    validPeaks = peaks(peaks > threshold);
    numPeaks = length(validPeaks);

   
end