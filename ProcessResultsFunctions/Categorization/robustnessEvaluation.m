%% metrics analysis 
close all
clear all

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 27;
maxExperiments = startExperiment % %startExperiment+30;
populationSize = 10; 

validExperiments = [27,28, 29, 10, 11 ]
numGenerations = 1000;
featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];

for experimentNumber = validExperiments %startExperiment:maxExperiments

    [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
end

shipPerformance = [];

%for experimentNumber = startExperiment:maxExperiments
for experimentNumber = validExperiments %startExperiment:maxExperiments

    [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    %missingPathsIndexes = find(all(experi
    % mentPerformance == -1,2))
    %straightPaths = experimentPerformance(~all(experimentPrformance==-1, 2), :);

    %normalizedExperiements = normalizeRows(straightPaths)
    
    numSubpaths = round(size(experimentPerformance,1)/(populationSize*numGenerations));
    populationFeaturesMatrix = [];
    for populationIndex = 1:numSubpaths:(size(experimentPerformance,1)-numSubpaths+1)
        populationFeatures = experimentPerformance(populationIndex:(populationIndex+numSubpaths-1),:);
        populationFeatures = populationFeatures(any(populationFeatures ~= -1, 2), :);
        populationFeatures = [sum(populationFeatures(1:4),1) mean(populationFeatures(:,5:end),1)] ;
        populationFeaturesMatrix = [populationFeaturesMatrix; populationFeatures];
    end

    experimentFeaturesMatrix = experimentPerformance(any(experimentPerformance ~= -1, 2), :);
    experimentFeaturesMatrix = [sum(experimentFeaturesMatrix(1:4),1) mean(experimentFeaturesMatrix(:,5:end),1)];

    normalizationMethods = ["minMax", "zscore", "decimalScaling", "unitVector", "robustScaling", "squashing", "normal"];
    normMethod = normalizationMethods(3);

    methodIndex1 = 4; % 2, 3 or 4 
    methodIndex2 = 8; %5, 6, 7, 8, 9 or 10 


    A = normalizeRows(totalObjectives(:,2), normMethod);
    Bmatrix =  normalizeRows([populationFeaturesMatrix(:,methodIndex1) populationFeaturesMatrix(:,methodIndex2)], normMethod);
    %features_norm    = normalizeRows(populationFeaturesMatrix, "minMax"); % outliers? 3 0.7 0.5 0.3 1.14 0.13
    %features_std     = normalizeRows(populationFeaturesMatrix, "zscore");
    %features_scale   = normalizeRows(populationFeaturesMatrix, "decimalScaling");
    %features_unit    = normalizeRows(populationFeaturesMatrix, "unitVector");
    %features_robust  = normalizeRows(populationFeaturesMatrix, "robustScaling");
    %features_squash  = normalizeRows(populationFeaturesMatrix, "squashing");
    %features_normal  = normalizeRows(populationFeaturesMatrix, "normal");
    
    %normalizationOfChoice = features_squash;
   
    %A = totalObjectives(:,2); 
    %B1 = ones(length(A),1) - Bmatrix(:,1) % can index  2, 3 or 4 
    B1 =  Bmatrix(:,1) % can index  2, 3 or 4 
    %B2 = ones(length(A),1) - Bmatrix(:,2) % can be index 5, 6, 7, 8, 9 or 10 
    B2 = Bmatrix(:,2) % can be index 5, 6, 7, 8, 9 or 10 

    robustness1 = A + B1/2;
    robustness2 = A + B2/2;

    figure(experimentNumber)
    subplot(3,1,1)
    boxplot([robustness1 robustness2])
    title(['Boxplot - normalization method', normMethod])
    subplot(3,1,2)
    histogram(robustness1)
    xlabel(["metric 1:", featureNames(methodIndex1)])
    title('Histogram')
    subplot(3,1,3)
    
    histogram(robustness2)
    xlabel(["metric 2:", featureNames(methodIndex2)])

    
end










