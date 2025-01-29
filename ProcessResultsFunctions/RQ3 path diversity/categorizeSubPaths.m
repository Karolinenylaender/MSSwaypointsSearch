% classify paths
%% Classificiation

close all
clear all


populationSize = 10; 
numGenerations = 1000;


ship = "nspauv"; 
%ship = "mariner"
%ship = "remus100";

%searchProcess = "RndSearch";
%searchProcess = "WPgenSeed";
%searchProcess = "WPgenComb"
%searchProcess = "WPgenRnd";

randomSearchValidExperiments = 1:30;
seedNSGAValidExperiments = 1:30;
mixedNSGAValidExperiments = 1:30; 
randomNSGAValidExperiments = 1:30;


% if searchProcess == "RndSearch"
%     validExperiments = randomSearchValidExperiments;
% elseif searchProcess == "WPgenSeed"
%     validExperiments = seedNSGAValidExperiments;
% elseif searchProcess =="WPgenComb"
%     validExperiments = mixedNSGAValidExperiments;
% elseif searchProcess == "WPgenRnd"
%     validExperiments = randomNSGAValidExperiments;
% end

searchNames = ["RndSearch", "WPgenSeed", "WPgenComb", "WPgenSeed "];

resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);


% [indexesMissingPathsRANDS, indexesStraigthRANDS, semicurlyInfoRANDS, curlyInfoRANDS] = countCurlynessOfPath(ship, "randomSearch", randomSearchValidExperiments, populationSize, numGenerations)


reCalcualte = true
if reCalcualte 
    randomSearchPopulation = loadAllShipPopulations(ship, "RndSearch", randomSearchValidExperiments, populationSize, numGenerations);
    seedNSGAPopulation = loadAllShipPopulations(ship, "WPgenSeed", seedNSGAValidExperiments, populationSize, numGenerations);
    mixedNSGAPopulation = loadAllShipPopulations(ship, "WPgenComb", mixedNSGAValidExperiments, populationSize, numGenerations);
    randomNSGAPopulation = loadAllShipPopulations(ship, "WPgenRnd", randomNSGAValidExperiments, populationSize, numGenerations);
    
    combinedPopulations  = SOLUTION([randomSearchPopulation.decs; seedNSGAPopulation.decs; mixedNSGAPopulation.decs; randomNSGAPopulation.decs], ...
                                     [randomSearchPopulation.objs; seedNSGAPopulation.objs; mixedNSGAPopulation.objs; randomNSGAPopulation.objs], ...
                                     [randomSearchPopulation.cons; seedNSGAPopulation.cons; mixedNSGAPopulation.cons; randomNSGAPopulation.cons]);
    
    objestives = combinedPopulations.objs;
    maxDistanceFromPath = mean(objestives(:,2))
    paretoFront = combinedPopulations.best.objs;
    maxDistanceFromPath = max(paretoFront(:,2));

    [indexesMissingPathsRANDS, indexesStraigthRANDS, semicurlyInfoRANDS, curlyInfoRANDS] = countCurlynessOfPath(ship, "RndSearch", randomSearchValidExperiments, populationSize, numGenerations, maxDistanceFromPath)
    [indexesMissingPathsSEED, indexesStraigthSEED, semicurlyInfoSEED, curlyInfoSEED] = countCurlynessOfPath(ship, "WPgenSeed", seedNSGAValidExperiments, populationSize, numGenerations, maxDistanceFromPath);
    [indexesMissingPathsMIXED,indexesStraigthMIXED, semicurlyInfoMIXED, curlyInfoMIXED] = countCurlynessOfPath(ship, "WPgenComb", mixedNSGAValidExperiments, populationSize, numGenerations, maxDistanceFromPath);
    [indexesMissingPathsRANDPOP, indexesStraigthRANDPOP,semicurlyInfoRANDPOP, curlyInfoRANDPOP] = countCurlynessOfPath(ship, "WPgenRnd", randomNSGAValidExperiments, populationSize, numGenerations, maxDistanceFromPath);

