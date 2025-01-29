
close all
clear all

numGenerations = 1000; 
populationSize = 10; 


ship = "mariner"
%ship = "nspauv";
%ship = "remus100";

%searchProcess = "randomSearch";
%searchProcess = "minDistanceMaxPath";
%searchProcess = "HalfHalfMutation"
searchProcess = "randInitPop"

if ship == "mariner"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30; 
    randomNSGAValidExperiments = 28; %1:30 
elseif ship == "nspauv"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30;
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


for experimentNumber = validExperiments
    extractObjectivesScores(ship, searchProcess, experimentNumber, populationSize, numGenerations)

end


function extractObjectivesScores(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "HalfHalfMutation"
        experimentFolderName = append("half-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "randInitPop"
        experimentFolderName = append("randInit-ex", string(experimentNumber),"/"); 
    
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