%% metrics analysis 
close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 4;
maxExperiments = 4 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;

shipPerformance = [];
for experimentNumber = startExperiment:maxExperiments

    [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    %missingPathsIndexes = find(all(experi
    % mentPerformance == -1,2))
    %straightPaths = experimentPerformance(~all(experimentPrformance==-1, 2), :);

    %normalizedExperiements = normalizeRows(straightPaths)
    
    numSubpaths = size(experimentPerformance,1)/(populationSize*numGenerations);
    populationFeaturesMatrix = [];
    for populationIndex = 1:numSubpaths:size(experimentPerformance,1)
        populationFeatures = experimentPerformance(populationIndex:(populationIndex+numSubpaths-1),:);
        populationFeatures = populationFeatures(any(populationFeatures ~= -1, 2), :);
        populationFeatures = [sum(populationFeatures(1:4),1) mean(populationFeatures(:,5:end),1)] ;
        populationFeaturesMatrix = [populationFeaturesMatrix; populationFeatures];
    end

    generationFeaturesMatrix = [];
    for generationIndex = 1:(populationSize*numSubpaths):size(populationFeaturesMatrix)
        generationFeatures = experimentPerformance(generationIndex:(generationIndex+(populationSize*numSubpaths)-1),:);
        generationFeatures = generationFeatures(any(generationFeatures ~= -1, 2), :);
        generationFeatures = [sum(generationFeatures(1:4),1) mean(generationFeatures(:,5:end),1)] ;
        generationFeaturesMatrix = [generationFeaturesMatrix; generationFeatures];
    end

    experimentFeaturesMatrix = [];
    experimentFeaturesMatrix = experimentPerformance(any(experimentPerformance ~= -1, 2), :);
    experimentFeaturesMatrix = [sum(experimentFeaturesMatrix(1:4),1) mean(experimentFeaturesMatrix(:,5:end),1)];


    features_norm    = normalizeRows(experimentPerformance, "minMax"); % outliers? 3 0.7 0.5 0.3 1.14 0.13
    features_std     = normalizeRows(experimentPerformance, "zscore");
    features_scale   = normalizeRows(experimentPerformance, "decimalScaling");
    features_unit    = normalizeRows(experimentPerformance, "unitVector");
    features_robust  = normalizeRows(experimentPerformance, "robustScaling");
    features_squash  = normalizeRows(experimentPerformance, "squashing");
    features_normal  = normalizeRows(experimentPerformance, "normal");

   
    A = totalObjectives 
    %B1 =
    %B2 = 

    robustness1 = A + B1/2;
    robustness2 = A + B2/2;


end