else
    
    [indexesMissingPathsRANDS, indexesMissingPathsRANDS, semicurlyInfoRANDS, curlyInfoRANDS,allPathsEvaluationsRANDS, limitedAllPathsEvaluationsRANDS,experimentsCountMapRANDS] = extractCalculatedCurliness(ship, "RndSearch", randomSearchValidExperiments, populationSize, numGenerations);
    [indexesMissingPathsSEED, indexesStraigthSEED, semicurlyInfoSEED, curlyInfoSEED,allPathsEvaluationsSEED, limitedAllPathsEvaluationsSEED, experimentsCountMapSEED] = extractCalculatedCurliness(ship, "WPgenSeed", seedNSGAValidExperiments, populationSize, numGenerations);
    [indexesMissingPathsMIXED,indexesStraigthMIXED, semicurlyInfoMIXED, curlyInfoMIXED,allPathsEvaluationsMIXED,limitedAllPathsEvaluationsMIXED, experimentsCountMapMIXED] = extractCalculatedCurliness(ship, "WPgenComb", mixedNSGAValidExperiments, populationSize, numGenerations);
    [indexesMissingPathsRANDPOP, indexesStraigthRANDPOP,semicurlyInfoRANDPOP, curlyInfoRANDPOP,allPathsEvaluationsRANDPOP,limitedAllPathsEvaluationsRANDPOP, experimentsCountMapRANDPOP] = extractCalculatedCurliness(ship, "WPgenRnd", randomNSGAValidExperiments, populationSize, numGenerations);
end


if ship == "mariner"
    numSubpaths = 5;
else
    numSubpaths = 6; 
end

%[countOfEachTypeRANDS, uniqueComboRANDS, numUniqueCombinationsRANDS,] = calculateDifferentTypesPerSubpath(ship, "RndSearch",limitedAllPathsEvaluationsRANDS, numSubpaths,"limited")
%[countOfEachTypeSEED, uniqueComboSEED, numUniqueCombinationsSEED] = calculateDifferentTypesPerSubpath(ship,"WPgenSeed", limitedAllPathsEvaluationsSEED, numSubpaths, "limited")
%[countOfEachTypeMIXED, uniqueComboMIXED,numUniqueCombinationsMIXED] = calculateDifferentTypesPerSubpath(ship,"WPgenComb",limitedAllPathsEvaluationsMIXED, numSubpaths, "limited")
%[countOfEachTypeRANDPOP, uniqueComboRANDPOP,numUniqueCombinationsRANDPOP] = calculateDifferentTypesPerSubpath(ship,"WPgenRnd",limitedAllPathsEvaluationsRANDPOP, numSubpaths, "limited")

%numUniqueRANDS = countUniqueRows(uniqueComboRANDS, uniqueComboSEED, uniqueComboMIXED, uniqueComboRANDPOP)
%numUniqueSEED = countUniqueRows(uniqueComboSEED, uniqueComboRANDS, uniqueComboMIXED, uniqueComboRANDPOP)
%numUniqueMIXED = countUniqueRows(uniqueComboMIXED, uniqueComboSEED, uniqueComboRANDS, uniqueComboRANDPOP)
%numUniqueRANDPOP = countUniqueRows(uniqueComboRANDPOP, uniqueComboSEED, uniqueComboMIXED, uniqueComboRANDS)

[countOfEachTypeRANDS, uniqueComboRANDS, numUniqueCombinationsRANDS, averagePerExperimentRANDS] = calculateDifferentTypesPerSubpath(ship,"RndSearch", allPathsEvaluationsRANDS, numSubpaths, experimentsCountMapRANDS)
[countOfEachTypeSEED, uniqueComboSEED, numUniqueCombinationsSEED, averagePerExperimentSEED] = calculateDifferentTypesPerSubpath(ship,"WPgenSeed",allPathsEvaluationsSEED, numSubpaths, experimentsCountMapSEED)
[countOfEachTypeMIXED, uniqueComboMIXED,numUniqueCombinationsMIXED, averagePerExperimentMIXED] = calculateDifferentTypesPerSubpath(ship,"WPgenComb",allPathsEvaluationsMIXED, numSubpaths,experimentsCountMapMIXED)
[countOfEachTypeRANDPOP, uniqueComboRANDPOP,numUniqueCombinationsRANDPOP, averagePerExperimentRANDPOP] = calculateDifferentTypesPerSubpath(ship,"WPgenRnd",allPathsEvaluationsRANDPOP, numSubpaths,experimentsCountMapRANDPOP)

