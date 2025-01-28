%% Classificiation

close all
clear all


populationSize = 10; 
numGenerations = 1000;

ship = "mariner"
%ship = "nspauv";
%ship = "remus100";

%searchProcess = "RndSearch";
searchProcess = "WPgenSeed";
%searchProcess = "WPgenComb"
%searchProcess = "WPgenRnd";

if ship == "mariner"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30; 
    randomNSGAValidExperiments = 1:30; 
elseif ship == "nspauv"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30; 
elseif ship == "remus100"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30; 
end

if searchProcess == "RndSearch"
    validExperiments = randomSearchValidExperiments;
elseif searchProcess == "WPgenSeed"
    validExperiments = seedNSGAValidExperiments;
elseif searchProcess =="WPgenComb"
    validExperiments = mixedNSGAValidExperiments;
elseif searchProcess == "WPgenRnd"
    validExperiments = randomNSGAValidExperiments;
end

resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

for experimentNumber = validExperiments
    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat")

    [subPathPerformance, experimentPerformance] = CalculateSearchPerformancePerSubpath(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    save(resultsPath, "subPathPerformance", "experimentPerformance")
end
