% classify paths
%% Classificiation

close all
clear all


populationSize = 10; 
numGenerations = 1000;


ship = "nspauv";
%ship = "mariner"
%ship = "remus100";

searchProcess = "randomSearch";
%searchProcess = "minDistanceMaxPath";
%searchProcess = "HalfHalfMutation"

if ship == "mariner"
    SearchValidExperiments = 1:14; 
    RandomValidExperiments = 1:30;
    HalfValidExperiments = 0;
elseif ship == "nspauv"
    SearchValidExperiments =  1:30% [1 7 8 9 15] % 2 3 4 5 6 10 11 12 13 14 16:30 %1:30; % 10
    RandomValidExperiments =  [1:12 14:30] % 1 3   13  22 23 24 25 27:30  %%  1:30;  1:6 15 
    HalfValidExperiments = 1:6 %2:3; %4:30 % 1  
elseif ship == "remus100"
    SearchValidExperiments = 1:30
    RandomValidExperiments = 1:30
    HalfValidExperiments = 1:11 %10:11 %1:11; % 12:30
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


experimentsPerformance = zeros(length(validExperiments),3);
for experimentNumber = validExperiments
    curlyPaths = 0;
    missignPaths = 0;
    normalPaths = 0;

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat")
    load(resultsPath, "subPathPerformance", "experimentPerformance");
    size(subPathPerformance);
    size(experimentPerformance);
    for subpathIDx = 1:size(subPathPerformance,1)
        currentPath = subPathPerformance(subpathIDx,2:end);
        if all(currentPath > 0)
            curlyPaths = curlyPaths +1;
        elseif all(currentPath == -1)
            missignPaths = missignPaths + 1;
        else
            normalPaths = normalPaths + 1;
        end
    end
    experimentsPerformance(experimentNumber,:) = [normalPaths curlyPaths missignPaths]


    % for pathIdx = 1:6:size(subPathPerformance,1)
    %     currentPath = subPathPerformance(pathIdx:pathIdx+5,:)
    %     size(currentPath)
    % end

   
end
100*sum(experimentsPerformance)/(sum(sum(experimentsPerformance)))

%100*sum(experimentsPerformance)/(sum(sum(experimentsPerformance)))
%100*experimentsPerformance/length(subPathPerformance)
