close all
clear all

populationSize = 10; 
numGenerations = 1000;


ship = "nspauv";
%ship = "mariner"
ship = "remus100";

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";
%searchProcess = "HalfHalfMutation"
searchProcess = "randInitPop";

if ship == "mariner"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:23;
elseif ship == "nspauv"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30 
    randomNSGAValidExperiments = 1:30
elseif ship == "remus100"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30; 
    randomNSGAValidExperiments = 1:30;
end

if searchProcess == "randomSearch"
    validExperiments = randomSearchValidExperiments;
elseif searchProcess == "minDistanceMaxPath"
    validExperiments = seedNSGAValidExperiments;
elseif searchProcess =="HalfHalfMutation"
    validExperiments = mixedNSGAValidExperiments;
elseif searchProcess == "randInitPop"
    validExperiments = randomNSGAValidExperiments;
end

%[indexesMissingPathsRANDS, indexesStraigthRANDS, semicurlyInfoRANDS, curlyInfoRANDS, allPathsEvaluationsRANDS] = extractCalculatedCurliness(ship, "randomSearch", randomSearchValidExperiments, populationSize, numGenerations);


[indexesMissingPathsRANDS, indexesStraigthRANDS, semicurlyInfoRANDS, curlyInfoRANDS, allPathsEvaluationsRANDS] = extractCalculatedCurliness(ship, "randomSearch", randomSearchValidExperiments, populationSize, numGenerations);
[indexesMissingPathsSEED, indexesStraigthSEED, semicurlyInfoSEED, curlyInfoSEED, allPathsEvaluationsSEED] = extractCalculatedCurliness(ship, "minDistanceMaxPath", seedNSGAValidExperiments, populationSize, numGenerations);
[indexesMissingPathsMIXED,indexesStraigthMIXED, semicurlyInfoMIXED, curlyInfoMIXED, allPathsEvaluationsMIXED] = extractCalculatedCurliness(ship, "HalfHalfMutation", mixedNSGAValidExperiments, populationSize, numGenerations);
[indexesMissingPathsRANDPOP, indexesStraigthRANDPOP,semicurlyInfoRANDPOP, curlyInfoRANDPOP, allPathsEvaluationsRANDPOP] = extractCalculatedCurliness(ship, "randInitPop", randomNSGAValidExperiments, populationSize, numGenerations);

indexesMissingPathsALL = [indexesMissingPathsRANDS; indexesMissingPathsSEED; indexesMissingPathsMIXED; indexesMissingPathsRANDPOP];
indexesStraigthALL = [indexesStraigthRANDS; indexesStraigthSEED; indexesStraigthMIXED; indexesStraigthRANDPOP];
semicurlyInfoALL = [semicurlyInfoRANDS; semicurlyInfoSEED; semicurlyInfoMIXED; semicurlyInfoRANDPOP];
curlyInfoALL = [curlyInfoRANDS; curlyInfoSEED; curlyInfoMIXED; curlyInfoRANDPOP];


searchNames = ["RandomSearch", "NSGAseed", "NSGAmixed", "NSGArandom"];

%% 24 types

%% Classify each subpath
countCategoriesSubpathRANDS = plotEachSybpathType(indexesMissingPathsRANDS, indexesStraigthRANDS, semicurlyInfoRANDS, curlyInfoRANDS, "randomSearch", 6, 1);
countCategoriesSubpathSEED = plotEachSybpathType(indexesMissingPathsSEED, indexesStraigthSEED, semicurlyInfoSEED, curlyInfoSEED, "minDistanceMaxPath",6, 2);
countCategoriesSubpathMIXED = plotEachSybpathType(indexesMissingPathsMIXED,indexesStraigthMIXED, semicurlyInfoMIXED, curlyInfoMIXED, "HalfHalfMutation", 6, 3);
countCategoriesSubpathRANDPOP = plotEachSybpathType(indexesMissingPathsRANDPOP, indexesStraigthRANDPOP,semicurlyInfoRANDPOP, curlyInfoRANDPOP, "randInitPop", 6, 4);
countCategoriesSubpathALL = plotEachSybpathType(indexesMissingPathsALL, indexesStraigthALL,semicurlyInfoALL, curlyInfoALL, "all", 6, 5);

%% Full path classification - i.e how much of the path is curly



%% heatmap
axisData = semicurlyInfoRANDS(:,end-2:end)';
maxPeak = max(axisData, [], "all");
countedData = []
for axis = 1:3
    %counts = axisData(axis,:) == 1:maxPeak
    counts = histc(axisData(axis,:), 1:maxPeak);
    %[uniqueValues, ~, idx] = unique(axisData(axis,:));
    %counts = histcounts(idx);
    countedData = [countedData; counts];
end
figure(7)
heatmap(countedData)

figure(8)
axisData = curlyInfoRANDS(:,end-2:end)';
maxPeak = max(axisData, [], "all");
countedData = []
for axis = 1:3
    %counts = axisData(axis,:) == 1:maxPeak
    counts = histc(axisData(axis,:), 1:maxPeak);
    %[uniqueValues, ~, idx] = unique(axisData(axis,:));
    %counts = histcounts(idx);
    countedData = [countedData; counts];
end
heatmap(countedData)

close all

combedAllPaths = [allPathsEvaluationsRANDS; allPathsEvaluationsSEED; allPathsEvaluationsMIXED; allPathsEvaluationsRANDPOP]

