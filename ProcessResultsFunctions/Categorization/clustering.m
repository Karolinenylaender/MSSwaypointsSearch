%% perform clustering

close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

startExperiment = 27;
maxExperiments = 27 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;
%featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
%                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];

featureNames = ["Length of path", "num peaks psi", "num peaks theta", "num peaks phi"];

for experimentNumber = startExperiment:maxExperiments

    experimentPerformance = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    %missingPathsIndexes = find(all(experimentPerformance == -1,2))
    experimentPerformance = experimentPerformance(~all(experimentPerformance==-1, 2), :);

    %normalizedExperiements = normalizeRows(straightPaths)
    
    % features_norm    = normalizeRows(experimentPerformance, "minMax"); % outliers? 3 0.7 0.5 0.3 1.14 0.13
    % features_std     = normalizeRows(experimentPerformance, "zscore"); %% feil
    % features_scale   = normalizeRows(experimentPerformance, "decimalScaling");
    % features_unit    = normalizeRows(experimentPerformance, "unitVector");
    % features_robust  = normalizeRows(experimentPerformance, "robustScaling");
    % features_squash  = normalizeRows(experimentPerformance, "squashing");
    % features_normal  = normalizeRows(experimentPerformance, "normal");

    normalizationMethods = ["minMax", "zscore", "decimalScaling", "unitVector", "robustScaling", "squashing", "normal"];
    normMethod1 = normalizationMethods(1);
    normalize1 = normalizeRows(experimentPerformance,normMethod1);
    normMethod2 = normalizationMethods(6);
    normalize2 = normalizeRows(experimentPerformance,normMethod2);
    feature1 = experimentPerformance(:,1)
    feature2 = sum(experimentPerformance(:,2:end),2)

    normMethod1 = normalizationMethods(1);
    normalize1 = normalizeRows(experimentPerformance,normMethod1);
    normMethod2 = normalizationMethods(6);
    normalize2 = normalizeRows(experimentPerformance,normMethod2);


    %for i =2:size(experimentPerformance,2)
    figure(1)
    subplot(3,1,1)
     
    idx = dbscan([experimentPerformance(:,1) feature2],10,100);
    gscatter(feature1, feature2, idx)
    xlabel("Length of path");
    ylabel("sum of peaks");
    title(["dbscan clustering"])

    subplot(3,1,2)
    idx = dbscan(experimentPerformance,10,100);
    gscatter(feature1, feature2, idx)
    xlabel("Length of path");
    ylabel("sum of peaks");
    title(["dbscan clustering - not summing"])

    

    subplot(3,1,3)
    idx = kmeans(experimentPerformance,10);
    %idx = dbscan([experimentPerformance(:,1) feature2],5,10);
    gscatter(feature1, feature2, idx)
    xlabel("Length of path");
    ylabel("sum of peaks");
    title(["kmeas clustering"])

        
    % subplot(3,1,2)
    % idxNorm1 = dbscan([normalize1(:,1) normalize1(:,i)],0.01,5);
    % gscatter(normalize1(:,1), normalize1(:,i),idxNorm1)
    % xlabel(['normalization method', normMethod1])
    % 
    % subplot(3,1,3)
    % idxNorm2 = dbscan([normalize2(:,1) normalize2(:,i)],0.01,5);
    % gscatter(normalize2(:,1), normalize2(:,i),idxNorm2)
    % xlabel(['normalization method', normMethod2])



    %end
    % feature1 = 2
    % feature2 = 6
    % 
    % figure(1)
    % idx = dbscan(experimentPerformance,1,10);
    % plot3(experimentPerformance(:,1), experimentPerformance(:,2), experimentPerformance(:,6),'o',idx)
    % title(["clustering all "])
    % 
    % subplot(3,1,2)
    % idxNorm1 = dbscan([normalize1],0.01,5);
    % scatter3(normalize1(:,1), normalize1(:,2),normalize1(:,6),idxNorm1)
    % xlabel(['normalization method', normMethod1])
    % 
    % subplot(3,1,3)
    % idxNorm2 = dbscan([normalize2],0.01,5);
    % gscatter(normalize2(:,1), normalize2(:,6), normalize2(:,6),idxNorm2)
    % xlabel(['normalization method', normMethod2])

      
    % min-max normalization - range of [0 1]
    % Z score normalization mean 0 and standard deviation of 1
    % Decimal scaling
    % UInit vector normalixation
    % Robust Scaling



end