%uniqueComboRANDS
uniqueComboSEED
uniqueComboMIXED
uniqueComboRANDPOP

numUniqueCombinationsRANDS
numUniqueCombinationsSEED
numUniqueCombinationsMIXED
numUniqueCombinationsRANDPOP

averagePerExperimentRANDS
averagePerExperimentSEED
averagePerExperimentMIXED
averagePerExperimentRANDPOP

uniqueComboRANDS = []
numUniqueRANDS = countUniqueRows(uniqueComboRANDS, uniqueComboSEED, uniqueComboMIXED, uniqueComboRANDPOP)
numUniqueSEED = countUniqueRows(uniqueComboSEED, uniqueComboRANDS, uniqueComboMIXED, uniqueComboRANDPOP)
numUniqueMIXED = countUniqueRows(uniqueComboMIXED, uniqueComboSEED, uniqueComboRANDS, uniqueComboRANDPOP)
numUniqueRANDPOP = countUniqueRows(uniqueComboRANDPOP, uniqueComboSEED, uniqueComboMIXED, uniqueComboRANDS)

results = [];
results = [results; numUniqueCombinationsSEED numUniqueSEED];
results = [results; numUniqueCombinationsMIXED numUniqueMIXED];
results = [results; numUniqueCombinationsRANDPOP numUniqueRANDPOP];

results = results/30;
display(results)