[presentageFullTypesRANDS, precentageTypeRANDS, uniqueCombinationRANDS, numUniquePathsRANDS] =  calculateTypesFullpath(allPathsEvaluationsRANDS)
[presentageFullTypesSEED, precentageTypeSEED, uniqueCombinationSEED, numUniquePathsSEED] =  calculateTypesFullpath(allPathsEvaluationsSEED)
[presentageFullTypesMIXED, precentageTypeMIXED, uniqueCombinationMIXED, numUniquePathsMIXED] =  calculateTypesFullpath(allPathsEvaluationsMIXED)
[presentageFullTypesRANDPOP, precentageTypeRANDPOP, uniqueCombinationRANDPOP, numUniquePathsRANDPOP] =  calculateTypesFullpath(allPathsEvaluationsRANDPOP)


% full types is full path
% the secound is count for subpaths 
% uniqueCombinationRANDS is the unique combinations and numUniquePathsRANDS
% is the number of paths with the specific combination

[presentageFullTypesCOMBO, precentageTypeCOMBO, uniqueCombinationCOMBO, numUniquePathsCOMBO] =  calculateTypesFullpath(combedAllPaths);
tt = uniqueCombinationCOMBO(uniqueCombinationCOMBO ~= uniqueCombinationRANDS)


% TODO give a % of paths that are not in the others
% i.e random vs rest and seed vs rest

%[presentageFullTypes, precentageType] =  calculateTypesFullpath(allPathsEvaluationsRANDS)
presentageFullTypes
% numMissing = sum(all(allPathsEvaluationsRANDS == ["missing"],2))
% numStraight = sum(all(allPathsEvaluationsRANDS == ["straight"],2))
% numSemi = sum(all(allPathsEvaluationsRANDS == ["semi-curly"],2))
% numCurly = sum(all(allPathsEvaluationsRANDS == ["curly"],2))
% 
% %% TODO remove the full paths from this calucation
% numSubpathsMissing =  sum(allPathsEvaluationsRANDS == ["missing"],2)
% numSubpathStraight = sum(allPathsEvaluationsRANDS == ["straight"],2)
% numSubpathSemiCurly = sum(allPathsEvaluationsRANDS == ["semi-curly"],2)
% numSubpathCurly = sum(allPathsEvaluationsRANDS == ["curly"],2)
% combined = [numSubpathsMissing numSubpathStraight numSubpathSemiCurly numSubpathCurly]
% precentageType = combined/6

function [presentageFullTypes, precentageType, uniqueCombination, numUniquePaths] =  calculateTypesFullpath(allPathsEvaluations)
    [uniqueCombination, ia,ic] = unique(allPathsEvaluations,'rows');
    numUniquePaths = accumarray(ic,1);

    numMissing = sum(all(allPathsEvaluations == ["M"],2));
    numStraight = sum(all(allPathsEvaluations == ["S"],2));
    numSemi = sum(all(allPathsEvaluations == ["P"],2));
    numCurly = sum(all(allPathsEvaluations == ["C"],2));

    numPaths = size(allPathsEvaluations,1);
    numRemaindingPaths = numPaths - numMissing - numStraight - numSemi - numCurly;
    allPathsEvaluations = allPathsEvaluations( ~all(allPathsEvaluations == ["M"],2),:);
    allPathsEvaluations = allPathsEvaluations( ~all(allPathsEvaluations == ["S"],2),:);
    allPathsEvaluations = allPathsEvaluations( ~all(allPathsEvaluations == ["P"],2),:);
    allPathsEvaluations = allPathsEvaluations( ~all(allPathsEvaluations == ["C"],2),:);

    presentageFullTypes = [numMissing numStraight numSemi numCurly numRemaindingPaths]; %/numPaths*100;

    
    %% TODO remove the full paths from this calucation
    numSubpathsMissing =  sum(allPathsEvaluations == ["M"],2);
    numSubpathStraight = sum(allPathsEvaluations == ["S"],2);
    numSubpathSemiCurly = sum(allPathsEvaluations == ["P"],2);
    numSubpathCurly = sum(allPathsEvaluations == ["C"],2);
    combined = [numSubpathsMissing numSubpathStraight numSubpathSemiCurly numSubpathCurly];
    combined = sum(combined);
    precentageType = combined %/(numRemaindingPaths*6)*100;

    %% 20 different types
    



end

% 


function [indexesMissingPaths, indexesStraightPaths, semiCurlyInfo, curlyInfo, allPathsEvaluations]  = extractCalculatedCurliness(ship, searchProcess, validExperiments, populationSize, numGenerations)
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-ProssesedPathPerformance",".mat")
    load (resultsPath, "indexesMissingPaths", "indexesStraightPaths", "semiCurlyInfo", "curlyInfo", "allPathsEvaluations");
end

function  combineddata = plotEachSybpathType(indexesMissingPaths, indexesStraigth,semicurlyInfo,curlyInfo, searchName, numSubpaths, figureNumber)
    combineddata = [];
    for subpathIdx = 1:numSubpaths
            combineddata = [combineddata; sum(indexesMissingPaths(:,2) == subpathIdx) sum(indexesStraigth(:,2) == subpathIdx) sum(semicurlyInfo(:,2) == subpathIdx) sum(curlyInfo(:,2) == subpathIdx)];
        %bar(combineddata)
    end
    figure(figureNumber)
    subplot(1,2,1)
    b = bar(combineddata);
    legend(["missing paths", "straight paths", "semi-curly paths", "curly paths" ])
    xlabel("subpath number")
    ylabel("number of subpaths per category")
    title(["Each category for search ", searchName])
    
    subplot(1,2,2)
    %ylabel("number of subpaths per category")
    yvalues = {"missing paths", "straight paths", "semi-curly paths", "curly paths" }
    xvalues = {1:numSubpaths}
    heatmap(combineddata','Ydata', yvalues)
    xlabel("subpath number")
    set(gcf,'position',[200,200,2000,750])
end
