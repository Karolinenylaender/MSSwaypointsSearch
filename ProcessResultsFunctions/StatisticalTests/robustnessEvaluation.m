%% metrics analysis 
close all
clear all

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 15;
maxExperiments = startExperiment % %startExperiment+30;
populationSize = 10; 

validExperiments = [16 ]; %15 16 17 18 19 20 21 ]%27,28, 29, 10, 11 ]
%validExperiments = [1 2 3 4 5 6 7 8 9 10 11 12 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29];

numGenerations = 1000; %1000;
%featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
%                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];
%featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
%                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];
% 
% for experimentNumber = validExperiments %startExperiment:maxExperiments
% 
%     [experimentPerformance]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
%     sum(experimentPerformance,1)
%     max(experimentPerformance()) 
%     mean(experimentPerformance()) 
% end

shipPerformance = [];

%for experimentNumber = startExperiment:maxExperiments
for experimentNumber = validExperiments %startExperiment:maxExperiments

    [subPathPerformance, experimentPerformance]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    [numberOfSubpaths, numberOfFeatureTypes] = size(experimentPerformance);
    

    %straightPaths = experimentPerformance(~all(experimentPerformance==-1, 2), :);
    %size(straightPaths)

    A = experimentPerformance(:,2);
    B1 = max(experimentPerformance(:,4:6),[],2); % maximum number of peaks 
    B2 = experimentPerformance(:,15);% total number of peaks
    B3 = experimentPerformance(:,15)/(6*3); %average number of peaks
    metrics = [A B1 B2 B3];
    
    features_norm    = normalizeRows(metrics, "minMax"); % outliers? 3 0.7 0.5 0.3 1.14 0.13
    features_std     = normalizeRows(metrics, "zscore");
    features_scale   = normalizeRows(metrics, "decimalScaling");
    features_unit    = normalizeRows(metrics, "unitVector");
    features_robust  = normalizeRows(metrics, "robustScaling");
    features_squash  = normalizeRows(metrics, "squashing");
    features_normal  = normalizeRows(metrics, "normal");

    features1 =features_norm;
    feature2 = features_squash;
    metric = 4 
    figure
    subplot(8,1,1)
    plot(features_norm(:,1),'o')
    subplot(8,1,2)
    plot(features_squash(:,1),'o')
    subplot(8,1,3)
    plot(features_norm(:,2),'o')
    subplot(8,1,4)
    plot(features_squash(:,2),'o')
    subplot(8,1,5)
    plot(features_norm(:,3),'o')
    subplot(8,1,6)
    plot(features_squash(:,3),'o')
    subplot(8,1,7)
    plot(features_norm(:,4),'o')
    subplot(8,1,8)
    plot(features_squash(:,4),'o')
 
    
    %features_norm(1)- 


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


% 
% function performanceMatrix,  ship, populationSize, numGenerations)
%     if ship == "remus100"
%         numInitialWaypoints = 6;
%     elseif ship == "nspauv"
%         numInitialWaypoints = 6;
%     elseif ship == "mariner"
%         numInitialWaypoints = 7;
%     end
% end