numUniqueCombinationsRANDPOP
function [countOfEachType, uniqueCombinations, numUniqueCombinations, averagePerExperiment] = calculateDifferentTypesPerSubpath(ship,searchname,allPathsEvaluations, numSubpaths, experimentsCountMap)
    types = ["M", "S", "P", "C"];
    countOfEachType = zeros(4,numSubpaths);
    numStable = 0;
    numMissing = 0;
    numUnstable = 0;
    if ~isempty(allPathsEvaluations)
        for subpathIdx = 1:size(allPathsEvaluations,1)
            subpath = allPathsEvaluations(subpathIdx,:);
            if all(subpath == "S")
                numStable = numStable + 1;
            elseif any(subpath == "M")
                numMissing = numMissing + 1;
            elseif any(subpath == "U")
                numUnstable = numUnstable + 1;
            end

        end

        %for subpath = 1:numSubpaths
        %    subpathScores = allPathsEvaluations(:,subpath);
        %    missingCount = sum(subpathScores == "M");
        %    straightCount = sum(subpathScores == "S");
        %    semiCurlyCount = sum(subpathScores == "P");  
        %    curlyCount = sum(subpathScores == "U");
        %    countOfEachType(:,subpath) = [straightCount; semiCurlyCount; curlyCount; missingCount];
            %[C, ia, ic] = unique(subpathScores)
            %countOfEachType = [C,  accumarray(ic,1)]
        %end
    end
    uniqueCombinations = [numStable numUnstable numMissing]/size(allPathsEvaluations,1);
    
    countPerExperiment = zeros(1,size(experimentsCountMap,1));
    typeCount = [];
    for experimentNum = 1:size(experimentsCountMap,1)
        experimentsCount = experimentsCountMap(string(experimentNum));
        experimentTypeCount = zeros(size(experimentsCount,1),3);
        for subpathRowIdx = 1:size(experimentsCount,1)
            subpathRow = experimentsCount(subpathRowIdx,:);
            experimentTypeCount(subpathRowIdx,:) = [sum(subpathRow == "S"); sum(subpathRow == "U"); sum(subpathRow == "M");];
            

        end
        %experimentTypeCount = experimentTypeCount/size(experimentsCount,1);
        typeCount = [typeCount; sum(experimentTypeCount)/(size(experimentsCount,1)*size(experimentsCount,2))];
        
        uniqueCombinationsExperiment = unique(experimentsCount,'rows');
        numUniqueCombinationsExperiment = size(uniqueCombinationsExperiment,1);
        countPerExperiment(experimentNum) =  numUniqueCombinationsExperiment;
    end
    %typeCount
    averageTypeCountPerExperiment = mean(typeCount);
    averagePerExperiment = averageTypeCountPerExperiment;
    %averagePerExperiment = mean(countPerExperiment); %/size(experimentsCountMap,1);

    mean(countPerExperiment)
    countOfEachType = [countOfEachType sum(countOfEachType')'];

    %uniqueCombinations = unique(allPathsEvaluations,'rows');
    numUniqueCombinations = size(uniqueCombinations,1);

    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/",searchname , "-","-typesOfPaths",".mat");
    save(resultsPath, "countOfEachType", "uniqueCombinations", "numUniqueCombinations", "countPerExperiment");

     
end

function numRowsNotInTheOthers = countUniqueRows(search, searchA, searchB, searchC)
    %numRowsNotInTheOthers = 0;
    if  isempty(search)
        numRowsNotInTheOthers = 0;
    elseif ~isempty(searchA)
        search = search(~ismember(search,searchA,'rows'),:),
    elseif ~isempty(searchB)
        search = search(~ismember(search,searchB,'rows'),:);
    elseif ~isempty(searchC)
        search = search(~ismember(search,searchC,'rows'),:);
    else
        numRowsNotInTheOthers = 0;
    end
    %for row = 1:size(search,1)   
    %    ismember(search,searchB,'rows')
    %    ismember(search,searchC,'rows')
    %    if ~(isequal(search(row, :), searchA(row, :)) || isequal(search(row, :), searchB(row, :)) || isequal(search(row, :), searchC(row, :)))
    %        numRowsNotInTheOthers = numRowsNotInTheOthers + 1;
    %    end
    %end
    numRowsNotInTheOthers = size(search,1);
end




%% count number of each type wrt the subpath
figure(1)
randomSearchCount = [sum(indexesMissingPathsRANDS(:,2) == 1:numSubpaths)
                sum(indexesStraigthRANDS(:,2)== 1:numSubpaths);
                sum(semicurlyInfoRANDS(:,2) == 1:numSubpaths);
                sum(curlyInfoRANDS(:,2) == 1:numSubpaths)]'
bar(randomSearchCount, 'stacked')
legend(["missing paths", "straight paths", "semi-curly paths", "curly paths"])
title("number of randoms subpaths classification ")
xlabel("subpath index")
ylabel("number missing")

figure(2)
bar3(randomSearchCount)
ylabel("subpath index")
zlabel("number paths")
xticklabels(["missing paths", "straight paths", "semi-curly paths", "curly paths"])


figure(3)
seedCount = [sum(indexesMissingPathsSEED(:,2) == 1:numSubpaths)
                sum(indexesStraigthSEED(:,2)== 1:numSubpaths);
                sum(semicurlyInfoSEED(:,2) == 1:numSubpaths);
                sum(curlyInfoSEED(:,2) == 1:numSubpaths)]'
bar(seedCount, 'stacked')
legend(["missing paths", "straight paths", "semi-curly paths", "curly paths"])
title("number of seed NSGA subpaths classification ")
xlabel("subpath index")
ylabel("number missing")

figure(4)
bar3(seedCount)
ylabel("subpath index")
zlabel("number paths")
xticklabels(["missing paths", "straight paths", "semi-curly paths", "curly paths"])

figure(5)
mixedCount = [sum(indexesMissingPathsMIXED(:,2) == 1:numSubpaths)
                sum(indexesStraigthMIXED(:,2)== 1:numSubpaths);
                sum(semicurlyInfoMIXED(:,2) == 1:numSubpaths);
                sum(curlyInfoMIXED(:,2) == 1:numSubpaths)]'
bar(mixedCount, 'stacked')
legend(["missing paths", "straight paths", "semi-curly paths", "curly paths"])
title("number of mixed NSGA subpaths classification ")
xlabel("subpath index")
ylabel("number missing")

figure(6)
bar3(mixedCount)
ylabel("subpath index")
zlabel("number paths")
xticklabels(["missing paths", "straight paths", "semi-curly paths", "curly paths"])

figure(7)
randomCount = [sum(indexesMissingPathsRANDPOP(:,2) == 1:numSubpaths)
                sum(indexesStraigthRANDPOP(:,2)== 1:numSubpaths);
                sum(semicurlyInfoRANDPOP(:,2) == 1:numSubpaths);
                sum(curlyInfoRANDPOP(:,2) == 1:numSubpaths)]'
bar(randomCount, 'stacked')
legend(["missing paths", "straight paths", "semi-curly paths", "curly paths"])
title("number of random NSGA subpaths classification ")
xlabel("subpath index")
ylabel("number missing")

figure(8)
combinedSearches = [randomSearchCount;seedCount; mixedCount; randomCount]
bar3(randomCount)
ylabel("subpath index")
zlabel("number missing")
xticklabels(["missing paths", "straight paths", "semi-curly paths", "curly paths"])



figure(11)
histogram(sum(semicurlyInfoRANDS(:,end-2:end),2))
legend(searchNames(1))
ylabel("number of subpaths")
xlabel("sum of peaks")
% 
% subplot(1,2,2)
% lengths = semicurlyInfoRANDS(:,end-3)
% histogram(sum(semicurlyInfoRANDS(:,end-2:end),2)/lengths)
% legend(searchNames(1))
% ylabel("number of subpaths")
% xlabel("sum of peaks")

figure(12)

histogram(sum(semicurlyInfoSEED(:,end-2:end),2))
legend(searchNames(2))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(13)
histogram(sum(semicurlyInfoMIXED(:,end-2:end),2))
legend(searchNames(3))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(14)
histogram(sum(semicurlyInfoRANDPOP(:,end-2:end),2))
legend(searchNames(4))
ylabel("number of subpaths")
xlabel("sum of peaks")



figure(15)
histogram(sum(curlyInfoRANDS(:,end-2:end),2))
legend(searchNames(1))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(16)
histogram(sum(curlyInfoSEED(:,end-2:end),2))
legend(searchNames(2))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(17)
histogram(sum(curlyInfoMIXED(:,end-2:end),2))
legend(searchNames(3))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(18)
histogram(sum(curlyInfoRANDPOP(:,end-2:end),2))
legend(searchNames(4))
ylabel("number of subpaths")
xlabel("sum of peaks")

figure(20)
onlyPeaks = curlyInfoRANDPOP(:,end-2:end)
heatmap(onlyPeaks')



% do the same but divide by the distance between the waypoints





function [indexesMissingPaths, indexesStraightPaths, semiCurlyInfo, curlyInfo, allPathsEvaluations, limitedAllPathsEvaluations, experimentsCountMap] = countCurlynessOfPath(ship, searchProcess, validExperiments, populationSize, numGenerations, maxDistanceFromOrignalWpt)
    
    shipInformation = loadShipSearchParameters(ship);
    pointDimension = shipInformation.pointDimension;
    initialPoints = shipInformation.initialPoints;
    numWaypoints = length(shipInformation.initialPoints)/shipInformation.pointDimension;
    firstPoint = zeros(1,pointDimension);

    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    %experimentsPerformance = zeros(length(validExperiments),3);
    indexesMissingPaths = [];
    indexesStraightPaths = [];
    %CurlyAverageList = [];
    %nonCurlyAverageList = [];
    semiCurlyInfo = [];
    curlyInfo = [];
    allPathsEvaluations = [];
    limitedAllPathsEvaluations = [];
    if ship == "mariner"
        numSubpaths = 5;
    else
        numSubpaths = 6;
    end
    experimentsCountMap= containers.Map;
    for experimentNumber = validExperiments
        experimentsCount = [];
        curlyPaths = 0;
        missignPaths = 0;
        normalPaths = 0;

        
        
    
        resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat")
        load(resultsPath, "subPathPerformance", "experimentPerformance");
        size(subPathPerformance);
        size(experimentPerformance);
        
    
        % load the population
        % for generation = 1:numGenerations
        %     resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");
        %     load(resultsPath, 'Population')
        % end
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess, experimentNumber, populationSize, numGenerations);
        %experimentDecs = experimentPopulation.decs;
        %experimentObjs = experimentPopulation.objs;

        experimentParetoFront = experimentPopulation.best;
        experimentObjs = experimentParetoFront.objs;
        experimentDecs = experimentParetoFront.decs;

        experimentLevel = 10^floor(log10(size(subPathPerformance,1))+1)*experimentNumber;
        for individualIdx = 1:numWaypoints:(size(experimentDecs,1)*numSubpaths)
            %distanceFromOriginal = experimentObjs((individualIdx+numWaypoints-1)/numWaypoints,2);
            
            currentPath = subPathPerformance(individualIdx:individualIdx+numWaypoints-1,:);
    
            individualPoints = experimentDecs((individualIdx+numWaypoints-1)/numWaypoints,:);
            pointMatrix = [firstPoint; reshape(individualPoints, [pointDimension, numWaypoints])'];
            fullPathEvaluation = [];
            for subpathIdx = 1:numSubpaths
                lengthOfsubPath = currentPath(subpathIdx,1);
                if ship == "mariner"
                    subCurrentPath = currentPath(subpathIdx,4:end);
                else
                    subCurrentPath = currentPath(subpathIdx,2:end);
                end
                %distanceBetweenWaypoints = pdist2(pointMatrix(subpathIdx),pointMatrix(subpathIdx+1));
                
                %experimentIndex = experimentLevel+ individualIdx+subpathIdx-1;
                if any(subCurrentPath == -1) 
                    % path is missing 
                    %indexesMissingPaths = [indexesMissingPaths; experimentIndex subpathIdx];
                    type = "M";
                elseif all(subCurrentPath == 0) 
                    % completly straight path
                    %indexesStraightPaths = [indexesStraightPaths; experimentIndex subpathIdx];
                    type = "S";
                    %nonZeroPeaksCount = nonZeroPeaksCount + 1
                elseif all(subCurrentPath == 0) || (sum(subCurrentPath > 0) == 1)
                    % not complety curly path
                    %nonZeroPeaks = subCurrentPath(subCurrentPath~=0);
                    %semiCurlyInfo = [semiCurlyInfo; 
                    %                [experimentIndex subpathIdx distanceBetweenWaypoints lengthOfsubPath subCurrentPath]];
                    %nonCurlyAverageList = [nonCurlyAverageList; mean(nonZeroPeaks)/lengthOfsubPath];
                    type = "S"; 
                else
                    %curlyInfo = [curlyInfo; 
                    %             [experimentIndex subpathIdx distanceBetweenWaypoints lengthOfsubPath subCurrentPath]];
                    %CurlyAverageList = [CurlyAverageList; mean(subCurrentPath)/lengthOfsubPath];
                    type = "U";
                end
                fullPathEvaluation = [fullPathEvaluation type];
            end
            experimentsCount = [experimentsCount; fullPathEvaluation];
            allPathsEvaluations = [allPathsEvaluations; fullPathEvaluation];
            %if distanceFromOriginal <= maxDistanceFromOrignalWpt % only consider the waypoints that are within the pareto front objective 2
            %    limitedAllPathsEvaluations = [limitedAllPathsEvaluations; fullPathEvaluation];
            %end

            % TODO penalize with the distance between waypoints? 
            
    
        end
       
        experimentsCountMap(string(experimentNumber)) = experimentsCount;
    
        % for subpathIDx = 1:size(subPathPerformance,1)
        %     currentPath = subPathPerformance(subpathIDx,2:end)
        %     if all(currentPath > 0)
        %         curlyPaths = curlyPaths +1;
        %     elseif all(currentPath == -1)
        %         missignPaths = missignPaths + 1;
        %     else
        %         normalPaths = normalPaths + 1;
        %     end
        % end
        % experimentsPerformance(experimentNumber,:) = [normalPaths curlyPaths missignPaths]
    
    
        % for pathIdx = 1:6:size(subPathPerformance,1)
        %     currentPath = subPathPerformance(pathIdx:pathIdx+5,:)
        %     size(currentPath)
        % end
    
       
    end
    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-ProssesedPathPerformance",".mat");
    save(resultsPath, "indexesMissingPaths", "indexesStraightPaths", "semiCurlyInfo", "curlyInfo", "allPathsEvaluations", "limitedAllPathsEvaluations", "experimentsCountMap");
end

function [indexesMissingPaths, indexesStraightPaths, semiCurlyInfo, curlyInfo, allPathsEvaluations, limitedAllPathsEvaluations, experimentsCountMap]  = extractCalculatedCurliness(ship, searchProcess, validExperiments, populationSize, numGenerations)
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    searchProcess

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-ProssesedPathPerformance",".mat");
    load(resultsPath, "indexesMissingPaths", "indexesStraightPaths", "semiCurlyInfo", "curlyInfo", "allPathsEvaluations", "limitedAllPathsEvaluations", "experimentsCountMap");
end