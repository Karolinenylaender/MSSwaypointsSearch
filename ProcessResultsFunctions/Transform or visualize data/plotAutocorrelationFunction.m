%% plot autocorrelationfunction
close all
clear all

ship = "remus100"
searchProcess = "HalfHalfMutation"


%[straightPath,straightAngles, straightWpt] = extractPathAndWaypoints(23, ship, searchProcess, 1, 1);
%[subpath,subpathAxis, autocorrSubpath, autocorrlationAxis, neighborhoodSize] = extractPathAndWaypoints(29, ship, searchProcess, 10, 9, 3,3);
[subpath,subpathAxis, autocorrSubpath, autocorrlationAxis, neighborhoodSize] = extractPathAndWaypoints(29, ship, searchProcess, 777, 4,4,1);

[subpathSTR,subpathAxisSTR, autocorrSubpathSTR, autocorrlationAxisSTR, neighborhoodSizeSTR] = extractPathAndWaypoints(29, ship, searchProcess, 1, 1,2,1);
%[curlyPath,curlyAngles, curlyWpt] = extractPathAndWaypoints(29, ship, searchProcess, 777, 4,1);
%[missingPath,missingAngles, missingWpt] = extractPathAndWaypoints(23, ship, searchProcess, 1, 6);
%missingPath = missingPath(1:size(missingPath,1)/3,:)

thresholdLimit = 0.1;


%figure(1)
%subplot(2,2,1)
%plot(subpathSTR)

%figure(2)
%subplot(2,2,2)
%plot(autocorrSubpathSTR)

figure(3)
%subplot(2,2,3)
plot(subpathAxisSTR,'LineWidth', 2, 'MarkerSize', 8)
ax = gca;
ax.FontSize = 14;

%subplot(2,2,4)
figure(4)
%[peaks,peaklocs] = findpeaks(autocorrlationAxisSTR, 'MinPeakDistance',neighborhoodSizeSTR)
%validPeaks = peaks(peaks > peaks(peakidx));
plot(autocorrlationAxisSTR,'LineWidth', 2, 'MarkerSize', 8)
ax = gca;
ax.FontSize = 14;


% curly paths

%figure(5)
%subplot(2,2,1)
%plot(subpath)

%figure(6)
%subplot(2,2,2)
%plot(autocorrSubpath)

figure(7)
%subplot(2,2,3)
plot(subpathAxis,'LineWidth', 2, 'MarkerSize', 8)
ax = gca;
ax.FontSize = 14;

%subplot(2,2,4)
[peaks,peaklocs] = findpeaks(autocorrlationAxis, 'MinPeakDistance',neighborhoodSize)
validPeaks = []
validPeaklocs = []
for peakidx = 1:size(peaks,1)
    if peaks(peakidx) > thresholdLimit
        validPeaks = [validPeaks; peaks(peakidx)]
        validPeaklocs = [validPeaklocs; peaklocs(peakidx)]
    end
end
%validPeaks = peaks(peaks > threshold);
figure(8)
plot(autocorrlationAxis,'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(peaklocs, peaks, 'go', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(validPeaklocs, validPeaks, 'ro', 'LineWidth', 2, 'MarkerSize', 8)
legend({'Autocorrelation', 'Peaks', 'Valid Peaks'}, 'FontSize', 12, 'Location', 'best');

%hold on
%yline(0.1,'-');
ax = gca;
ax.FontSize = 14;

%plot(0:length(autocorrlationAxis), 0.1, 'r--')




function [subpathAxis,subAngleAxis, autocorrSubpath, autocorrlationAxis, neighborhoodSize] = extractPathAndWaypoints(experimentNumber, ship, searchProcess, generation, individualNumber, subpathNum, angleIndex)
    populationSize = 10; 
    
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "HalfHalfMutation"
        experimentFolderName = append("half-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "randInitPop"
        experimentFolderName = append("randInit-ex", string(experimentNumber),"/"); 
    end
    
    
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
    shipInformation = loadShipSearchParameters(ship);
    R_switch = shipInformation.R_switch;
    
    
    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
    load(resultsPath,"Population", "paths");

    decs = Population.decs
    waypointsList = decs(individualNumber,:)
    numPoints = length(waypointsList)/shipInformation.pointDimension;
    pointsMatrix  =   reshape(waypointsList, [shipInformation.pointDimension, numPoints])'
    pathsMap = paths(string(individualNumber));
    string(individualNumber)
    anglesPath = pathsMap('angles');
    fullPath = pathsMap('fullpath');
    transitionIndices = pathsMap('transitionIndices')

    if length(transitionIndices) == length(pointsMatrix)
        pointsMatrix = fullPath(transitionIndices,:)
    end
    transitionIndices = [0; transitionIndices];
    transitionStart = transitionIndices(subpathNum);
    transitionEnd = transitionIndices(subpathNum+1);

    subpath = fullPath(transitionStart:transitionEnd,:)
    subAngles = anglesPath(transitionStart:transitionEnd,:)

    subAngleAxis = subAngles(:,angleIndex)
    subpathAxis = subpath(:,angleIndex)
    neighborhoodSize = floor(length(subAngleAxis)/100);
    threshold = 0.01;

    [autocorrSubpath, ~] = xcorr(subpathAxis, 'coeff');
    [autocorrlationAxis, ~] = xcorr(subAngleAxis, 'coeff');
    %[peaks,peaklocs] = findpeaks(autocorrelation, 'MinPeakDistance',neighborhoodSize);
    
    %validPeaks = peaks(peaks > threshold);
    %numPeaks = length(validPeaks) - 1 ;
    %if numPeaks < 0
    %    numPeaks = 0;
    %end

end

function [numPeaks, validPeaks] = calculateNumberOfPeaks(measurement)
    neighborhoodSize = floor(length(measurement)/100);
    threshold = 0.01;

    [autocorrelation, ~] = xcorr(measurement, 'coeff');
    [peaks,~] = findpeaks(autocorrelation, 'MinPeakDistance',neighborhoodSize);
    
    validPeaks = peaks(peaks > threshold);
    numPeaks = length(validPeaks) - 1 ;
    if numPeaks < 0
        numPeaks = 0;
    end

   
end
