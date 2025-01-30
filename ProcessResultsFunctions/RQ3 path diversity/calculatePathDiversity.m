%% Classify paths

approachNames = ["WPgenSeed", "WPgenComb", "WPgenRnd"];
vesselNames = ["mariner", "remus100", "nspauv"];
numExperiments = 30;
validExperiments = 1:numExperiments;

reCategorize = false;
reCalcuateDistribution = true;
for vessel = vesselNames
    uniquePathsPercentageMap = containers.Map;
    differentsubpathsMap = containers.Map;
    differentsubpathsTable = [];

    for approachType = approachNames
        [uiquePathsPercentage,averageTypeCountPerExperimentList, percentageTypePerExperimentMap] = calculateDifferentTypesPerSubpath(vessel, approachType, reCategorize, reCalcuateDistribution);
        uniquePathsPercentageMap(approachType) = uiquePathsPercentage;
        differentsubpathsMap(approachType) = percentageTypePerExperimentMap;
        differentsubpathsTable = [differentsubpathsTable; averageTypeCountPerExperimentList];
    end
    differentsubpathsTable = differentsubpathsTable';

    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    
    resultsPath = append(resultsFolder, "/", vessel,"/" , "pathDiversity",".mat");
    save(resultsPath, "differentsubpathsTable","uniquePathsPercentageMap")
end
    




function [uniquePathsPercentage,averageTypeCountPerExperimentList, percentageTypePerExperimentMap] = calculateDifferentTypesPerSubpath(ship,searchname,reCategorize, reCalcuateDistribution)
    [allPathsEvaluations, experimentsCountMap] = categorizeSubpaths(ship, searchname,reCategorize);

    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    if reCalcuateDistribution == true

        if ship == "mariner"
            numSubpaths = 5;
        else
            numSubpaths = 6; 
        end
        maxPaths = 2^numSubpaths + 2*(numSubpaths-1);
  
        % calculate unique paths per experiments
        countPerExperiment = zeros(1,size(experimentsCountMap,1));
        typeCount = [];
        for experimentNum = 1:size(experimentsCountMap,1)
            experimentsCount = experimentsCountMap(string(experimentNum));
            experimentTypeCount = zeros(size(experimentsCount,1),3);
            for subpathRowIdx = 1:size(experimentsCount,1)
                subpathRow = experimentsCount(subpathRowIdx,:);
                experimentTypeCount(subpathRowIdx,:) = [sum(subpathRow == "S"); sum(subpathRow == "U"); sum(subpathRow == "M");];
                
    
            end
            typeCount = [typeCount; sum(experimentTypeCount)/(size(experimentsCount,1)*size(experimentsCount,2))];
            
            uniqueCombinationsExperiment = unique(experimentsCount,'rows');
            numUniqueCombinationsExperiment = size(uniqueCombinationsExperiment,1);
            countPerExperiment(experimentNum) =  numUniqueCombinationsExperiment;
        end
        %typeCount
        averageTypeCountPerExperimentList = mean(typeCount)*100;

        percentageTypePerExperimentMap = containers.Map;
        percentageTypePerExperimentMap("stable") = averageTypeCountPerExperimentList(1);
        percentageTypePerExperimentMap("unstable") = averageTypeCountPerExperimentList(2);
        percentageTypePerExperimentMap("missing") = averageTypeCountPerExperimentList(3);

        uniquePathsPercentage = mean(countPerExperiment)/maxPaths*100;
    
        resultsPath = append(resultsFolder, "/", ship,"/",searchname ,"-typesOfPaths",".mat");
        save(resultsPath, "uniquePathsPercentage","averageTypeCountPerExperimentList", "percentageTypePerExperimentMap");
    
    else
        resultsPath = append(resultsFolder, "/", ship,"/",searchname ,"-typesOfPaths",".mat");
        load(resultsPath, "uniquePathsPercentage","averageTypeCountPerExperimentList", "percentageTypePerExperimentMap");
    end

     
end
