%% Categorize paths
close all
clear all

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";

searchProcess = "randomSearch";
%searchProcess = "minDistanceMaxPath";

if searchProcess == "randomSearch"
    validExperiments = [4 5 6];
else
    validExperiments = [15 16 17 18 19 ]%27,28, 29, 10, 11 ]
end

startExperiment = 15;
maxExperiments = startExperiment % %startExperiment+30;
populationSize = 10; 
numGenerations = 1000

experimentLabels = []
for experimentNumber = validExperiments %startExperiment:maxExperiments
    [subPathPerformance, experimentPerformance]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);

    
    %[missingPaths, curlyPaths, staightPaths] = labelPathType(subPathPerformance)
    [missingPaths, curlyPaths, staightPaths] = labelPathTypeTreshold(subPathPerformance, experimentPerformance, 500)
    performance = []
    thresholds = [50 100 150 200 400 500 600 700 800 1000 ]
    for thres = thresholds
         [missingPaths, curlyPaths, staightPaths] = labelPathTypeTreshold(subPathPerformance, experimentPerformance, thres)
         performance = [performance; [missingPaths, curlyPaths, staightPaths]]
    end
    [missingPaths, curlyPaths, staightPaths] = labelPathType(subPathPerformance)
    performance = [performance; [missingPaths, curlyPaths, staightPaths]]
    figure
    subplot(3,1,1); plot(performance(:,1))
    subplot(3,1,2); plot(performance(:,2))
    subplot(3,1,3); plot(performance(:,3))



    meanDistainceFromOriginalWpt = mean(experimentPerformance(:,2))
    experimentLabels = [experimentLabels; [missingPaths, curlyPaths, staightPaths, meanDistainceFromOriginalWpt]];
    
end
experimentLabels
presentageExperiements = experimentLabels/size(subPathPerformance,1)*100


function [missingPaths, curlyPaths, staightPaths] = labelPathTypeTreshold(subPathPerformance, experimentPerformance, threshold)
    
    missingPaths = 0;
    staightPaths = 0;
    curlyPaths = 0;
    for indvidualIndex = 1:size(experimentPerformance,1)-1
        if experimentPerformance(indvidualIndex,2) <threshold
            indvidualPathsPerformance = subPathPerformance(indvidualIndex*6:((indvidualIndex+1)*6-1),:);
            [IndMissingPaths, IndcurlyPaths, IndstaightPaths] = labelPathType(indvidualPathsPerformance);
            missingPaths = missingPaths + IndMissingPaths;
            staightPaths = staightPaths + IndstaightPaths;
            curlyPaths = curlyPaths + IndcurlyPaths;
        end
    end
    
end


function [missingPaths, curlyPaths, staightPaths] = labelPathType(subPathPerformance)
    missingPaths = 0;
    staightPaths = 0;
    curlyPaths = 0;
    for pathIndex = 1:size(subPathPerformance,1)
        pathScores = subPathPerformance(pathIndex,:);
        if pathScores(:,1) == -1
            missingPaths = missingPaths + 1;
        elseif all(pathScores(:,2:end) > 2)
            curlyPaths = curlyPaths + 1;
        else
            staightPaths = staightPaths + 1;
        end
    end
end

