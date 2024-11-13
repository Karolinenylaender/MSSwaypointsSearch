%% Classificiation

close all
clear all


populationSize = 10; 
numGenerations = 1000;


ship = "nspauv";
%ship = "mariner"
ship = "remus100";

searchProcess = "randomSearch";
%searchProcess = "minDistanceMaxPath";
%searchProcess = "HalfHalfMutation"

if ship == "mariner"
    SearchValidExperiments = 1:14; 
    RandomValidExperiments = 1:30;
    HalfValidExperiments = 0;
elseif ship == "nspauv"
    SearchValidExperiments =  1:30% [1 7 8 9 15] % 2 3 4 5 6 10 11 12 13 14 16:30 %1:30; % 10
    RandomValidExperiments =  1:30 % 1 3   13  22 23 24 25 27:30  %%  1:30;  1:6 15 
    HalfValidExperiments = 1:6 %2:3; %4:30 % 1  
elseif ship == "remus100"
    SearchValidExperiments = 22:30 %1:30; 
    RandomValidExperiments = [16:30 15 6] %6;
    HalfValidExperiments = 1:8 %10:11 %1:11; % 12:30
end

if searchProcess == "randomSearch"
    validExperiments = RandomValidExperiments;
elseif searchProcess == "minDistanceMaxPath"
    validExperiments = SearchValidExperiments;
elseif searchProcess =="HalfHalfMutation"
    validExperiments = HalfValidExperiments;
end

resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

for experimentNumber = validExperiments
    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat")

    [subPathPerformance, experimentPerformance] = CalculateSearchPerformancePerSubpath(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    save(resultsPath, "subPathPerformance", "experimentPerformance")
end
