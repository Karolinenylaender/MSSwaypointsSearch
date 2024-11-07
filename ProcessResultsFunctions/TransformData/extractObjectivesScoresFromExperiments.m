
close all
clear all

%ship = "nspauv";
ship = "mariner"
%ship = "remus100";

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


%startExperiment = 15;
%maxExperiments =  startExperiment+30;
populationSize = 10; 

if searchProcess == "minDistanceMaxPath"
    validExperiments =  9:10 %9:30 % 1:30%
else searchProcess == "randomSearch"
    %validExperiments = [1 2 3 4 5 7 8 9 10 11 12 13 ];    14:30
    validExperiments =  16:18 %14:30% 21:24 %21:24;

end

numGenerations = 1000; 


for experimentNumber = validExperiments
    extractObjectivesScores(ship, searchProcess, experimentNumber, populationSize, numGenerations)

end


function extractObjectivesScores(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    end
    folderName = append("ExtractedPopulations/",experimentFolderName) 
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    for generation = 1:numGenerations
        [Population, ~] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");

        save(resultsPath, 'Population');
    end

end