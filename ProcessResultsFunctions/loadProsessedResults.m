function [experimentPerformance, totalObjectives] = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations)

    
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber),".mat");
    if exist(resultsPath) == 2
        load(resultsPath, "experimentPerformance", "totalObjectives")
    else
        [experimentPerformance, totalObjectives] = CalculateFeaturesExperiment(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    end


end