%% generate plots for the paper

% waypoints
% paths
% and then autocorrelation

close all
clear all

ship = "nspauv";
%ship = "mariner"
%ship = "remus100";

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

if searchProcess == "minDistanceMaxPath"
    validExperiments = 16 %18:30; %30 % [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
else searchProcess == "randomSearch"
    %validExperiments = [1 2 3 4 5 7 8 9 10 11 12 13 14 ___ 25 26 27 28 29 30];    % 9 10 15 16 17 18 19 20 21 22 23 24   
    validExperiments =  15:24;

end


%startExperiment = 15;
%maxExperiments = startExperiment % %startExperiment+30;
populationSize = 10; 

%validExperiments = [10 ];
numGenerations = 1000; %1000;
individualIndex = 7;
generation = 900;

for experimentNumber = validExperiments %startExperiment:maxExperiments
    %for generation = 1:numGenerations
    [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
    Dec = Population.decs;
    %for individualIndex = 1:size(Obj,1)
    individualPath = paths(string(individualIndex));
    fullPath = individualPath('fullpath');
    transitionIndices = individualPath('transitionIndices');
    angles = individualPath('angles');

    pointsMatrix= fullPath([1; transitionIndices],:);

    xpath = fullPath(:,1);
    ypath = fullPath(:,2);
    zpath = fullPath(:,3);
    xpoints = pointsMatrix(:,1);
    ypoints = pointsMatrix(:,2);
    zpoints = pointsMatrix(:,3);
    R_switch = 5;

    %fullpathPerformance = extractFeaturesPath(fullPath, angles, transitionIndices)
    fullpathPerformance = [];
    transitionIndices = [1 transitionIndices'];
    pathSectionIndex1 = 2
    pathSectionIndex2 = 1
    %for pathSectionIndex = 1:length(transitionIndices)-1
        %currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        %currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        %startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        %endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
    figure;
    pathSectionIndex = 2
    plotNum  = 0
    currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
    %numPeaksForAngles = zeros(size(currentAngles,2),1);
    indexes = [1 2 5 6 9 10 3 4 7 8 11 12]
    t = tiledlayout(3,2,'TileSpacing','tight');
    

    for angleType = 1:size(currentAngles,2)
        
        %subplot(3,4,indexes(plotNum))
        nexttile
        
        plotNum = plotNum + 1;
        plot(currentAngles(:,angleType))
        if (plotNum == 1)
            title("Angles")
        elseif (plotNum == 5)
            xlabel("Number of timesteps")

        end

        
        [autocorrelation, validPeaks,validLocs] = calculateNumberOfPeaks(currentAngles(:,angleType));
        %numPeaksForAngles(angleType) = AnglesNumPeaks;
        %subplot(3,4, indexes(plotNum))
        nexttile
        plotNum = plotNum + 1;
        plot(autocorrelation)
        hold on
        plot(validLocs,validPeaks, 'go')
        if (plotNum == 2)
            title("Corresponding autocorrelation function")
        elseif (plotNum == 6)
            xlabel("Lag")

        end
        
        
        
    end
    %ylabel(t, 'common somretihns')

    title(t,"Straight paths angles and corresponding autocorrelation")
    % pathSectionIndex = 3
    % currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
    % %numPeaksForAngles = zeros(size(currentAngles,2),1);
    % for angleType = 1:size(currentAngles,2)
    %     subplot(3,4,indexes(plotNum))
    %     plotNum = plotNum + 1;
    %     plot(currentAngles(:,angleType))
    %     [autocorrelation, validPeaks,validLocs] = calculateNumberOfPeaks(currentAngles(:,angleType));
    %     %numPeaksForAngles(angleType) = AnglesNumPeaks;
    %     subplot(3,4,indexes(plotNum))
    %     plotNum = plotNum + 1;
    %     plot(autocorrelation)
    %     hold on
    %     plot(validLocs,validPeaks, 'go')
    % 
    % end

    
    
    % figure(1)
    % plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', R_switch*2,'MarkerFaceColor','red');
    % hold on
    % grid on;
    % set(gca, 'ZDir', 'reverse');
    % xlabel("y axis",'FontSize',25)
    % ylabel("x axis",'FontSize',25)
    % zlabel("z axis",'FontSize',25)
    % set(findall(gca,'Type','text'),'FontSize',20)
    % str = {'1','2', '3', '4', '5', '6', '7'};
    % str = str(1:length(xpoints))
    % xt = xpoints + 10;
    % yt = ypoints + 10;
    % zt = zpoints - 10;
    % text(yt,xt, zt,str, 'FontSize', 15)
    % figure(2)
    % plot3(ypath, xpath, zpath,"LineWidth",2)
    % hold on
    % plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', R_switch*2,'MarkerFaceColor','red');
    % hold on
    % grid on;
    % set(gca, 'ZDir', 'reverse');
    % 
    % xlabel("y axis",'FontSize',25)
    % ylabel("x axis",'FontSize',25)
    % zlabel("z axis",'FontSize',25)
    % set(findall(gca,'Type','text'),'FontSize',20)

    

    
end


function fullpathPerformance = extractFeaturesPath(fullPath, angles, transitionIndices)
    fullpathPerformance = [];
    transitionIndices = [1 transitionIndices'];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        
        numPeaksForAngles = zeros(size(currentAngles,2),1);
        for angleType = 1:size(currentAngles,2)
            [AnglesNumPeaks, ~] = calculateNumberOfPeaks(currentAngles(:,angleType));
            numPeaksForAngles(angleType) = AnglesNumPeaks;
        end
        lengthOfPath = length(currentPath)/pdist2(startPoint,endPoint);

        currentPathFeatures = [lengthOfPath; numPeaksForAngles];

        fullpathPerformance = [fullpathPerformance; currentPathFeatures'];
    end

end

function [autocorrelation, validPeaks,validLocs] = calculateNumberOfPeaks(measurement)
    neighborhoodSize = floor(length(measurement)/100);
    threshold = 0.01;

    [autocorrelation, ~] = xcorr(measurement, 'coeff');
    [peaks,locs] = findpeaks(autocorrelation, 'MinPeakDistance',neighborhoodSize);
    
    validPeaks = []
    validLocs = []
    for peakIdx = 1:length(peaks)
        peak = peaks(peakIdx);
        if peak > threshold
             validPeaks = [validPeaks peak];
             validLocs = [validLocs locs(peakIdx)];
        end 
    end
    %validPeaks = peaks(peaks > threshold);
    numPeaks = length(validPeaks) - 1 ;
    if numPeaks < 0
        numPeaks = 0;
    end

    %figure;
    %subplot(2,1,1)
    %plot(measurement)
    %subplot(2,1,2)
    % figure;
    % plot(autocorrelation)
    % hold on
    % plot(locs,peaks, 'ro')
    % hold on
    % plot(validLocs,validPeaks, 'go')

    
    
           



   
end