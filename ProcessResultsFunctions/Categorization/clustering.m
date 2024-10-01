%% perform clustering

close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

startExperiment = 2;
maxExperiments = 2 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;
featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];

for experimentNumber = startExperiment:maxExperiments

    experimentPerformance = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    %missingPathsIndexes = find(all(experimentPerformance == -1,2))
    %straightPaths = experimentPerformance(~all(experimentPrformance==-1, 2), :);

    %normalizedExperiements = normalizeRows(straightPaths)

    features_norm    = normalizeRows(experimentPerformance, "minMax"); % outliers? 3 0.7 0.5 0.3 1.14 0.13
    features_std     = normalizeRows(experimentPerformance, "zscore"); %% feil
    features_scale   = normalizeRows(experimentPerformance, "decimalScaling");
    features_unit    = normalizeRows(experimentPerformance, "unitVector");
    features_robust  = normalizeRows(experimentPerformance, "robustScaling");
    features_squash  = normalizeRows(experimentPerformance, "squashing");
    features_normal  = normalizeRows(experimentPerformance, "normal");

    normalized1 = features_squash;
    normalized2 = features_scale;
    for i =2:size(experimentPerformance,2)
        figure(i)
        subplot(3,1,1)
        idx = dbscan([experimentPerformance(:,1) experimentPerformance(:,i)],1,10)
        gscatter(experimentPerformance(:,1), experimentPerformance(:,i), idx)
        
        subplot(3,1,2)
        idxNorm1 = dbscan([normalized1(:,1) normalized1(:,i)],0.01,5)
        gscatter(normalized1(:,1), normalized1(:,i),idxNorm1)

        subplot(3,1,3)
        idxNorm2 = dbscan([normalized2(:,1) normalized2(:,i)],0.01,5)
        gscatter(normalized2(:,1), normalized2(:,i),idxNorm2)



    end
      
    % min-max normalization - range of [0 1]
    % Z score normalization mean 0 and standard deviation of 1
    % Decimal scaling
    % UInit vector normalixation
    % Robust Scaling



end



