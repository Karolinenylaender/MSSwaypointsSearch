%% use this function to extract the population from the raw data

nuumExperiments = 30;
extractPopulationFromRawData("mariner", 30)
extractPopulationFromRawData("nspauv", 30)
extractPopulationFromRawData("remus100", 30)


function extractPopulationFromRawData(ship, numExperiments)
    searchProcesses = ["RndSearch", "WPgenSeed", "WPgenComb", "WPgenRnd"];
    populationSize = 10;
    numGenerations = 100;
    for searchProcess = searchProcesses
        for experimentNumber = 1:numExperiments
            
            experimentFolderName = append(searchProcess,"-ex", string(experimentNumber),"/");
        
            folderName = append("ExtractedPopulations/",experimentFolderName);
            resultsPathInfo = what("ProcessedResults");
            resultsFolder = char(resultsPathInfo.path);
            for generation = 1:numGenerations
                [Population, ~] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
                resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");
        
                save(resultsPath, 'Population');
            end
        end
    end
end